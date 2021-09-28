import 'package:flutter/material.dart';
import 'package:teenfit/providers/workout.dart';

class AddWorkoutScreen extends StatelessWidget {
  static const routeName = '/add-workout-screen';

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    Workout? workout = ModalRoute.of(context)?.settings.arguments as Workout?;

    return Scaffold(
      backgroundColor: _theme.highlightColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          workout == null ? 'Add A Workout' : 'Edit Your Workout',
          maxLines: 2,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: _mediaQuery.size.height * 0.03,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _mediaQuery.size.height * 0.05,
            ),
            
          ],
        ),
      ),
    );
  }
}
