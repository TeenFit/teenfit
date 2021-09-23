import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import '/widgets/start_workout/rest_page.dart';

import '/providers/exercise.dart';

class ExercisePage extends StatefulWidget {
  final Exercise exercise;
  final Function goToNext;
  final CountDownController countDownController;
  final CountDownController restCountDownController;

  ExercisePage(this.exercise, this.goToNext, this.countDownController,
      this.restCountDownController);

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  bool isRest = false;

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    return isRest == true
        ? RestPage(
            widget.exercise,
            widget.goToNext,
            widget.restCountDownController,
          )
        : Container(
            height: (_mediaQuery.size.height - _appBarHeight) * 0.95,
            width: _mediaQuery.size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: (_mediaQuery.size.height - _appBarHeight) * 0.3,
                    width: _mediaQuery.size.width,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/loading-gif.gif'),
                      image: NetworkImage(widget.exercise.exerciseImageLink),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: (_mediaQuery.size.height - _appBarHeight) * 0.08,
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        widget.exercise.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: _mediaQuery.size.height * 0.05,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.15,
                ),
                Container(
                  height: (_mediaQuery.size.height - _appBarHeight) * 0.3,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize:
                            (_mediaQuery.size.height - _appBarHeight) * 0.18,
                        onPressed: () {
                          widget.countDownController.pause();
                        },
                        icon: Icon(Icons.pause),
                        color: _theme.cardColor,
                      ),
                      CircularCountDownTimer(
                        initialDuration: 0,
                        autoStart: true,
                        controller: widget.countDownController,
                        width: (_mediaQuery.size.height - _appBarHeight) * 0.15,
                        height:
                            (_mediaQuery.size.height - _appBarHeight) * 0.15,
                        duration: widget.exercise.timeSeconds,
                        backgroundColor: _theme.cardColor,
                        fillColor: _theme.primaryColor,
                        ringColor: _theme.highlightColor,
                        strokeWidth: _mediaQuery.size.width * 0.06,
                        onComplete: () {
                          setState(() {
                            isRest = true;
                          });
                        },
                        isReverse: true,
                        isReverseAnimation: false,
                        strokeCap: StrokeCap.round,
                        textFormat: CountdownTextFormat.S,
                        textStyle: TextStyle(
                            fontSize:
                                (_mediaQuery.size.height - _appBarHeight) *
                                    0.06,
                            color: _theme.shadowColor,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        iconSize:
                            (_mediaQuery.size.height - _appBarHeight) * 0.18,
                        onPressed: () {
                          widget.countDownController.restart();
                        },
                        icon: Icon(Icons.play_arrow),
                        color: _theme.cardColor,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
