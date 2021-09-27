import 'package:flutter/material.dart';
import 'package:teenfit/screens/workout_page.dart';

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
          Ink.image(
            fit: BoxFit.cover,
            image: workout.bannerImage.isEmpty
                ? AssetImage('assets/images/BannerImageUnavailable.png')
                : AssetImage(workout.bannerImage),
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(WorkoutPage.routeName, arguments: workout);
              },
            ),
            height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
            width: double.infinity,
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
                        onPressed: () {},
                        icon: Icon(Icons.edit),
                        color: Colors.grey,
                        iconSize: (_mediaQuery.size.height * 0.06),
                      ),
                      IconButton(
                        onPressed: () {},
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
