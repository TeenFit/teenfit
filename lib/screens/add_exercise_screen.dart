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
    Map exercise = ModalRoute.of(context)!.settings.arguments as Map;

    List<Exercise> exercises = exercise['exercises'];
    bool isEdit = exercise['edit'];
    Exercise _exercise = exercise['exercise'];

    return Scaffold(
      appBar: AppBar(),
    );
  }
}
