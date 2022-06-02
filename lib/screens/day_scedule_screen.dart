import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/user.dart';
import 'package:teenfit/screens/discovery_page.dart';

import '../providers/userProv.dart';
import '../providers/workout.dart';
import '../widgets/workout_tile.dart';

class DaySchedule extends StatefulWidget {
  static const routeName = '/day-schedule';

  @override
  State<DaySchedule> createState() => _DayScheduleState();
}

class _DayScheduleState extends State<DaySchedule> {
  String? day;
  User? user;
  bool isInit = false;
  bool isLoading = false;
  var workoutQuery;

  void setWorkoutQuery(List provWorkouts) {
    workoutQuery = FirebaseFirestore.instance
        .collection('/workouts')
        .where('workoutId', whereIn: provWorkouts)
        .orderBy('date', descending: true)
        .withConverter<Workout>(
            fromFirestore: (snapshot, _) => Workout.fromJson(snapshot.data()!),
            toFirestore: (workouT, _) => workouT.toJson());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Map prov = ModalRoute.of(context)!.settings.arguments as Map;
    day = prov['day'];
    user = prov['user'];

    List provWorkouts = user!.plannedDays![day];

    if (isInit == false && provWorkouts.isNotEmpty) {
      setWorkoutQuery(provWorkouts);

      setState(() {
        isInit = true;
      });
    }
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
          onPressed: () async {
            final result = await Navigator.of(context).pushNamed(
                DiscoveryPage.routeName,
                arguments: {'isPlanning': true, 'day': day});

            if (result == 'fam') {
              setState(() {
                isLoading = true;
              });

              final userProv = Provider.of<UserProv>(context, listen: false);
              await userProv.fetchAndSetUser(context);

              user = userProv.getUser;

              setWorkoutQuery(user!.plannedDays![day]);

              setState(() {
                isLoading = false;
              });
            }
          },
          backgroundColor: _theme.secondaryHeaderColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_mediaQuery.size.height * 0.07),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop('fam');
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                backgroundColor: _theme.shadowColor,
                color: _theme.secondaryHeaderColor,
              ),
            )
          : user!.plannedDays![day] == null ||
                  (user!.plannedDays![day] as List).isEmpty
              ? Container(
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
                )
              : Container(
                  color: _theme.primaryColor,
                  height: _mediaQuery.size.height,
                  width: _mediaQuery.size.width,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: FirestoreListView<Workout>(
                      padding:
                          EdgeInsets.only(bottom: _mediaQuery.padding.bottom),
                      query: workoutQuery,
                      pageSize: 5,
                      itemBuilder: (context, snapshot) {
                        final workout = snapshot.data();
                        return snapshot.exists
                            ? Container(
                                height:
                                    (_mediaQuery.size.height - _appBarHieght) *
                                        0.22,
                                child: WorkoutTile(
                                  workout,
                                  false,
                                  false,
                                  false,
                                  false,
                                  true,
                                  day,
                                ),
                              )
                            : Container(
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
                              );
                      },
                    ),
                  ),
                ),
    );
  }
}
