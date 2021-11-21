import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/providers/workouts.dart';
import '/widgets/workout_tile.dart';

class AdminScreen extends StatelessWidget {
  static const routeName = '/admin-screen';

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    return Scaffold(
      backgroundColor: _theme.primaryColor,
      appBar: AppBar(
        title: Text(
          'Admin Controls',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: _appBarHeight * 0.35,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
            IconThemeData(color: Colors.white, size: _appBarHeight * 0.5),
      ),
      body: Container(
        height: _mediaQuery.size.height,
        width: _mediaQuery.size.width,
        child: Consumer<Workouts>(
          builder: (ctx, workout, _) => ListView.builder(
            itemBuilder: (ctx, index) {
              return workout.isPendingWorkouts().length == 0
                  ? Container(
                      height: (_mediaQuery.size.height - _appBarHeight),
                      width: _mediaQuery.size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: (_mediaQuery.size.height - _appBarHeight) *
                                0.05,
                          ),
                          Container(
                            height: (_mediaQuery.size.height - _appBarHeight) *
                                0.05,
                            width: _mediaQuery.size.width * 0.8,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'No Workouts Pending...',
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
                      workout.isPendingWorkouts()[index],
                      false,
                      true,
                    );
            },
            itemCount: workout.isPendingWorkouts().length == 0
                ? 1
                : workout.isPendingWorkouts().length,
          ),
        ),
      ),
    );
  }
}

// use same format as my workouts page but create a new field in workout tiles called is Admin, which will allow the
// admin to view different controls, one is accept, and the other is deny with a message,
