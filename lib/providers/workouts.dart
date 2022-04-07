import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import '/providers/exercise.dart';
import '/Custom/http_execption.dart';
import './workout.dart';
import 'auth.dart';

class Workouts with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addWorkout(Workout workouT) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    List<String> searchTermsList = [];

    Future<void> addSearchTerms(String creatorName, String workoutName) async {
      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(0, i));
      }

      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(0, i).toLowerCase());
      }

      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(0, i).toUpperCase());
      }

      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 2 < 0 ? 0 : i - 2, i));
      }

      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 3 < 0 ? 0 : i - 3, i));
      }

      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 4 < 0 ? 0 : i - 4, i));
      }

      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 5 < 0 ? 0 : i - 5, i));
      }
      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 6 < 0 ? 0 : i - 6, i));
      }
      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 7 < 0 ? 0 : i - 7, i));
      }
      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 8 < 0 ? 0 : i - 8, i));
      }
      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 9 < 0 ? 0 : i - 9, i));
      }
      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 10 < 0 ? 0 : i - 10, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(0, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(0, i).toLowerCase());
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(0, i).toUpperCase());
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 2 < 0 ? 0 : i - 2, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 3 < 0 ? 0 : i - 3, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 4 < 0 ? 0 : i - 4, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 5 < 0 ? 0 : i - 5, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 6 < 0 ? 0 : i - 6, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 7 < 0 ? 0 : i - 7, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 8 < 0 ? 0 : i - 8, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 9 < 0 ? 0 : i - 9, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 10 < 0 ? 0 : i - 10, i));
      }

      searchTermsList = searchTermsList.toSet().toList();
    }

    List<Map> exerciseImages = [];

    Future<void> addExerciseImageLink(List<Exercise> exerciseS) async {
      int i = 0;

      final String id_and_key =
          '004b2d9d74e33f20000000001:K004ORWU4mzfbmnF4/HyH7qtgg7mWfo';
      final Codec<String, String> stringToBase64 = utf8.fuse(base64);
      final String basic_auth_string =
          'Basic' + stringToBase64.encode(id_and_key);
      final headers = {'Authorization': basic_auth_string};

      var response = await http.get(
          Uri.parse(
              'https://api.backblazeb2.com/b2api/v2/b2_authorize_account'),
          headers: headers);

      var data = json.decode(response.body) as Map<String, dynamic>;

      print(data['allowed']['bucketName']);

      do {
        // final exerciseRef = FirebaseStorage.instance
        //     .ref()
        //     .child('${workouT.workoutId}')
        //     .child(exerciseS[i].exerciseId + workouT.workoutId);

        // await exerciseRef.putFile(exerciseS[i].exerciseImage!);

        // final exerciseRef2 = FirebaseStorage.instance
        //     .ref()
        //     .child('${workouT.workoutId}')
        //     .child(exerciseS[i].exerciseId + workouT.workoutId + 'second');

        // if (exerciseS[i].exerciseImage2 != null) {
        //   await exerciseRef2.putFile(exerciseS[i].exerciseImage2!);
        // }

        // var exerciseLink = await exerciseRef.getDownloadURL();
        // var exerciseLink2 = exerciseS[i].exerciseImage2 != null
        //     ? await exerciseRef2.getDownloadURL()
        //     : null;

        // exerciseImages.add({
        //   'image2': exerciseLink2 != null ? exerciseLink2.toString() : null,
        //   'image': exerciseLink,
        //   'id': exerciseS[i].exerciseId + workouT.workoutId,
        // });

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
          'name2': e.name2,
          'name': e.name,
          'reps': e.reps,
          'reps2': e.reps2,
          'sets': e.sets,
          'restTime': e.restTime,
          'timeSeconds': e.timeSeconds,
          'exerciseImage': exerciseImages[exerciseIndex]['image'].toString(),
          'exerciseImage2': exerciseImages[exerciseIndex]['image2'],
        };
      }).toList();

      addSearchTerms(workouT.creatorName, workouT.workoutName);

      var workoutDocInfo = {
        'views': workouT.views,
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

    List<String> searchTermsList = [];

    Future<void> addSearchTerms(String creatorName, String workoutName) async {
      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(0, i));
      }

      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(0, i).toLowerCase());
      }

      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(0, i).toUpperCase());
      }

      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 2 < 0 ? 0 : i - 2, i));
      }

      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 3 < 0 ? 0 : i - 3, i));
      }

      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 4 < 0 ? 0 : i - 4, i));
      }

      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 5 < 0 ? 0 : i - 5, i));
      }
      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 6 < 0 ? 0 : i - 6, i));
      }
      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 7 < 0 ? 0 : i - 7, i));
      }
      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 8 < 0 ? 0 : i - 8, i));
      }
      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 9 < 0 ? 0 : i - 9, i));
      }
      for (var i = 0; i <= creatorName.characters.length; i++) {
        searchTermsList.add(creatorName.substring(i - 10 < 0 ? 0 : i - 10, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(0, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(0, i).toLowerCase());
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(0, i).toUpperCase());
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 2 < 0 ? 0 : i - 2, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 3 < 0 ? 0 : i - 3, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 4 < 0 ? 0 : i - 4, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 5 < 0 ? 0 : i - 5, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 6 < 0 ? 0 : i - 6, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 7 < 0 ? 0 : i - 7, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 8 < 0 ? 0 : i - 8, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 9 < 0 ? 0 : i - 9, i));
      }

      for (var i = 0; i <= workoutName.characters.length; i++) {
        searchTermsList.add(workoutName.substring(i - 10 < 0 ? 0 : i - 10, i));
      }

      searchTermsList = searchTermsList.toSet().toList();
    }

    List<Map> exerciseImages = [];

    Future<void> addExerciseImageLink(List<Exercise> exerciseS) async {
      int i = 0;

      var storageinstance = FirebaseStorage.instance;

      do {
        try {
          final exerciseRef = storageinstance
              .ref()
              .child('${workouT.workoutId}')
              .child(exerciseS[i].exerciseId + workouT.workoutId);

          if (exerciseS[i].exerciseImage != null) {
            await exerciseRef.putFile(exerciseS[i].exerciseImage!);
          }

          final exerciseRef2 = storageinstance
              .ref()
              .child('${workouT.workoutId}')
              .child(exerciseS[i].exerciseId + workouT.workoutId + 'second');

          if (exerciseS[i].exerciseImage2 != null) {
            await exerciseRef2.putFile(exerciseS[i].exerciseImage2!);
          }

          final exerciseLink = await exerciseRef.getDownloadURL();
          final exerciseLink2 = exerciseS[i].exerciseImage2 != null &&
                  exerciseS[i].exerciseImageLink != null
              ? await exerciseRef2.getDownloadURL()
              : null;

          exerciseImages.add({
            'image2': exerciseLink2 != null ? exerciseLink2.toString() : null,
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
          unavailableExercises.remove(
              exerciseS[index].exerciseId + workouT.workoutId + 'second');
        }
        index = index + 1;
      } while (index < exerciseS.length);

      unavailableExercises.remove(workouT.workoutId);

      unavailableExercises.forEach((element) async {
        await FirebaseStorage.instance
            .ref()
            .child(workouT.workoutId)
            .child(element)
            .delete();
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
          'name2': e.name2,
          'reps': e.reps,
          'reps2': e.reps2,
          'sets': e.sets,
          'restTime': e.restTime,
          'timeSeconds': e.timeSeconds,
          'exerciseImage': exerciseImages[exerciseIndex]['image'].toString(),
          'exerciseImage2': exerciseImages[exerciseIndex]['image2'] == null
              ? e.exerciseImageLink2
              : exerciseImages[exerciseIndex]['image2'],
        };
      }).toList();

      // List<Exercise> exerciseSClassList = workouT.exercises.map((e) {
      //   final exerciseIndex = exerciseImages.indexWhere(
      //       (element) => element['id'] == e.exerciseId + workouT.workoutId);

      //   return Exercise(
      //       exerciseId: e.exerciseId,
      //       name: e.name,
      //       reps: e.reps,
      //       reps2: e.reps2,
      //       sets: e.sets,
      //       restTime: e.restTime,
      //       timeSeconds: e.timeSeconds,
      //       exerciseImageLink:
      //           exerciseImages[exerciseIndex]['image'].toString(),
      //       exerciseImageLink2: exerciseImages[exerciseIndex]['image2'],
      //       exerciseImage: null,
      //       exerciseImage2: null);
      // }).toList();

      await addSearchTerms(workouT.creatorName, workouT.workoutName);

      var workoutDocInfo = {
        'views': workouT.views,
        'searchTerms': searchTermsList,
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

      // int index = _workouts
      //     .indexWhere((element) => element.workoutId == workouT.workoutId);
      // _workouts
      //     .removeWhere((workoUT) => workoUT.workoutId == workouT.workoutId);
      // _workouts.insert(
      //     index,
      //     Workout(
      //       failed: false,
      //       pending: workouT.pending,
      //       bannerImage: workouT.bannerImage,
      //       bannerImageLink: url,
      //       date: workouT.date,
      //       creatorName: workouT.creatorName,
      //       creatorId: workouT.creatorId,
      //       workoutId: workouT.workoutId,
      //       workoutName: workouT.workoutName,
      //       instagram: workouT.instagram,
      //       facebook: workouT.facebook,
      //       tiktokLink: workouT.tiktokLink,
      //       exercises: exerciseSClassList,
      //     ));
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

        if (exerciseS[index].reps2 != null) {
          await FirebaseStorage.instance
              .ref()
              .child('${workouT.workoutId}')
              .child(exerciseS[index].exerciseId + workouT.workoutId + 'second')
              .delete();
        }

        index = index + 1;
      } while (index < exerciseS.length);
    }

    try {
      await deleteImages()
          .onError((error, stackTrace) => throw HttpException('lol'));

      await workoutsCollection.doc(workouT.workoutId).delete().onError(
          (error, stackTrace) =>
              throw HttpException('Unable To Delete Exercise'));
      // _workouts
      //     .removeWhere((workout) => workout.workoutId == workouT.workoutId);
      notifyListeners();
    } on FirebaseException catch (_) {
      throw HttpException('Unable To Save Exercise');
    } catch (e) {
      throw HttpException('Unable To Save Exercise');
    }
    notifyListeners();
  }

  // List<Workout> findByCreatorId(String creatorId) {
  //   return workouts.where((workout) => workout.creatorId == creatorId).toList();
  // }

  // List<Workout> isNotPendingWorkouts() {
  //   return workouts
  //       .where((element) => element.pending == false && element.failed == false)
  //       .toList();
  // }

  // List<Workout> isPendingWorkouts() {
  //   return workouts
  //       .where((element) => element.pending == true)
  //       .toList()
  //       .reversed
  //       .toList();
  // }

  // List<Workout> findByName(String name) {
  //   return workouts
  //       .where(
  //         (workouT) => ((workouT.workoutName.contains(name) ||
  //                 workouT.workoutName.toLowerCase().contains(name) ||
  //                 workouT.workoutName.toUpperCase().contains(name) ||
  //                 workouT.workoutName.characters.contains(name) ||
  //                 workouT.creatorName.contains(name) ||
  //                 workouT.creatorName.toLowerCase().contains(name) ||
  //                 workouT.creatorName.toUpperCase().contains(name) ||
  //                 workouT.creatorName.characters.contains(name)) &&
  //             workouT.pending == false &&
  //             workouT.failed == false),
  //       )
  //       .toList();
  // }

  Future<void> acceptWorkout(Workout workouT) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    DateTime time = DateTime.now();

    await workoutsCollection
        .doc(workouT.workoutId)
        .update({'pending': false, 'date': time.toString()});

    // int index = _workouts
    //     .indexWhere((element) => element.workoutId == workouT.workoutId);
    // _workouts.removeWhere((element) => element.workoutId == workouT.workoutId);
    // _workouts.insert(
    //     index,
    //     Workout(
    //         failed: false,
    //         bannerImage: workouT.bannerImage,
    //         bannerImageLink: workouT.bannerImageLink,
    //         date: time,
    //         creatorName: workouT.creatorName,
    //         creatorId: workouT.creatorId,
    //         workoutId: workouT.workoutId,
    //         workoutName: workouT.workoutName,
    //         instagram: workouT.instagram,
    //         facebook: workouT.facebook,
    //         tiktokLink: workouT.tiktokLink,
    //         pending: false,
    //         exercises: workouT.exercises));
    notifyListeners();
  }

  // Future<void> removeFailedWorkouts() async {
  //   final failedWorkouts = workouts.where((element) {
  //     final date = element.date;
  //     final timeNow = DateTime.now();

  //     int difference = timeNow.difference(date).inDays;

  //     final daysLeft = 15 - difference;

  //     return element.failed && daysLeft <= 0;
  //   }).toList();

  //   int i = 0;

  //   do {
  //     await deleteWorkout(failedWorkouts[i]);
  //     i++;
  //   } while (i < failedWorkouts.length);
  //   notifyListeners();
  // }

  Future<void> incrementView(
      String creatorId, String workoutId, BuildContext context) async {
    String? userId = Provider.of<Auth>(context, listen: false).userId;

    if (creatorId != userId) {
      await FirebaseFirestore.instance
          .collection('/workouts')
          .doc(workoutId)
          .update({'views': FieldValue.increment(1)});
    }
  }

  Future<void> failWorkout(Workout workouT) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/workouts');

    DateTime time = DateTime.now();

    await workoutsCollection
        .doc(workouT.workoutId)
        .update({'failed': true, 'pending': false, 'date': time.toString()});

    // int index = _workouts
    //     .indexWhere((element) => element.workoutId == workouT.workoutId);
    // _workouts.removeWhere((element) => element.workoutId == workouT.workoutId);
    // _workouts.insert(
    //     index,
    //     Workout(
    //         failed: true,
    //         bannerImage: workouT.bannerImage,
    //         bannerImageLink: workouT.bannerImageLink,
    //         date: time,
    //         creatorName: workouT.creatorName,
    //         creatorId: workouT.creatorId,
    //         workoutId: workouT.workoutId,
    //         workoutName: workouT.workoutName,
    //         instagram: workouT.instagram,
    //         facebook: workouT.facebook,
    //         tiktokLink: workouT.tiktokLink,
    //         pending: false,
    //         exercises: workouT.exercises));
    notifyListeners();
  }
}
