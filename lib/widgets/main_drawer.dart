import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/screens/admin_screen.dart';
import 'package:teenfit/screens/user_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '/providers/auth.dart';
import '../screens/my_workouts.dart';
import '../Custom/my_flutter_app_icons.dart';

class MainDrawer extends StatelessWidget {
  final bool connected;

  MainDrawer(this.connected);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    final auth = Provider.of<Auth>(context);

    void _showToast(String msg) {
      Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        webShowClose: true,
        textColor: Colors.white,
        backgroundColor: Colors.grey.shade700,
      );
    }

    return Drawer(
      child: Container(
        height: _mediaQuery.size.height - _appBarHieght,
        width: double.infinity,
        color: _theme.cardColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: _mediaQuery.padding.top * 1.2,
              ),
              ListTile(
                leading: Icon(
                  Icons.person_rounded,
                  color: _theme.highlightColor,
                  size: _mediaQuery.size.height * 0.08,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(UserScreen.routeName);
                },
              ),
              SizedBox(
                height: _mediaQuery.size.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: connected
                    ? Container(
                        width: double.infinity,
                        height:
                            (_mediaQuery.size.height - _appBarHieght) * 0.075,
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
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(CreateWorkout.routeName);
                          },
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height:
                            (_mediaQuery.size.height - _appBarHieght) * 0.075,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: _theme.highlightColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.wifi_off,
                                  color: Colors.red[300],
                                  size: _mediaQuery.size.height * 0.03,
                                ),
                                SizedBox(
                                  width: _mediaQuery.size.width * 0.02,
                                ),
                                Text(
                                  'Create A Workout',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w900,
                                    color: Colors.red[300],
                                    fontSize: _mediaQuery.size.height * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
              ),
              auth.isAdmin()
                  ? Padding(
                      padding: EdgeInsets.all(15),
                      child: connected
                          ? Container(
                              width: double.infinity,
                              height:
                                  (_mediaQuery.size.height - _appBarHieght) *
                                      0.075,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: _theme.highlightColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    'Admin',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w900,
                                      fontSize: _mediaQuery.size.height * 0.03,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(AdminScreen.routeName);
                                },
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height:
                                  (_mediaQuery.size.height - _appBarHieght) *
                                      0.075,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: _theme.highlightColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.wifi_off,
                                        color: Colors.red[300],
                                        size: _mediaQuery.size.height * 0.03,
                                      ),
                                      SizedBox(
                                        width: _mediaQuery.size.width * 0.02,
                                      ),
                                      Text(
                                        'Admin',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w900,
                                          color: Colors.red[300],
                                          fontSize:
                                              _mediaQuery.size.height * 0.03,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                    )
                  : SizedBox(
                      height: (_mediaQuery.size.height - _appBarHieght) * 0.15,
                    ),
              SizedBox(
                height: (_mediaQuery.size.height - _appBarHieght) * 0.05,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  height: (_mediaQuery.size.height - _appBarHieght) * 0.055,
                  width: double.infinity,
                  child: Text(
                    'Questions?',
                    style: TextStyle(
                      color: _theme.highlightColor,
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
                            launch('https://www.instagram.com/teenfittest/')
                                .catchError((_, stack) {
                              _showToast('Unable To Open Link');
                            });
                          },
                          icon: Icon(
                            MyFlutterApp.instagram_1,
                            size: _mediaQuery.size.height * 0.05,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        IconButton(
                          onPressed: () {
                            launch('https://www.facebook.com/teenfittest/')
                                .catchError((_, stack) {
                              _showToast('Unable To Open Link');
                            });
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
                            launch('https://teenfittest.tumblr.com/')
                                .catchError((_, stack) {
                              _showToast('Unable To Open Link');
                            });
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
            ],
          ),
        ),
      ),
    );
  }
}
