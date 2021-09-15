import 'package:flutter/material.dart';
import 'package:teenfit/providers/workout.dart';

class WorkoutTile extends StatelessWidget {
  Workout workout;

  WorkoutTile(this.workout);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;
    final _theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            fit: BoxFit.cover,
            image: workout.bannerImage.isEmpty
                ? AssetImage('asset/images/BannerImageUnavailable.png')
                : AssetImage(workout.bannerImage),
            child: InkWell(
              onTap: () {},
            ),
            height: (_mediaQuery.size.height - _appBarHieght) * 0.35,
            width: double.infinity,
          ),
          Center(
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
                  fontSize: (_mediaQuery.size.height - _appBarHieght) * 0.06,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(4.0, 4.0),
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
