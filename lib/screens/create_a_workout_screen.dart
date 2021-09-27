import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    final workout = Provider.of<Workouts>(context);

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
              onPressed: () {},
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
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return WorkoutTile(
              workout.findByCreatorId('uid')[index],
            );
          },
          itemCount: workout.findByCreatorId('uid').length,
        ),
      ),
    );
  }
}
