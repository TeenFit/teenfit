import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/auth.dart';
import 'package:uuid/uuid.dart';

import '/providers/workout.dart';
import 'create_workout.dart';
import '/widgets/workout_tile.dart';

class CreateWorkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final _appBarHeight =
        (AppBar().preferredSize.height + _mediaQuery.padding.top);

    var uuid = Uuid();

    String uid = Provider.of<Auth>(context, listen: false).userId!;

    final queryWorkout = FirebaseFirestore.instance
        .collection('/workouts')
        .where('creatorId', isEqualTo: uid)
        .orderBy('date', descending: false)
        .withConverter<Workout>(
            fromFirestore: (snapshot, _) => Workout.fromJson(snapshot.data()!),
            toFirestore: (worKout, _) => worKout.toJson());

    return Scaffold(
      backgroundColor: _theme.primaryColor,
      appBar: AppBar(
        title: Text(
          'My Workouts',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: _appBarHeight * 0.35),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddWorkoutScreen.routeName,
                  arguments: {
                    'workout': Workout(
                      views: 0,
                      searchTerms: [],
                      failed: false,
                      pending: true,
                      date: DateTime.now(),
                      creatorName: '',
                      creatorId: uid,
                      workoutId: uuid.v4(),
                      workoutName: '',
                      instagram: '',
                      facebook: '',
                      tiktokLink: '',
                      bannerImage: null,
                      bannerImageLink: null,
                      exercises: [],
                    ),
                    'isEdit': false
                  },
                );
              },
              icon: Icon(
                Icons.add_box_outlined,
                color: Colors.black,
                size: _appBarHeight * 0.45,
              ),
            ),
          ),
        ],
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
                    true,
                    false,
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
                              'Create Your First Workout...',
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
