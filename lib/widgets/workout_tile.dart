import 'package:flutter/material.dart';

import '../Custom/custom_dialog.dart';
import '../screens/create_workout.dart';
import '../screens/workout_page.dart';
import '../providers/workout.dart';

// ignore: must_be_immutable
class WorkoutTile extends StatelessWidget {
  final Workout workout;
  bool isDeletable;
  bool isAdmin;

  WorkoutTile(this.workout, this.isDeletable, this.isAdmin);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        alignment: isDeletable ? Alignment.centerLeft : Alignment.center,
        children: [
          Container(
            height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
            width: double.infinity,
            child: workout.bannerImageLink == null
                ? workout.bannerImage == null
                    ? Image.asset(
                        'assets/images/BannerImageUnavailable.png',
                        fit: BoxFit.cover,
                      )
                    : FadeInImage(
                        placeholder:
                            AssetImage('assets/images/loading-gif.gif'),
                        placeholderErrorBuilder: (context, _, __) =>
                            Image.asset(
                          'assets/images/loading-gif.gif',
                          fit: BoxFit.contain,
                        ),
                        fit: BoxFit.cover,
                        //change
                        image: FileImage(workout.bannerImage!),
                        imageErrorBuilder: (image, _, __) => Image.asset(
                          'assets/images/ImageUploadError.png',
                          fit: BoxFit.cover,
                        ),
                      )
                : FadeInImage(
                    placeholder: AssetImage('assets/images/loading-gif.gif'),
                    placeholderErrorBuilder: (context, _, __) => Image.asset(
                      'assets/images/loading-gif.gif',
                      fit: BoxFit.contain,
                    ),
                    fit: BoxFit.cover,
                    //change
                    image: NetworkImage(workout.bannerImageLink!),
                    imageErrorBuilder: (image, _, __) => Image.asset(
                      'assets/images/ImageUploadError.png',
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          Container(
            height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
            width: double.infinity,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () {
                Navigator.of(context).pushNamed(
                  WorkoutPage.routeName,
                  arguments: Workout(
                    pending: workout.pending,
                    date: workout.date,
                    creatorName: workout.creatorName,
                    creatorId: workout.creatorId,
                    workoutId: workout.workoutId,
                    workoutName: workout.workoutName,
                    instagram: workout.instagram,
                    facebook: workout.facebook,
                    tumblrPageLink: workout.tumblrPageLink,
                    bannerImage: workout.bannerImage,
                    bannerImageLink: workout.bannerImageLink,
                    exercises: workout.exercises,
                  ),
                );
              },
            ),
          ),
          isDeletable
              ? Container(
                  width: double.infinity,
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: Container(
                          width: _mediaQuery.size.width * 0.6,
                          height:
                              (_mediaQuery.size.height - _appBarHieght) * 0.25,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            workout.workoutName,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize:
                                  (_mediaQuery.size.height - _appBarHieght) *
                                      0.06,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 1.0,
                                  color: Color.fromARGB(255, 128, 128, 128),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              AddWorkoutScreen.routeName,
                              arguments: {'workout': workout, 'isEdit': true});
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.grey[100],
                        iconSize: (_mediaQuery.size.height * 0.06),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => CustomDialogBox(
                                'Are You Sure?',
                                'This action will delete the workout and it can never be recoverd',
                                'assets/images/trash.png',
                                'pop',
                                workout),
                          );
                        },
                        icon: Icon(Icons.delete_outline),
                        color: Colors.red[300],
                        iconSize: (_mediaQuery.size.height * 0.06),
                      ),
                    ],
                  ),
                )
              : isAdmin
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => CustomDialogBox(
                                        'Accept Workout?',
                                        'Does The Workout Meet Standards?',
                                        'assets/images/teen_fit_logo_white_withpeople_withbackground.png',
                                        'accept-workout',
                                        workout));
                              },
                              icon: Icon(
                                Icons.check_box,
                                color: Colors.green,
                              ),
                              iconSize: (_mediaQuery.size.height * 0.06)),
                          Container(
                            width: _mediaQuery.size.width * 0.55,
                            height: (_mediaQuery.size.height - _appBarHieght) *
                                0.25,
                            alignment: Alignment.center,
                            child: Text(
                              workout.workoutName,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize:
                                    (_mediaQuery.size.height - _appBarHieght) *
                                        0.06,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(3.0, 3.0),
                                    blurRadius: 1.0,
                                    color: Color.fromARGB(255, 128, 128, 128),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => CustomDialogBox(
                                        'Delete Workout?',
                                        'Does The Workout Not Meet Standards?',
                                        'assets/images/teen_fit_logo_white_withpeople_withbackground.png',
                                        'pop',
                                        workout));
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[300],
                              ),
                              iconSize: (_mediaQuery.size.height * 0.06)),
                        ],
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: _mediaQuery.size.width * 0.8,
                          height:
                              (_mediaQuery.size.height - _appBarHieght) * 0.25,
                          alignment: Alignment.center,
                          child: Text(
                            workout.workoutName,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize:
                                  (_mediaQuery.size.height - _appBarHieght) *
                                      0.06,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 1.0,
                                  color: Color.fromARGB(255, 128, 128, 128),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
          isAdmin
              ? SizedBox()
              : workout.pending
                  ? Stack(children: [
                      Container(
                        height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/pending.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
                        width: double.infinity,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              WorkoutPage.routeName,
                              arguments: Workout(
                                pending: workout.pending,
                                date: workout.date,
                                creatorName: workout.creatorName,
                                creatorId: workout.creatorId,
                                workoutId: workout.workoutId,
                                workoutName: workout.workoutName,
                                instagram: workout.instagram,
                                facebook: workout.facebook,
                                tumblrPageLink: workout.tumblrPageLink,
                                bannerImage: workout.bannerImage,
                                bannerImageLink: workout.bannerImageLink,
                                exercises: workout.exercises,
                              ),
                            );
                          },
                        ),
                      ),
                    ])
                  : SizedBox(),
        ],
      ),
    );
  }
}
