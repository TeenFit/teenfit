import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../providers/workout.dart';
import '/widgets/workout_tile.dart';

class AdminScreen extends StatelessWidget {
  static const routeName = '/admin-screen';

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    final queryWorkout = FirebaseFirestore.instance
        .collection('/workouts')
        .where('pending', isEqualTo: true)
        .orderBy('date', descending: false)
        .withConverter<Workout>(
            fromFirestore: (snapshot, _) => Workout.fromJson(snapshot.data()!),
            toFirestore: (worKout, _) => worKout.toJson());

    return Scaffold(
      backgroundColor: _theme.secondaryHeaderColor,
      appBar: AppBar(
        title: Text(
          'Admin Controls',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: _appBarHeight * 0.35,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
            IconThemeData(color: Colors.white, size: _appBarHeight * 0.5),
      ),
      body: Container(
        height: _mediaQuery.size.height,
        width: _mediaQuery.size.width,
        child: FirestoreListView<Workout>(
          query: queryWorkout,
          pageSize: 5,
          itemBuilder: (ctx, snapshot) {
            final workout = snapshot.data();
            return snapshot.exists
                ? WorkoutTile(
                    workout,
                    false,
                    true,
                    false,
                    false,
                    null,
                    null,
                  )
                : Container(
                    height: (_mediaQuery.size.height - _appBarHeight),
                    width: _mediaQuery.size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height:
                              (_mediaQuery.size.height - _appBarHeight) * 0.05,
                        ),
                        Container(
                          height:
                              (_mediaQuery.size.height - _appBarHeight) * 0.05,
                          width: _mediaQuery.size.width * 0.8,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              'No Workouts Pending...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: _mediaQuery.size.height * 0.025,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}


// use same format as my workouts page but create a new field in workout tiles called is Admin, which will allow the
// admin to view different controls, one is accept, and the other is deny with a message,
