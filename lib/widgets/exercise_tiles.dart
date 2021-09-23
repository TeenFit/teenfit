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
        color: _theme.shadowColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                height: _mediaQuery.size.height * 0.18,
                width: _mediaQuery.size.width * 0.5,
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/loading-gif.gif'),
                  image: NetworkImage(exercise.exerciseImageLink),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 10, 15),
              child: Container(
                width: _mediaQuery.size.width * 0.3,
                height: _mediaQuery.size.height * 0.18,
                child: Text(
                  exercise.name,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PTSans',
                    fontSize: _mediaQuery.size.height * 0.035,
                    letterSpacing: 1,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
