import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:teenfit/Custom/custom_dialog.dart';
import 'package:teenfit/screens/workout_page.dart';
import 'package:teenfit/widgets/start_workout/end_workout.dart';

import '../widgets/start_workout/exercise_page.dart';
import '../providers/exercise.dart';

class ExerciseScreen extends StatefulWidget {
  static const routeName = '/exercise-screen';

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  CarouselController _carouselController = CarouselController();

  void goToNext() {
    _carouselController.nextPage();
  }

  void goToPrevious() {
    _carouselController.previousPage();
  }

  void goToFirst() {
    _carouselController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    //add carousel

    final List<Exercise> exercises =
        ModalRoute.of(context)!.settings.arguments as List<Exercise>;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _theme.shadowColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => CustomDialogBox(
                  'End Workout',
                  'Are You Sure You Want To End Your Workout?',
                  'assets/images/teen_fit_logo_white_withpeople_withbackground.png',
                  WorkoutPage.routeName,
                  ''),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                height: (_mediaQuery.size.height - _appBarHeight) * 0.9,
                initialPage: 0,
                enableInfiniteScroll: false,
                autoPlay: false,
                reverse: false,
                enlargeCenterPage: false,
              ),
              carouselController: _carouselController,
              items: [
                ...exercises.map(
                  (exercise) => ExercisePage(
                    exercise,
                    goToNext,
                    goToPrevious,
                  ),
                ),
                EndWorkout(goToFirst),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
