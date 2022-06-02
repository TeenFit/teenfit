import 'package:flutter/material.dart';
import 'package:teenfit/screens/day_scedule_screen.dart';

class LoggingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _theme.primaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_mediaQuery.size.height * 0.07),
        child: AppBar(
          elevation: 5,
          backgroundColor: _theme.secondaryHeaderColor,
          foregroundColor: Colors.white,
          title: Text(
            'Log Workouts',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: _appBarHieght * 0.3),
          ),
        ),
      ),
      body: Container(
        color: _theme.primaryColor,
        height: _mediaQuery.size.height - _appBarHieght,
        width: _mediaQuery.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(
              thickness: 3,
              color: Colors.black,
            ),
            ListTile(
              title: Text(
                'MONDAY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w900,
                  fontSize: _mediaQuery.size.height * 0.04,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(DaySchedule.routeName, arguments: 'Monday');
              },
            ),
            Divider(
              thickness: 3,
              color: Colors.black,
            ),
            ListTile(
              title: Text(
                'TUESDAY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w900,
                  fontSize: _mediaQuery.size.height * 0.04,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(DaySchedule.routeName, arguments: 'Tuesday');
              },
            ),
            Divider(
              thickness: 3,
              color: Colors.black,
            ),
            ListTile(
              title: Text(
                'WEDNESDAY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w900,
                  fontSize: _mediaQuery.size.height * 0.04,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(DaySchedule.routeName, arguments: 'Wednesday');
              },
            ),
            Divider(
              thickness: 3,
              color: Colors.black,
            ),
            ListTile(
              title: Text(
                'THURSDAY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w900,
                  fontSize: _mediaQuery.size.height * 0.04,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(DaySchedule.routeName, arguments: 'Thursday');
              },
            ),
            Divider(
              thickness: 3,
              color: Colors.black,
            ),
            ListTile(
              title: Text(
                'FRIDAY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w900,
                  fontSize: _mediaQuery.size.height * 0.04,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(DaySchedule.routeName, arguments: 'Friday');
              },
            ),
            Divider(
              thickness: 3,
              color: Colors.black,
            ),
            ListTile(
              title: Text(
                'SATURDAY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w900,
                  fontSize: _mediaQuery.size.height * 0.04,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(DaySchedule.routeName, arguments: 'Satuday');
              },
            ),
            Divider(
              thickness: 3,
              color: Colors.black,
            ),
            ListTile(
              title: Text(
                'SUNDAY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w900,
                  fontSize: _mediaQuery.size.height * 0.04,
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(DaySchedule.routeName, arguments: 'Sunday');
              },
            ),
            Divider(
              thickness: 3,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
