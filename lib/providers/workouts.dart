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
          .orderBy('date', descending: true)
          .get()
          .then(
            (workouts) => _workouts = workouts.docs
                .map(
                  (e) => Workout(
                    failed: e['failed'],
                    pending: e['pending'],
                    date: DateTime.parse(e['date']),
                    creatorName: e['creatorName'],
                    creatorId: e['creatorId'],
                    workoutId: e['workoutId'],
                    workoutName: e['workoutName'],
                    instagram: e['instagram'],
                    facebook: e['facebook'],
                    tumblrPageLink: e['tumblrPageLink'],
                    bannerImage: null,
                    bannerImageLink: e['bannerImage'],
                    exercises: (e['exercises'] as List)
                        .toList()
                        .map(
                          (e) => Exercise(
                            exerciseId: e['exerciseId'],
                            name: e['name'],
                            exerciseImageLink: e['exerciseImage'],
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

      List<Exercise> exerciseSClassList = workouT.exercises.map((e) {
        final exerciseIndex = exerciseImages.indexWhere(
            (element) => element['id'] == e.exerciseId + workouT.workoutId);

        return Exercise(
            exerciseId: e.exerciseId,
            name: e.name,
            reps: e.reps,
            sets: e.sets,
            restTime: e.restTime,
            timeSeconds: e.timeSeconds,
            exerciseImageLink:
                exerciseImages[exerciseIndex]['image'].toString(),
            exerciseImage: e.exerciseImage);
      }).toList();

      var workoutDocInfo = {
        'failed': workouT.failed,
        'pending': workouT.pending,
        'date': workouT.date.toString(),
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

      _workouts.insert(
          0,
          Workout(
            failed: false,
            pending: workouT.pending,
            bannerImage: workouT.bannerImage,
            bannerImageLink: url,
            date: workouT.date,
            creatorName: workouT.creatorName,
            creatorId: workouT.creatorId,
            workoutId: workouT.workoutId,
            workoutName: workouT.workoutName,
            instagram: workouT.instagram,
            facebook: workouT.facebook,
            tumblrPageLink: workouT.tumblrPageLink,
            exercises: exerciseSClassList,
          ));
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

    Future<void> addExerciseImageLink(List<Exercise> exerciseS) async {
      int i = 0;

      do {
        print(exerciseS);

        try {
          final exerciseRef = FirebaseStorage.instance
              .ref()
              .child('${workouT.workoutId}')
              .child(exerciseS[i].exerciseId + workouT.workoutId + '.jpg');

          if (exerciseS[i].exerciseImage != null) {
            await exerciseRef.putFile(exerciseS[i].exerciseImage!);
          }

          final exerciseLink = await exerciseRef.getDownloadURL();

          exerciseImages.add({
            'image': exerciseLink,
            'id': exerciseS[i].exerciseId + workouT.workoutId
          });
        } catch (e) {
          throw e;
        }

        i = i + 1;
      } while (i < exerciseS.length);

      //create a while loop that adds items to a list of exercises that need to be deleted

      ListResult firebaseExerciseFiles = await FirebaseStorage.instance
          .ref()
          .child('${workouT.workoutId}')
          .listAll();

      List<String> unavailableExercises = [];

      firebaseExerciseFiles.items.forEach((element) {
        unavailableExercises.add(element.name);
      });

      int index = 0;
      do {
        {
          unavailableExercises
              .remove(exerciseS[index].exerciseId + workouT.workoutId + '.jpg');
        }
        index = index + 1;
      } while (index < exerciseS.length);

      unavailableExercises.forEach((element) async {
        if (element != (workouT.workoutId + '.jpg')) {
          await FirebaseStorage.instance
              .ref()
              .child(workouT.workoutId)
              .child(element)
              .delete();
        }
      });
    }

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('${workouT.workoutId}')
          .child(workouT.workoutId + '.jpg');

      if (workouT.bannerImage != null) {
        await ref.putFile(workouT.bannerImage!);
      }

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

      List<Exercise> exerciseSClassList = workouT.exercises.map((e) {
        final exerciseIndex = exerciseImages.indexWhere(
            (element) => element['id'] == e.exerciseId + workouT.workoutId);

        return Exercise(
            exerciseId: e.exerciseId,
            name: e.name,
            reps: e.reps,
            sets: e.sets,
            restTime: e.restTime,
            timeSeconds: e.timeSeconds,
            exerciseImageLink:
                exerciseImages[exerciseIndex]['image'].toString(),
            exerciseImage: e.exerciseImage);
      }).toList();

      var workoutDocInfo = {
        'failed': workouT.failed,
        'pending': workouT.pending,
        'date': workouT.date.toString(),
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

      int index = _workouts
          .indexWhere((element) => element.workoutId == workouT.workoutId);
      _workouts
          .removeWhere((workoUT) => workoUT.workoutId == workouT.workoutId);
      _workouts.insert(
          index,
          Workout(
            failed: false,
            pending: workouT.pending,
            bannerImage: workouT.bannerImage,
            bannerImageLink: url,
            date: workouT.date,
            creatorName: workouT.creatorName,
            creatorId: workouT.creatorId,
            workoutId: workouT.workoutId,
            workoutName: workouT.workoutName,
            instagram: workouT.instagram,
            facebook: workouT.facebook,
            tumblrPageLink: workouT.tumblrPageLink,
            exercises: exerciseSClassList,
          ));
      notifyListeners();
    } on FirebaseException catch (e) {
      throw HttpException(e.toString());
    } catch (e) {
      throw HttpException(e.toString());
    }
    notifyListeners();
  }

  Future<void> deleteWorkout(Workout workouT) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    final deleteImageRef =
        FirebaseStorage.instance.ref().child('${workouT.workoutId}');

    final exerciseS = workouT.exercises;

    Future<void> deleteImages() async {
      await deleteImageRef.child(workouT.workoutId + '.jpg').delete();

      int index = 0;

      do {
        await FirebaseStorage.instance
            .ref()
            .child('${workouT.workoutId}')
            .child(exerciseS[index].exerciseId + workouT.workoutId + '.jpg')
            .delete();

        index = index + 1;
      } while (index < exerciseS.length);
    }

    try {
      await deleteImages()
          .onError((error, stackTrace) => throw HttpException('lol'));

      await workoutsCollection.doc(workouT.workoutId).delete().onError(
          (error, stackTrace) =>
              throw HttpException('Unable To Delete Exercise'));
      _workouts
          .removeWhere((workout) => workout.workoutId == workouT.workoutId);
      notifyListeners();
    } on FirebaseException catch (_) {
      throw HttpException('Unable To Delete Exercise');
    } catch (e) {
      throw HttpException('Unable To Delete Exercise');
    }
    notifyListeners();
  }

  List<Workout> findByCreatorId(String creatorId) {
    return workouts.where((workout) => workout.creatorId == creatorId).toList();
  }

  List<Workout> isNotPendingWorkouts() {
    return workouts
        .where((element) => element.pending == false && element.failed == false)
        .toList();
  }

  List<Workout> isPendingWorkouts() {
    return workouts
        .where((element) => element.pending == true)
        .toList()
        .reversed
        .toList();
  }

  List<Workout> findByName(String name) {
    return workouts
        .where(
          (workouT) => ((workouT.workoutName.contains(name) ||
                  workouT.workoutName.toLowerCase().contains(name) ||
                  workouT.workoutName.toUpperCase().contains(name) ||
                  workouT.workoutName.characters.contains(name) ||
                  workouT.creatorName.contains(name) ||
                  workouT.creatorName.toLowerCase().contains(name) ||
                  workouT.creatorName.toUpperCase().contains(name) ||
                  workouT.creatorName.characters.contains(name)) &&
              workouT.pending == false &&
              workouT.failed == false),
        )
        .toList();
  }

  Future<void> acceptWorkout(Workout workouT) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    DateTime time = DateTime.now();

    await workoutsCollection
        .doc(workouT.workoutId)
        .update({'pending': false, 'date': time.toString()});

    int index = _workouts
        .indexWhere((element) => element.workoutId == workouT.workoutId);
    _workouts.removeWhere((element) => element.workoutId == workouT.workoutId);
    _workouts.insert(
        index,
        Workout(
            failed: false,
            bannerImage: workouT.bannerImage,
            bannerImageLink: workouT.bannerImageLink,
            date: time,
            creatorName: workouT.creatorName,
            creatorId: workouT.creatorId,
            workoutId: workouT.workoutId,
            workoutName: workouT.workoutName,
            instagram: workouT.instagram,
            facebook: workouT.facebook,
            tumblrPageLink: workouT.tumblrPageLink,
            pending: false,
            exercises: workouT.exercises));
    notifyListeners();
  }

  Future<void> failWorkout(Workout workouT) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    DateTime time = DateTime.now();

    await workoutsCollection
        .doc(workouT.workoutId)
        .update({'failed': true, 'pending': false, 'date': time.toString()});

    int index = _workouts
        .indexWhere((element) => element.workoutId == workouT.workoutId);
    _workouts.removeWhere((element) => element.workoutId == workouT.workoutId);
    _workouts.insert(
        index,
        Workout(
            failed: true,
            bannerImage: workouT.bannerImage,
            bannerImageLink: workouT.bannerImageLink,
            date: time,
            creatorName: workouT.creatorName,
            creatorId: workouT.creatorId,
            workoutId: workouT.workoutId,
            workoutName: workouT.workoutName,
            instagram: workouT.instagram,
            facebook: workouT.facebook,
            tumblrPageLink: workouT.tumblrPageLink,
            pending: false,
            exercises: workouT.exercises));
    notifyListeners();
  }
}
