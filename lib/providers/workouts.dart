import 'dart:async';

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

  Future<void> addWorkout(Workout workouT) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    List<Map> exerciseImages = [];

    Future<void> addExerciseImageLink(List<Exercise> exerciseS) async {
      int i = 0;

      do {
        print(exerciseS);

        final exerciseRef = FirebaseStorage.instance
            .ref()
            .child('${workouT.workoutId}')
            .child(exerciseS[i].exerciseId + workouT.workoutId + '.jpg');

        await exerciseRef.putFile(exerciseS[i].exerciseImage!);

        final exerciseLink = await exerciseRef.getDownloadURL();

        exerciseImages.add({
          'image': exerciseLink,
          'id': exerciseS[i].exerciseId + workouT.workoutId
        });

        i = i + 1;
      } while (i < exerciseS.length);
    }

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('${workouT.workoutId}')
          .child(workouT.workoutId + '.jpg');

      await ref.putFile(workouT.bannerImage!);

      final url = await ref.getDownloadURL();

      await addExerciseImageLink(workouT.exercises);

      var exerciseS = workouT.exercises.map((e) {
        final exerciseIndex = exerciseImages.indexWhere(
            (element) => element['id'] == e.exerciseId + workouT.workoutId);

        return {
          'exerciseId': e.exerciseId,
          'name': e.name,
          'reps': e.reps,
          'sets': e.sets,
          'restTime': e.restTime,
          'timeSeconds': e.timeSeconds,
          'exerciseImage': exerciseImages[exerciseIndex]['image'].toString(),
        };
      }).toList();

      var workoutDocInfo = {
        'date': workouT.date,
        'bannerImage': url,
        'creatorName': workouT.creatorName,
        'creatorId': workouT.creatorId,
        'workoutId': workouT.workoutId,
        'workoutName': workouT.workoutName,
        'instagram': workouT.instagram,
        'facebook': workouT.facebook,
        'tumblrPageLink': workouT.tumblrPageLink,
        'exercises': exerciseS,
      };

      await workoutsCollection
          .doc('${workouT.workoutId}')
          .set(
            (workoutDocInfo),
          )
          .onError(
              (error, stackTrace) => throw HttpException(error.toString()));

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

    List<Map> exerciseImages = [];

    final deleteExerciseRef =
        FirebaseStorage.instance.ref().child('${workouT.workoutId}');

    Future<void> addExerciseImageLink(List<Exercise> exerciseS) async {
      int i = 0;

      do {
        print(exerciseS);

        final exerciseRef = FirebaseStorage.instance
            .ref()
            .child('${workouT.workoutId}')
            .child(exerciseS[i].exerciseId + workouT.workoutId + '.jpg');

        await exerciseRef.putFile(exerciseS[i].exerciseImage!);

        final exerciseLink = await exerciseRef.getDownloadURL();

        exerciseImages.add({
          'image': exerciseLink,
          'id': exerciseS[i].exerciseId + workouT.workoutId
        });

        i = i + 1;
      } while (i < exerciseS.length);
    }

    try {
      await deleteExerciseRef.delete();

      final ref = FirebaseStorage.instance
          .ref()
          .child('${workouT.workoutId}')
          .child(workouT.workoutId + '.jpg');

      await ref.putFile(workouT.bannerImage!);

      final url = await ref.getDownloadURL();

      await addExerciseImageLink(workouT.exercises);

      var exerciseS = workouT.exercises.map((e) {
        final exerciseIndex = exerciseImages.indexWhere(
            (element) => element['id'] == e.exerciseId + workouT.workoutId);

        return {
          'exerciseId': e.exerciseId,
          'name': e.name,
          'reps': e.reps,
          'sets': e.sets,
          'restTime': e.restTime,
          'timeSeconds': e.timeSeconds,
          'exerciseImage': exerciseImages[exerciseIndex]['image'].toString(),
        };
      }).toList();

      var workoutDocInfo = {
        'date': workouT.date,
        'bannerImage': url,
        'creatorName': workouT.creatorName,
        'creatorId': workouT.creatorId,
        'workoutId': workouT.workoutId,
        'workoutName': workouT.workoutName,
        'instagram': workouT.instagram,
        'facebook': workouT.facebook,
        'tumblrPageLink': workouT.tumblrPageLink,
        'exercises': exerciseS,
      };

      await workoutsCollection
          .doc('${workouT.workoutId}')
          .update(
            (workoutDocInfo),
          )
          .onError(
              (error, stackTrace) => throw HttpException(error.toString()));

      _workouts.insert(0, workouT);
      notifyListeners();
    } on FirebaseException catch (e) {
      throw HttpException(e.toString());
    } catch (e) {
      throw HttpException(e.toString());
    }
    notifyListeners();
  }

  Future<void> deleteWorkout(String workoutId) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    final deleteImageRef = FirebaseStorage.instance.ref().child('${workoutId}');

    try {
      await deleteImageRef.delete();
      await workoutsCollection.doc(workoutId).delete().onError((error, stackTrace) =>
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
