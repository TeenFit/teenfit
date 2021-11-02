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

  List<Workout> _workouts = [];

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

      _workouts.insert(0, workouT);
      notifyListeners();
    } on FirebaseException catch (e) {
      throw HttpException(e.toString());
    } catch (e) {
      throw HttpException(e.toString());
    }
    notifyListeners();
  }

  Future<void> updateWorkout(Workout workouT) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    try {
      await workoutsCollection.doc('${workouT.workoutId}').update(
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

      int index = _workouts
          .indexWhere((workoUT) => workoUT.workoutId == workouT.workoutId);
      _workouts
          .removeWhere((workoUT) => workoUT.workoutId == workouT.workoutId);
      _workouts.insert(index, workouT);
      notifyListeners();
    } catch (_) {
      throw HttpException('Unable To Update Exercise, Try Again Later');
    }
    notifyListeners();
  }

  Future<void> deleteWorkout(String workoutId) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    try {
      await workoutsCollection.doc(workoutId).delete();
      _workouts.removeWhere((workout) => workout.workoutId == workoutId);
      notifyListeners();
    } catch (e) {
      throw HttpException('Unable To Delete Exercise');
    }
    notifyListeners();
  }
}
