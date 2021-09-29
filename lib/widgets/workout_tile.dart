import 'package:flutter/material.dart';

import '../Custom/custom_dialog.dart';
import '../screens/add_workout_screen.dart';
import '../screens/workout_page.dart';
import '../providers/workout.dart';

// ignore: must_be_immutable
class WorkoutTile extends StatelessWidget {
  final Workout workout;
  bool isDeletable;

  WorkoutTile(this.workout, this.isDeletable);

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
            child: FadeInImage(
              placeholder: AssetImage('assets/images/loading-gif.gif'),
              placeholderErrorBuilder: (context, _, __) => Image.asset(
                'assets/images/loading-gif.gif',
                fit: BoxFit.contain,
              ),
              fit: BoxFit.cover,
              image: workout.bannerImage.isEmpty
                  ? AssetImage('assets/images/BannerImageUnavailable.png')
                  : AssetImage(workout.bannerImage),
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
                Navigator.of(context)
                    .pushNamed(WorkoutPage.routeName, arguments: workout);
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
                                      0.055,
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
                              arguments: workout);
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
                                'This Action Will Delete The Workout And It Can Never Be Recoverd',
                                'assets/images/trash.png',
                                'pop',
                                workout.workoutId),
                          );
                        },
                        icon: Icon(Icons.delete_outline),
                        color: Colors.red[300],
                        iconSize: (_mediaQuery.size.height * 0.06),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      workout.workoutName,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize:
                            (_mediaQuery.size.height - _appBarHieght) * 0.06,
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
        ],
      ),
    );
  }
}
