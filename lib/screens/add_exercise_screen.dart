import 'package:flutter/material.dart';
import 'package:teenfit/providers/exercise.dart';

class AddExerciseScreen extends StatefulWidget {
  static const routeName = '/add-exercise-screen';

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    Map exercise = ModalRoute.of(context)!.settings.arguments as Map;

    List<Exercise> exercises = exercise['exercises'];
    bool isEdit = exercise['edit'];
    Exercise? _exercise = exercise['exercise'];

    return Scaffold(
      backgroundColor: _theme.highlightColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          isEdit ? 'Edit Your Exercise' : 'Add A Exercise',
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
    );
  }
}
