import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '/providers/exercise.dart';
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
      await workoutsCollection
          .orderBy('date', descending: false)
          .get()
          .then(
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
                            exerciseImage: e['exerciseImage'],
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
          )
          .onError(
            (error, stackTrace) => throw HttpException(''),
          );
    } on FirebaseException catch (_) {
      throw HttpException('');
    } catch (e) {
      throw HttpException(e.toString());
    }
    notifyListeners();
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

  Exercise findByExerciseId(
    String exerciseId,
    List<Exercise> exercises,
  ) {
    return exercises.firstWhere((element) => element.exerciseId == exerciseId);
  }

  Future<void> addWorkout(Workout workouT) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    exerciseImage(Exercise e) async {
      final exerciseRef = FirebaseStorage.instance
          .ref()
          .child('${workouT.workoutName} ${workouT.workoutId}')
          .child(e.exerciseId + workouT.workoutId + '.jpg');

      await exerciseRef.putFile(e.exerciseImage!);

      return await exerciseRef.getDownloadURL();
    }

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('${workouT.workoutName} ${workouT.workoutId}')
          .child(workouT.workoutId + '.jpg');

      await ref.putFile(workouT.bannerImage!);

      final url = await ref.getDownloadURL();

      await workoutsCollection
          .doc('${workouT.workoutId}')
          .set(
            ({
              'date': workouT.date,
              'bannerImage': url,
              'creatorName': workouT.creatorName,
              'creatorId': workouT.creatorId,
              'workoutId': workouT.workoutId,
              'workoutName': workouT.workoutName,
              'instagram': workouT.instagram,
              'facebook': workouT.facebook,
              'tumblrPageLink': workouT.tumblrPageLink,
              'exercises': workouT.exercises.map((e) {
                return {
                  'exerciseId': e.exerciseId,
                  'name': e.name,
                  'reps': e.reps,
                  'sets': e.sets,
                  'restTime': e.restTime,
                  'timeSeconds': e.timeSeconds,
                  'exerciseImage': exerciseImage(e).toString(),
                };
              }).toList() as List<Exercise>
            }),
          )
          .onError((error, stackTrace) => throw HttpException(''));

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

    final firebaseStorage = FirebaseStorage.instance;

    Future<String> exerciseImage(String exerciseId) async {
      Exercise e = findByExerciseId(exerciseId, workouT.exercises);

      final exerciseRef = firebaseStorage
          .ref()
          .child('${workouT.workoutName} ${workouT.workoutId}')
          .child(e.exerciseId + workouT.workoutId + '.jpg');

      await exerciseRef.putFile(e.exerciseImage!);

      return await exerciseRef.getDownloadURL();
    }

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('${workouT.workoutName} ${workouT.workoutId}');

      await ref.delete().then(
            (_) => ref
                .child(workouT.workoutId + '.jpg')
                .putFile(workouT.bannerImage!),
          );

      final url = await ref.getDownloadURL();

      workoutsCollection
          .doc('${workouT.workoutId}')
          .update(
            ({
              'date': workouT.date,
              'creatorName': workouT.creatorName,
              'creatorId': workouT.creatorId,
              'workoutId': workouT.workoutId,
              'workoutName': workouT.workoutName,
              'instagram': workouT.instagram,
              'facebook': workouT.facebook,
              'tumblrPageLink': workouT.tumblrPageLink,
              'bannerImage': url.toString(),
              'exercises': workouT.exercises
                  .map((e) => {
                        'exerciseId': e.exerciseId,
                        'exerciseImage':
                            (exerciseImage(e.exerciseId)).toString(),
                        'name': e.name,
                        'reps': e.reps,
                        'sets': e.sets,
                        'restTime': e.restTime,
                        'timeSeconds': e.timeSeconds
                      })
                  .toList()
            }),
          )
          .onError((error, stackTrace) => throw HttpException(
              'Unable To Update Exercise, Try Again Later'));

      int index = _workouts
          .indexWhere((workoUT) => workoUT.workoutId == workouT.workoutId);
      _workouts
          .removeWhere((workoUT) => workoUT.workoutId == workouT.workoutId);
      _workouts.insert(index, workouT);
      notifyListeners();
    } on FirebaseException catch (_) {
      throw HttpException('Unable To Update Exercise, Try Again Later');
    } catch (_) {
      throw HttpException('Unable To Update Exercise, Try Again Later');
    }
    notifyListeners();
  }

  Future<void> deleteWorkout(String workoutId) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    try {
      workoutsCollection.doc(workoutId).delete().onError((error, stackTrace) =>
          throw HttpException('Unable To Delete Exercise'));
      _workouts.removeWhere((workout) => workout.workoutId == workoutId);
      notifyListeners();
    } on FirebaseException catch (_) {
      throw HttpException('Unable To Delete Exercise');
    } catch (e) {
      throw HttpException('Unable To Delete Exercise');
    }
    notifyListeners();
  }
}
