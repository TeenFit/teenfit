import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';

import '/providers/exercise.dart';

class ExercisePage extends StatelessWidget {
  final Exercise exercise;
  final CarouselController carouselController;

  ExercisePage(this.exercise, this.carouselController);

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

    return Container(
      height: _mediaQuery.size.height - _appBarHeight,
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
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: (_mediaQuery.size.height - _appBarHeight) * 0.15,
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
          )
        ],
      ),
    );
  }
}
