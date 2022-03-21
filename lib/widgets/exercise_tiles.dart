import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Custom/custom_dialog.dart';
import '../screens/add_exercise_screen.dart';
import '../providers/exercise.dart';

class ExerciseTiles extends StatelessWidget {
  final Exercise exercise;
  final double size;
  final bool isDeleteable;
  final Function delete;
  final Function addExercise;
  final Function updateExercise;

  ExerciseTiles({
    Key? key,
    required this.exercise,
    required this.size,
    required this.isDeleteable,
    required this.delete,
    required this.addExercise,
    required this.updateExercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);

    return Container(
      color: Colors.transparent,
      height: exercise.reps2 == null
          ? _mediaQuery.size.height * 0.2
          : _mediaQuery.size.height * 0.43,
      width: size,
      child: Card(
        color: _theme.shadowColor,
        child: Column(
          children: [
            Text(
              'SUPERSET',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'PTSans',
                fontSize: _mediaQuery.size.height * 0.02,
                letterSpacing: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    height: _mediaQuery.size.height * 0.18,
                    width: size * 0.5,
                    child: exercise.exerciseImage == null
                        ? FadeInImage(
                            imageErrorBuilder: (context, image, _) =>
                                Image.asset(
                              'assets/images/ImageUploadError.png',
                              fit: BoxFit.contain,
                            ),
                            placeholder:
                                AssetImage('assets/images/loading-gif.gif'),
                            image: CachedNetworkImageProvider(
                                exercise.exerciseImageLink!),
                            fit: BoxFit.contain,
                          )
                        : FadeInImage(
                            imageErrorBuilder: (context, image, _) =>
                                Image.asset(
                              'assets/images/ImageUploadError.png',
                              fit: BoxFit.cover,
                            ),
                            placeholder:
                                AssetImage('assets/images/loading-gif.gif'),
                            image: FileImage(exercise.exerciseImage!),
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 5, 5),
                  child: Container(
                    width: size * 0.3,
                    height: _mediaQuery.size.height * 0.2,
                    child: Column(
                      children: [
                        Text(
                          exercise.name,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'PTSans',
                            fontSize: _mediaQuery.size.height * 0.025,
                            letterSpacing: 1,
                          ),
                        ),
                        isDeleteable
                            ? FittedBox(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                          AddExerciseScreen.routeName,
                                          arguments: {
                                            'addExercise': addExercise,
                                            'updateExercise': updateExercise,
                                            'edit': true,
                                            'exercise': Exercise(
                                                name2: exercise.name2,
                                                exerciseImage2:
                                                    exercise.exerciseImage2,
                                                exerciseImageLink2:
                                                    exercise.exerciseImageLink2,
                                                reps2: exercise.reps2,
                                                exerciseImageLink:
                                                    exercise.exerciseImageLink,
                                                exerciseId: exercise.exerciseId,
                                                exerciseImage:
                                                    exercise.exerciseImage,
                                                name: exercise.name,
                                                reps: exercise.reps,
                                                sets: exercise.sets,
                                                restTime: exercise.restTime,
                                                timeSeconds:
                                                    exercise.timeSeconds),
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.edit),
                                      color: Colors.grey[200],
                                      iconSize: _mediaQuery.size.height * 0.05,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => CustomDialogBox(
                                            'Are You Sure?',
                                            'This action will delete the exercise and it can never be recoverd',
                                            'assets/images/trash.png',
                                            'delete-exercise',
                                            {
                                              'delete': delete,
                                              'id': exercise.exerciseId,
                                            },
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                      iconSize: _mediaQuery.size.height * 0.05,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        exercise.reps2 != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Container(
                                      height: _mediaQuery.size.height * 0.18,
                                      width: size * 0.5,
                                      child: exercise.exerciseImage2 == null
                                          ? FadeInImage(
                                              imageErrorBuilder:
                                                  (context, image, _) =>
                                                      Image.asset(
                                                'assets/images/ImageUploadError.png',
                                                fit: BoxFit.contain,
                                              ),
                                              placeholder: AssetImage(
                                                  'assets/images/loading-gif.gif'),
                                              image: CachedNetworkImageProvider(
                                                  exercise.exerciseImageLink2!),
                                              fit: BoxFit.contain,
                                            )
                                          : FadeInImage(
                                              imageErrorBuilder:
                                                  (context, image, _) =>
                                                      Image.asset(
                                                'assets/images/ImageUploadError.png',
                                                fit: BoxFit.cover,
                                              ),
                                              placeholder: AssetImage(
                                                  'assets/images/loading-gif.gif'),
                                              image: FileImage(
                                                  exercise.exerciseImage2!),
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 15, 5, 5),
                                    child: Container(
                                      width: size * 0.3,
                                      height: _mediaQuery.size.height * 0.2,
                                      child: Column(
                                        children: [
                                          Text(
                                            exercise.name2!,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'PTSans',
                                              fontSize:
                                                  _mediaQuery.size.height *
                                                      0.025,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
