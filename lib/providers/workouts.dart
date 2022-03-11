import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
                    tiktokLink: e['tiktokLink'],
                    bannerImage: null,
                    bannerImageLink: e['bannerImage'],
                    exercises: (e['exercises'] as List)
                        .toList()
                        .map(
                          (e) => Exercise(
                            exerciseId: e['exerciseId'],
                            name: e['name'],
                            exerciseImageLink: e['exerciseImage'],
                            exerciseImageLink2: e['exerciseImage2'],
                            reps2: e['reps2'],
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
        final exerciseRef = FirebaseStorage.instance
            .ref()
            .child('${workouT.workoutId}')
            .child(exerciseS[i].exerciseId + workouT.workoutId);

        await exerciseRef.putFile(exerciseS[i].exerciseImage!);

        final exerciseRef2 = FirebaseStorage.instance
            .ref()
            .child('${workouT.workoutId}')
            .child(exerciseS[i].exerciseId + workouT.workoutId + '2');

        if (exerciseS[i].exerciseImage2 != null) {
          await exerciseRef2.putFile(exerciseS[i].exerciseImage2!);
        }

        var exerciseLink = await exerciseRef.getDownloadURL();
        var exerciseLink2 = exerciseS[i].exerciseImage2 != null
            ? await exerciseRef2.getDownloadURL()
            : null;

        exerciseImages.add({
          'image2': exerciseLink2,
          'image': exerciseLink,
          'id': exerciseS[i].exerciseId + workouT.workoutId,
        });

        i = i + 1;
      } while (i < exerciseS.length);
    }

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('${workouT.workoutId}')
          .child(workouT.workoutId);

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
          'reps2': e.reps2,
          'sets': e.sets,
          'restTime': e.restTime,
          'timeSeconds': e.timeSeconds,
          'exerciseImage': exerciseImages[exerciseIndex]['image'].toString(),
          'exerciseImage2': exerciseImages[exerciseIndex]['image2'] != null
              ? exerciseImages[exerciseIndex]['image2'].toString()
              : null,
        };
      }).toList();

      List<Exercise> exerciseSClassList = workouT.exercises.map((e) {
        final exerciseIndex = exerciseImages.indexWhere(
            (element) => element['id'] == e.exerciseId + workouT.workoutId);

        return Exercise(
          exerciseId: e.exerciseId,
          name: e.name,
          reps: e.reps,
          reps2: e.reps2,
          sets: e.sets,
          restTime: e.restTime,
          timeSeconds: e.timeSeconds,
          exerciseImageLink: exerciseImages[exerciseIndex]['image'].toString(),
          exerciseImageLink2: exerciseImages[exerciseIndex]['image2'] != null
              ? exerciseImages[exerciseIndex]['image2'].toString()
              : null,
          exerciseImage: null,
          exerciseImage2: null,
        );
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
        'tiktokLink': workouT.tiktokLink,
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
            tiktokLink: workouT.tiktokLink,
            exercises: exerciseSClassList,
          ));
      notifyListeners();
    } on FirebaseException catch (e) {
      throw HttpException(e.toString());
    } catch (e) {
      await deleteWorkout(workouT);
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
              .child(exerciseS[i].exerciseId + workouT.workoutId);

          if (exerciseS[i].exerciseImage != null) {
            await exerciseRef.putFile(exerciseS[i].exerciseImage!);
          }

          final exerciseRef2 = FirebaseStorage.instance
              .ref()
              .child('${workouT.workoutId}')
              .child(exerciseS[i].exerciseId + workouT.workoutId + '2');

          if (exerciseS[i].exerciseImage2 != null) {
            await exerciseRef.putFile(exerciseS[i].exerciseImage2!);
          }

          final exerciseLink = await exerciseRef.getDownloadURL();
          final exerciseLink2 = exerciseS[i].exerciseImage2 != null
              ? await exerciseRef2.getDownloadURL()
              : null;

          exerciseImages.add({
            'image2': exerciseLink2,
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
              .remove(exerciseS[index].exerciseId + workouT.workoutId);
          unavailableExercises
              .remove(exerciseS[index].exerciseId + workouT.workoutId + '2');
        }
        index = index + 1;
      } while (index < exerciseS.length);

      unavailableExercises.forEach((element) async {
        if (element != (workouT.workoutId)) {
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
          .child(workouT.workoutId);

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
          'reps2': e.reps2,
          'sets': e.sets,
          'restTime': e.restTime,
          'timeSeconds': e.timeSeconds,
          'exerciseImage': exerciseImages[exerciseIndex]['image'].toString(),
          'exerciseImage2': exerciseImages[exerciseIndex]['image2'] != null
              ? exerciseImages[exerciseIndex]['image2'].toString()
              : null,
        };
      }).toList();

      List<Exercise> exerciseSClassList = workouT.exercises.map((e) {
        final exerciseIndex = exerciseImages.indexWhere(
            (element) => element['id'] == e.exerciseId + workouT.workoutId);

        return Exercise(
            exerciseId: e.exerciseId,
            name: e.name,
            reps: e.reps,
            reps2: e.reps2,
            sets: e.sets,
            restTime: e.restTime,
            timeSeconds: e.timeSeconds,
            exerciseImageLink:
                exerciseImages[exerciseIndex]['image'].toString(),
            exerciseImageLink2: exerciseImages[exerciseIndex]['image2'] != null
                ? exerciseImages[exerciseIndex]['image2'].toString()
                : null,
            exerciseImage: null,
            exerciseImage2: null);
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
        'tiktokLink': workouT.tiktokLink,
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
            tiktokLink: workouT.tiktokLink,
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
      await deleteImageRef.child(workouT.workoutId).delete();

      int index = 0;

      do {
        await FirebaseStorage.instance
            .ref()
            .child('${workouT.workoutId}')
            .child(exerciseS[index].exerciseId + workouT.workoutId)
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
      throw HttpException('Unable To Save Exercise');
    } catch (e) {
      throw HttpException('Unable To Save Exercise');
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
            tiktokLink: workouT.tiktokLink,
            pending: false,
            exercises: workouT.exercises));
    notifyListeners();
  }

  Future<void> removeFailedWorkouts() async {
    final failedWorkouts = workouts.where((element) {
      final date = element.date;
      final timeNow = DateTime.now();

      int difference = timeNow.difference(date).inDays;

      final daysLeft = 15 - difference;

      return element.failed && daysLeft <= 0;
    }).toList();

    int i = 0;

    do {
      await deleteWorkout(failedWorkouts[i]);
      i++;
    } while (i < failedWorkouts.length);
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
            tiktokLink: workouT.tiktokLink,
            pending: false,
            exercises: workouT.exercises));
    notifyListeners();
  }
}
