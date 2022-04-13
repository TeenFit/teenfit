import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  PageController pageController = PageController();
  int selectedIndex = 0;

  void goToPage(index) {
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void goToFirst() {
    pageController.animateToPage(0,
        duration: Duration(milliseconds: 800), curve: Curves.easeIn);
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
      backgroundColor: _theme.primaryColor,
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
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
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: _mediaQuery.size.height - _appBarHeight,
            width: _mediaQuery.size.width,
            child: PageView(
              onPageChanged: (value) => setState(() {
                selectedIndex = value;
              }),
              controller: pageController,
              children: [
                ...exercises.map(
                  (exercise) => ExercisePage(
                    exercise,
                    goToPage,
                    selectedIndex,
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
