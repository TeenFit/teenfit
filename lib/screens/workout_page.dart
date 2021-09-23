import 'package:flutter/material.dart';

import '../providers/workout.dart';

class WorkoutPage extends StatelessWidget {
  static const routeName = '/workout-page';

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);
    final _statusBarHeight = _mediaQuery.padding.top;

    final Workout workout =
        ModalRoute.of(context)!.settings.arguments as Workout;
    return Scaffold(
      backgroundColor: _theme.highlightColor,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: _mediaQuery.size.height,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: _mediaQuery.size.height * 0.35,
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    workout.bannerImage.isEmpty
                        ? 'assets/images/BannerImageUnavailable.png'
                        : workout.bannerImage,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: _mediaQuery.size.height * 0.35,
                        width: _mediaQuery.size.width * 0.1,
                        child: Column(
                          children: [
                            SizedBox(
                              height: _statusBarHeight,
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.arrow_back),
                              iconSize: _appBarHeight * 0.55,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: _mediaQuery.size.height * 0.35,
                        width: _mediaQuery.size.width * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: _statusBarHeight,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 15, 5),
                              child: Text(
                                workout.workoutName,
                                maxLines: 2,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontSize: _mediaQuery.size.height * 0.05,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Container(
                              width: _mediaQuery.size.width * 0.55,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 15, 5),
                                  child: Text(
                                    'by: ${workout.creatorName}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSans',
                                      fontSize: _mediaQuery.size.height * 0.035,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
