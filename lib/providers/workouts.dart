import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:teenfit/providers/exercise.dart';

import '/Custom/http_execption.dart';
import './workout.dart';

class Workouts with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Workout> get workouts {
    return [..._workouts];
  }

  List<Workout> _workouts = [
    // Workout(
    //   creatorName: 'Muqeeth Khan',
    //   workoutId: 'w1',
    //   creatorId: 'FiGK0HauiQd1xv3FV3FXMF1uAw83',
    //   workoutName: 'Body Weight Workout',
    //   instagram: 'https://www.instagram.com/teenfittest/',
    //   facebook: '',
    //   tumblrPageLink: '',
    //   bannerImage: '',
    //   exercises: [
    //     Exercise(
    //       exerciseId: 'e1',
    //       name: 'Pushups',
    //       reps: 10,
    //       sets: 3,
    //       restTime: 15,
    //       exerciseImageLink:
    //           'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
    //     ),
    //     Exercise(
    //       exerciseId: 'e2',
    //       name: 'Wide Pushups',
    //       reps: 10,
    //       sets: 3,
    //       restTime: 15,
    //       exerciseImageLink:
    //           'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
    //     ),
    //     Exercise(
    //       exerciseId: 'e3',
    //       name: 'Diamond Pushups',
    //       reps: 10,
    //       sets: 3,
    //       restTime: 15,
    //       exerciseImageLink:
    //           'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
    //     ),
    //     Exercise(
    //       exerciseId: 'e4',
    //       name: 'Wide Pushups',
    //       reps: 10,
    //       sets: 3,
    //       restTime: 15,
    //       exerciseImageLink:
    //           'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
    //     ),
    //     Exercise(
    //       exerciseId: 'e5',
    //       name: 'Wide Pushups',
    //       reps: 10,
    //       sets: 3,
    //       restTime: 15,
    //       exerciseImageLink:
    //           'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
    //     ),
    //   ],
    // ),
    // Workout(
    //   date: '',
    //   creatorName: 'Muqeeth Khan',
    //   workoutId: 'w2',
    //   creatorId: 'D9AShHoi0RT19iDnxoN94K2BC1s1',
    //   workoutName: 'Dumbell Workout',
    //   instagram: '',
    //   facebook: '',
    //   tumblrPageLink: '',
    //   bannerImage: '',
    //   exercises: [
    //     Exercise(
    //       exerciseId: 'e1',
    //       name: 'Wide Pushups',
    //       timeSeconds: 30,
    //       restTime: 15,
    //       exerciseImageLink:
    //           'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
    //     ),
    //     Exercise(
    //       exerciseId: 'e2',
    //       name: 'Wide Pushups',
    //       timeSeconds: 30,
    //       restTime: 15,
    //       exerciseImageLink:
    //           'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
    //     ),
    //     Exercise(
    //       exerciseId: 'e3',
    //       name: 'Wide Pushups',
    //       timeSeconds: 30,
    //       restTime: 15,
    //       exerciseImageLink:
    //           'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
    //     ),
    //     Exercise(
    //       exerciseId: 'e4',
    //       name: 'Wide Pushups',
    //       timeSeconds: 30,
    //       restTime: 15,
    //       exerciseImageLink:
    //           'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
    //     ),
    //     Exercise(
    //       exerciseId: 'e5',
    //       name: 'Wide Pushups',
    //       timeSeconds: 30,
    //       restTime: 15,
    //       exerciseImageLink:
    //           'https://drive.google.com/uc?export=view&id=1Lp2RRSHfDY6kTp__t6n6SBsuCGn6zR3l',
    //     ),
    //   ],
    // ),
  ];

  Future<void> fetchAndSetWorkout() async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    try {
      await workoutsCollection.orderBy('date').get().then(
            (workouts) => _workouts = workouts.docs
                .map(
                  (e) => Workout(
                    date: e['date'],
                    creatorName: e['creatorName'],
                    creatorId: e['creatorId'],
                    workoutId: e['workoutId'],
                    workoutName: e['workoutName'],
                    instagram: e['instagram'],
                    facebook: e['facebook'],
                    tumblrPageLink: e['tumblrPageLink'],
                    bannerImage: e['bannerImage'],
                    exercises: (e['exercises'] as List)
                        .toList()
                        .map(
                          (e) => Exercise(
                            exerciseId: e['exerciseId'],
                            name: e['name'],
                            exerciseImageLink: e['exerciseImageLink'],
                            reps: e['reps'],
                            sets: e['sets'],
                            restTime: e['restTime'],
                            timeSeconds: e['timeSeconds'],
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          );
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  List<Workout> findByName(String name) {
    return workouts
        .where(
          (workout) =>
              workout.workoutName.contains(name) ||
              workout.workoutName.toLowerCase().contains(name) ||
              workout.workoutName.toUpperCase().contains(name) ||
              workout.workoutName.characters.contains(name),
        )
        .toList();
  }

  List<Workout> findByCreatorId(String creatorId) {
    return workouts.where((workout) => workout.creatorId == creatorId).toList();
  }

  Future<void> addWorkout(Workout workouT) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    try {
      await workoutsCollection.doc('${workouT.workoutId}').set(
            ({
              'date': workouT.date,
              'creatorName': workouT.bannerImage,
              'creatorId': workouT.creatorId,
              'workoutId': workouT.workoutId,
              'workoutName': workouT.workoutName,
              'instagram': workouT.instagram,
              'facebook': workouT.facebook,
              'tumblrPageLink': workouT.tumblrPageLink,
              'bannerImage': workouT.bannerImage,
              'exercises': workouT.exercises
                  .map((e) => {
                        'exerciseId': e.exerciseId,
                        'exerciseImageLink': e.exerciseImageLink,
                        'name': e.name,
                        'reps': e.reps,
                        'sets': e.sets,
                        'restTime': e.restTime,
                        'timeSeconds': e.timeSeconds
                      })
                  .toList()
            }),
          );

      workouts.add(workouT);
    } on FirebaseException catch (e) {
      throw HttpException(e.toString());
    } catch (e) {
      throw HttpException(e.toString());
    }
    notifyListeners();
  }

  Future<void> updateWorkout(Workout workouT) async {
    try {
      int index = _workouts
          .indexWhere((workoUT) => workoUT.workoutId == workouT.workoutId);
      _workouts
          .removeWhere((workoUT) => workoUT.workoutId == workouT.workoutId);
      _workouts.insert(index, workouT);
    } catch (_) {
      throw HttpException('');
    }
    notifyListeners();
  }

  Future<void> deleteWorkout(String workoutId) async {
    _workouts.removeWhere((workout) => workout.workoutId == workoutId);
    notifyListeners();
  }
}
