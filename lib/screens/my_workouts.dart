import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/auth.dart';
import 'package:uuid/uuid.dart';

import '/providers/workout.dart';
import 'create_workout.dart';
import '/providers/workouts.dart';
import '/widgets/workout_tile.dart';

class CreateWorkout extends StatelessWidget {
  static const routeName = '/create-workout';

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    var uuid = Uuid();

    String uid = Provider.of<Auth>(context, listen: false).userId;

    return Scaffold(
      backgroundColor: _theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
            IconThemeData(color: Colors.white, size: _appBarHeight * 0.5),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddWorkoutScreen.routeName,
                  arguments: {
                    'workout': Workout(
                      creatorName: '',
                      creatorId: uid,
                      workoutId: uuid.v4(),
                      workoutName: '',
                      instagram: '',
                      facebook: '',
                      tumblrPageLink: '',
                      bannerImage: '',
                      exercises: [],
                    ),
                    'isEdit': false
                  },
                );
              },
              icon: Icon(
                Icons.add_box_outlined,
                color: Colors.white,
                size: _appBarHeight * 0.45,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: _mediaQuery.size.height,
        width: _mediaQuery.size.width,
        child: Consumer<Workouts>(
          builder: (ctx, workout, _) =>  ListView.builder(
            itemBuilder: (ctx, index) {
              return workout.findByCreatorId(uid).length == 0
                  ? Container(
                      height: (_mediaQuery.size.height - _appBarHeight),
                      width: _mediaQuery.size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height:
                                (_mediaQuery.size.height - _appBarHeight) * 0.05,
                          ),
                          Container(
                            height:
                                (_mediaQuery.size.height - _appBarHeight) * 0.05,
                            width: _mediaQuery.size.width * 0.8,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'Create Your First Workout...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _mediaQuery.size.height * 0.025,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : WorkoutTile(
                      workout.findByCreatorId(uid)[index],
                      true,
                    );
            },
            itemCount: workout.findByCreatorId(uid).length == 0
                ? 1
                : workout.findByCreatorId(uid).length,
          ),
        ),
      ),
    );
  }
}
