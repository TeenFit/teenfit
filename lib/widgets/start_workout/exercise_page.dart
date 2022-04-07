import 'package:flutter/material.dart';
import 'package:teenfit/widgets/start_workout/exercise_page_types/sets_reps_page.dart';
import 'package:teenfit/widgets/start_workout/exercise_page_types/superset_page.dart';
import 'package:teenfit/widgets/start_workout/exercise_page_types/time_page.dart';

import '/providers/exercise.dart';

class ExercisePage extends StatelessWidget {
  final Exercise exercise;
  final Function goToPage;
  final int index;

  ExercisePage(this.exercise, this.goToPage, this.index);

  @override
  Widget build(BuildContext context) {
    return exercise.restTime != null
        ? TimePage(exercise, goToPage, index)
        : exercise.reps2 != null
            ? SuperSetPage(exercise, goToPage, index)
            : SetsAndRepsPage(exercise, goToPage, index);
  }
}
