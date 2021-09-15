import 'package:flutter/material.dart';
import 'package:teenfit/Custom/my_flutter_app_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Drawer(
      child: Container(
        height: _mediaQuery.size.height - _appBarHieght,
        width: double.infinity,
        color: _theme.accentColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: (_mediaQuery.size.height - _appBarHieght) * 0.25,
                child: Image.asset(
                  'assets/images/teen_fit_logo_withtext_white.png',
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  width: double.infinity,
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.075,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: _theme.highlightColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Create A Workout',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w900,
                          fontSize: _mediaQuery.size.height * 0.03,
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(15),
              //   child: Container(
              //     width: double.infinity,
              //     height: (_mediaQuery.size.height - _appBarHieght) * 0.075,
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //           primary: _theme.highlightColor,
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10))),
              //       child: FittedBox(
              //         fit: BoxFit.fitWidth,
              //         child: Text(
              //           'Saved Workouts',
              //           style: TextStyle(
              //             fontFamily: 'Roboto',
              //             fontWeight: FontWeight.w900,
              //             fontSize: _mediaQuery.size.height * 0.03,
              //           ),
              //         ),
              //       ),
              //       onPressed: () {},
              //     ),
              //   ),
              // ),
              SizedBox(
                height: (_mediaQuery.size.height - _appBarHieght) * 0.02,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.055,
                  width: double.infinity,
                  child: Text(
                    'Questions?',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w900,
                      fontSize: _mediaQuery.size.height * 0.05,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Container(
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.03,
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            launch('https://www.instagram.com/teenfittest/');
                          },
                          icon: Icon(
                            MyFlutterApp.instagram,
                            size: _mediaQuery.size.height * 0.05,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        IconButton(
                          onPressed: () {
                            launch('https://www.facebook.com/teenfittest/');
                          },
                          icon: Icon(
                            MyFlutterApp.facebook_squared,
                            size: _mediaQuery.size.height * 0.05,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        IconButton(
                          onPressed: () {
                            launch('https://teenfittest.tumblr.com/');
                          },
                          icon: Icon(
                            MyFlutterApp.tumblr_squared,
                            size: _mediaQuery.size.height * 0.05,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _mediaQuery.size.height * 0.25,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Container(
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.09,
                  width: double.infinity,
                  child: TextButton(
                    child: Text(
                      'Log Out?',
                      style: TextStyle(
                        color: _theme.highlightColor,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w900,
                        fontSize: _mediaQuery.size.height * 0.04,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
