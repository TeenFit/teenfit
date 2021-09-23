import 'package:flutter/material.dart';
import '../providers/exercise.dart';

class ExerciseScreen extends StatelessWidget {
  static const routeName = '/exercise-screen';

  @override
  Widget build(BuildContext context) {
    final List<Exercise> exercises =
        ModalRoute.of(context)!.settings.arguments as List<Exercise>;

    return Scaffold(
      appBar: AppBar(),
    );
  }
}
