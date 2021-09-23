import 'package:flutter/material.dart';
import '/Custom/custom_dialog.dart';
import '/screens/workout_page.dart';

class EndWorkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Container(
      height: (_mediaQuery.size.height - _appBarHieght) * 0.95,
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
              width: _mediaQuery.size.width,
              child: Image.asset(
                'assets/images/end_page.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              height: (_mediaQuery.size.height - _appBarHieght) * 0.08,
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'Good Work!',
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
            height: (_mediaQuery.size.height - _appBarHieght) * 0.3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: (_mediaQuery.size.height - _appBarHieght) * 0.08,
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  'End Workout?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PTSans',
                      fontSize: _mediaQuery.size.height * 0.035),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => CustomDialogBox(
                          'End Workout',
                          'Are You Sure You Want To End Your Workout?',
                          'assets/images/teen_fit_logo_white_withpeople_withbackground.png',
                          WorkoutPage.routeName,
                          ''));
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    primary: _theme.highlightColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
