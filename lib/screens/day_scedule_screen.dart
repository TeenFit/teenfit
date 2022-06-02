import 'package:flutter/material.dart';
import 'package:teenfit/providers/user.dart';
import 'package:teenfit/screens/discovery_page.dart';

class DaySchedule extends StatefulWidget {
  static const routeName = '/day-schedule';

  @override
  State<DaySchedule> createState() => _DayScheduleState();
}

class _DayScheduleState extends State<DaySchedule> {
  String? day;
  User? user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Map prov = ModalRoute.of(context)!.settings.arguments as Map;
    day = prov['day'];
    user = prov['user'];
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHieght =
        AppBar().preferredSize.height + _mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: _theme.primaryColor,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(DiscoveryPage.routeName,
                arguments: {'isPlanning': true, 'day': day});
          },
          backgroundColor: _theme.secondaryHeaderColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_mediaQuery.size.height * 0.07),
        child: AppBar(
          elevation: 5,
          backgroundColor: _theme.secondaryHeaderColor,
          foregroundColor: Colors.white,
          title: Text(
            "$day's Workout",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: _appBarHieght * 0.3),
          ),
        ),
      ),
      body: Container(
        height: _mediaQuery.size.height,
        width: _mediaQuery.size.width,
        child: Center(
          child: Text(
            'Rest Day',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: _appBarHieght * 1.5),
          ),
        ),
      ),
    );
  }
}
