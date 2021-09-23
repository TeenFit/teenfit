import 'package:carousel_slider/carousel_controller.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import 'package:flutter/material.dart';

import '/providers/exercise.dart';

class ExercisePage extends StatelessWidget {
  final Exercise exercise;
  final CarouselController carouselController;
  final CountDownController countDownController;

  ExercisePage(this.exercise, this.carouselController, this.countDownController);

  void goToNext() {
    carouselController.nextPage();
  }

  void goToPrevious() {
    carouselController.previousPage();
  }

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: (_mediaQuery.size.height - _appBarHeight) * 0.3,
                width: _mediaQuery.size.width,
                child: Image.network(
                  exercise.exerciseImageLink,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: (_mediaQuery.size.height - _appBarHeight) * 0.1,
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    exercise.name,
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
                children: [],
              ),
            )
          ],
        ),
      ),
    );
  }
}
