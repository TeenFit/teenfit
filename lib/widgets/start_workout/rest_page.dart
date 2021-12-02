import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import 'package:flutter/material.dart';

import '/providers/exercise.dart';

class RestPage extends StatelessWidget { 
  final Exercise exercise;   
  final Function goToNext;
  final CountDownController _restCountDownController;

  RestPage(this.exercise, this.goToNext, this._restCountDownController);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    return SingleChildScrollView(
      child: Container(
        height: (_mediaQuery.size.height - _appBarHeight) * 0.95,
        width: _mediaQuery.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: (_mediaQuery.size.height - _appBarHeight) * 0.3,
                width: _mediaQuery.size.width,
                child: Image.asset(
                  'assets/images/rest_page.png',
                  fit: BoxFit.cover,
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
                    iconSize: (_mediaQuery.size.height - _appBarHeight) * 0.18,
                    onPressed: () {
                      _restCountDownController.pause();
                    },
                    icon: Icon(Icons.pause),
                    color: _theme.highlightColor,
                  ),
                  CircularCountDownTimer(
                    initialDuration: 0,
                    autoStart: true,
                    controller: _restCountDownController,
                    width: (_mediaQuery.size.height - _appBarHeight) * 0.15,
                    height: (_mediaQuery.size.height - _appBarHeight) * 0.15,
                    duration: exercise.restTime!.toInt(),
                    backgroundColor: _theme.shadowColor,
                    fillColor: _theme.primaryColor,
                    ringColor: _theme.highlightColor,
                    strokeWidth: _mediaQuery.size.width * 0.06,
                    onComplete: () {
                      goToNext();
                    },
                    isReverse: true,
                    isReverseAnimation: false,
                    strokeCap: StrokeCap.round,
                    textFormat: CountdownTextFormat.S,
                    textStyle: TextStyle(
                        fontSize:
                            (_mediaQuery.size.height - _appBarHeight) * 0.06,
                        color: _theme.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    iconSize: (_mediaQuery.size.height - _appBarHeight) * 0.18,
                    onPressed: () {
                      _restCountDownController.restart();
                    },
                    icon: Icon(Icons.play_arrow),
                    color: _theme.highlightColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
