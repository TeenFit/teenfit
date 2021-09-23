import 'package:flutter/material.dart';
import 'package:teenfit/providers/exercise.dart';

class ExerciseTiles extends StatelessWidget {
  final Exercise exercise;

  ExerciseTiles(this.exercise);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);
    final _statusBarHeight = _mediaQuery.padding.top;

    return Container(
      height: _mediaQuery.size.height * 0.2,
      width: _mediaQuery.size.width,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: _mediaQuery.size.height * 0.015,
              width: _mediaQuery.size.width * 0.07,
              child: FadeInImage(
                placeholder: AssetImage('assets/images/loading-gif.gif'),
                image: NetworkImage(exercise.exerciseImageLink),
              ),
            )
          ],
        ),
      ),
    );
  }
}
