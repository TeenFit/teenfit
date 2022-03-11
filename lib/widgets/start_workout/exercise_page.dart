import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:teenfit/widgets/start_workout/exercise_page_types/sets_reps_page.dart';
import 'package:teenfit/widgets/start_workout/exercise_page_types/time_page.dart';

import 'exercise_page_types/rest_page.dart';

import '/providers/exercise.dart';

class ExercisePage extends StatelessWidget {
  final Exercise exercise;
  final Function goToNext;
  final Function goToPrevious;

  ExercisePage(
    this.exercise,
    this.goToNext,
    this.goToPrevious,
  );

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    return exercise.restTime != null && exercise.timeSeconds != null
        ? TimePage(exercise, goToNext, goToPrevious)
        : SetsAndRepsPage(exercise, goToNext, goToPrevious);
  }
}
