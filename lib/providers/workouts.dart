import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '/providers/exercise.dart';
import '/Custom/http_execption.dart';
import './workout.dart';
import 'auth.dart';

class Workouts with ChangeNotifier {
  CollectionReference workoutsCollection =
      FirebaseFirestore.instance.collection('/workouts');

  Future<Map> authAccount() async {
    var idAndKey = '004b2d9d74e33f20000000002:K004Cxur8QzR+hXtzoaYmfPPNiop4H0';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    var basicAuthString = 'Basic' + stringToBase64.encode(idAndKey);
    var headers = {'Authorization': basicAuthString};

    var request = await http.get(
        Uri.parse('https://api.backblazeb2.com/b2api/v2/b2_authorize_account'),
        headers: headers);

    Map<String, dynamic> response =
        await json.decode(request.body) as Map<String, dynamic>;

    return response;
  }

  Future<Map> getUploadUrl() async {
    Map authResponse = await authAccount();

    var apiUrl = authResponse['apiUrl'];
    var authorizationToken = authResponse['authorizationToken'];
    var bucketId = authResponse['allowed']['bucketId'];

    var request = await http.post(
      Uri.parse('$apiUrl/b2api/v2/b2_get_upload_url'),
      body: json.encode({'bucketId': bucketId}),
      headers: {'Authorization': authorizationToken},
    );

    Map<String, dynamic> response =
        await json.decode(request.body) as Map<String, dynamic>;

    return response;
  }

  Future<void> addWorkout(Workout workouT) async {
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
      var uploadResponse = await getUploadUrl();
      var uploadUrl = uploadResponse['uploadUrl'];
      var uploadAuthToken = uploadResponse['authorizationToken'];
      var contentType = 'b2/x-auto';
      var sha1 = 'do_not_verify';

      do {
        if (exerciseS[i].exerciseImage != null) {
          File file = exerciseS[i].exerciseImage!;
          Uint8List fileData = await file.readAsBytes();
          String fileName = workouT.workoutId +
              '/' +
              exerciseS[i].exerciseId +
              workouT.workoutId;

          await http.post(
            Uri.parse(uploadUrl),
            body: fileData,
            headers: {
              'Authorization': uploadAuthToken,
              'X-Bz-File-Name': fileName,
              'Content-Type': contentType,
              'X-Bz-Content-Sha1': sha1,
              'X-Bz-Info-Author': 'unknown',
              'X-Bz-Server-Side-Encryption': 'AES256'
            },
          );
        }

        if (exerciseS[i].exerciseImage2 != null) {
          File file2 = exerciseS[i].exerciseImage2!;
          Uint8List fileData2 = await file2.readAsBytes();
          String fileName2 = workouT.workoutId +
              '/' +
              exerciseS[i].exerciseId +
              workouT.workoutId +
              'second';

          await http.post(
            Uri.parse(uploadUrl),
            body: fileData2,
            headers: {
              'Authorization': uploadAuthToken,
              'X-Bz-File-Name': fileName2,
              'Content-Type': contentType,
              'X-Bz-Content-Sha1': sha1,
              'X-Bz-Info-Author': 'unknown',
              'X-Bz-Server-Side-Encryption': 'AES256'
            },
          );
        }

        exerciseImages.add({
          'image2': exerciseS[i].exerciseImage2 != null
              ? "https://f004.backblazeb2.com/file/workoutImages/${workouT.workoutId}/${exerciseS[i].exerciseId}${workouT.workoutId}second"
              : null,
          'image': exerciseS[i].exerciseImage != null
              ? "https://f004.backblazeb2.com/file/workoutImages/${workouT.workoutId}/${exerciseS[i].exerciseId}${workouT.workoutId}"
              : null,
          'id': exerciseS[i].exerciseId + workouT.workoutId,
        });

        i = i + 1;
      } while (i < exerciseS.length);
    }

    try {
      var uploadResponse = await getUploadUrl();
      var uploadUrl = uploadResponse['uploadUrl'];
      var uploadAuthToken = uploadResponse['authorizationToken'];
      var contentType = 'b2/x-auto';
      var sha1 = 'do_not_verify';

      File file = workouT.bannerImage!;
      Uint8List fileData = await file.readAsBytes();
      String fileName = workouT.workoutId + '/' + workouT.workoutId;

      await http.post(
        Uri.parse(uploadUrl),
        body: fileData,
        headers: {
          'Authorization': uploadAuthToken,
          'X-Bz-File-Name': fileName,
          'Content-Type': contentType,
          'X-Bz-Content-Sha1': sha1,
          'X-Bz-Info-Author': 'unknown',
          'X-Bz-Server-Side-Encryption': 'AES256'
        },
      );

      final url =
          "https://f004.backblazeb2.com/file/workoutImages/${workouT.workoutId}/${workouT.workoutId}";

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
          'exerciseImage': exerciseImages[exerciseIndex]['image'],
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
        'searchTerms': searchTermsList,
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
      var uploadResponse = await getUploadUrl();
      var uploadUrl = uploadResponse['uploadUrl'];
      var uploadAuthToken = uploadResponse['authorizationToken'];
      var contentType = 'b2/x-auto';
      var sha1 = 'do_not_verify';

      do {
        if (exerciseS[i].exerciseImage != null) {
          File file = exerciseS[i].exerciseImage!;
          Uint8List fileData = await file.readAsBytes();
          String fileName = workouT.workoutId +
              '/' +
              exerciseS[i].exerciseId +
              workouT.workoutId;

          await http.post(
            Uri.parse(uploadUrl),
            body: fileData,
            headers: {
              'Authorization': uploadAuthToken,
              'X-Bz-File-Name': fileName,
              'Content-Type': contentType,
              'X-Bz-Content-Sha1': sha1,
              'X-Bz-Info-Author': 'unknown',
              'X-Bz-Server-Side-Encryption': 'AES256'
            },
          );
        }

        if (exerciseS[i].exerciseImage2 != null) {
          File file2 = exerciseS[i].exerciseImage2!;
          Uint8List fileData2 = await file2.readAsBytes();
          String fileName2 = workouT.workoutId +
              '/' +
              exerciseS[i].exerciseId +
              workouT.workoutId +
              'second';

          await http.post(
            Uri.parse(uploadUrl),
            body: fileData2,
            headers: {
              'Authorization': uploadAuthToken,
              'X-Bz-File-Name': fileName2,
              'Content-Type': contentType,
              'X-Bz-Content-Sha1': sha1,
              'X-Bz-Info-Author': 'unknown',
              'X-Bz-Server-Side-Encryption': 'AES256'
            },
          );
        }

        exerciseImages.add({
          'image2': exerciseS[i].exerciseImage2 != null
              ? "https://f004.backblazeb2.com/file/workoutImages/${workouT.workoutId}/${exerciseS[i].exerciseId}${workouT.workoutId}second"
              : exerciseS[i].exerciseImageLink2,
          'image': exerciseS[i].exerciseImage != null
              ? "https://f004.backblazeb2.com/file/workoutImages/${workouT.workoutId}/${exerciseS[i].exerciseId}${workouT.workoutId}"
              : exerciseS[i].exerciseImageLink,
          'id': exerciseS[i].exerciseId + workouT.workoutId,
        });

        i = i + 1;
      } while (i < exerciseS.length);

      Map authResponse = await authAccount();

      var apiUrl = authResponse['apiUrl'];
      var authorizationToken = authResponse['authorizationToken'];
      var bucketId = authResponse['allowed']['bucketId'];

      var request = await http.post(
          Uri.parse('$apiUrl/b2api/v2/b2_list_file_names'),
          body: json.encode(
              {'bucketId': bucketId, 'prefix': '${workouT.workoutId}/'}),
          headers: {'Authorization': authorizationToken});

      Map<String, dynamic> response =
          await json.decode(request.body) as Map<String, dynamic>;

      List<Map> unavailableExercises = [];

      List files = response['files'];

      files.forEach((element) {
        unavailableExercises.add(
            {'fileName': element['fileName'], 'fileId': element['fileId']});
      });

      int index = 0;
      print('start');
      do {
        unavailableExercises.removeWhere((element) =>
            element['fileName'] ==
            workouT.workoutId +
                '/' +
                exerciseS[index].exerciseId +
                workouT.workoutId);

        unavailableExercises.removeWhere((element) =>
            element['fileName'] ==
            workouT.workoutId +
                '/' +
                exerciseS[index].exerciseId +
                workouT.workoutId +
                'second');

        index = index + 1;
      } while (index < exerciseS.length);

      unavailableExercises.removeWhere((element) =>
          element['fileName'] == workouT.workoutId + '/' + workouT.workoutId);

      unavailableExercises.forEach((element) async {
        await http.post(
          Uri.parse('$apiUrl/b2api/v2/b2_delete_file_version'),
          body: json.encode(
              {'fileName': element['fileName'], 'fileId': element['fileId']}),
          headers: {'Authorization': authorizationToken},
        );
      });
    }

    try {
      var uploadResponse = await getUploadUrl();
      var uploadUrl = uploadResponse['uploadUrl'];
      var uploadAuthToken = uploadResponse['authorizationToken'];
      var contentType = 'b2/x-auto';
      var sha1 = 'do_not_verify';

      if (workouT.bannerImage != null) {
        File file = workouT.bannerImage!;
        Uint8List fileData = await file.readAsBytes();
        String fileName = workouT.workoutId + '/' + workouT.workoutId;

        await http.post(
          Uri.parse(uploadUrl),
          body: fileData,
          headers: {
            'Authorization': uploadAuthToken,
            'X-Bz-File-Name': fileName,
            'Content-Type': contentType,
            'X-Bz-Content-Sha1': sha1,
            'X-Bz-Info-Author': 'unknown',
            'X-Bz-Server-Side-Encryption': 'AES256'
          },
        );
      }

      final url =
          "https://f004.backblazeb2.com/file/workoutImages/${workouT.workoutId}/${workouT.workoutId}";
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
          'exerciseImage': exerciseImages[exerciseIndex]['image'],
          'exerciseImage2': exerciseImages[exerciseIndex]['image2'],
        };
      }).toList();

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

      notifyListeners();
    } on FirebaseException catch (e) {
      throw HttpException(e.toString());
    } catch (e) {
      throw HttpException(e.toString());
    }
    notifyListeners();
  }

  Future<void> deleteWorkout(Workout workouT) async {
    Future<void> deleteImages() async {
      Map authResponse = await authAccount();

      var apiUrl = authResponse['apiUrl'];
      var authorizationToken = authResponse['authorizationToken'];
      var bucketId = authResponse['allowed']['bucketId'];

      var request =
          await http.post(Uri.parse('$apiUrl/b2api/v2/b2_list_file_names'),
              body: json.encode({
                'bucketId': bucketId,
                'prefix': '${workouT.workoutId}/',
              }),
              headers: {
            'Authorization': authorizationToken,
          });

      Map<String, dynamic> response =
          await json.decode(request.body) as Map<String, dynamic>;

      List<Map> unavailableExercises = [];

      List files = response['files'];

      files.forEach((element) {
        unavailableExercises.add(
            {'fileName': element['fileName'], 'fileId': element['fileId']});
      });

      unavailableExercises.forEach((element) async {
        await http.post(
          Uri.parse('$apiUrl/b2api/v2/b2_delete_file_version'),
          body: json.encode(
              {'fileName': element['fileName'], 'fileId': element['fileId']}),
          headers: {'Authorization': authorizationToken},
        );
      });
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

  Future<void> acceptWorkout(Workout workouT) async {
    DateTime time = DateTime.now();

    await workoutsCollection
        .doc(workouT.workoutId)
        .update({'pending': false, 'date': time.toString()});

    notifyListeners();
  }

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
    DateTime time = DateTime.now();

    await workoutsCollection
        .doc(workouT.workoutId)
        .update({'failed': true, 'pending': false, 'date': time.toString()});

    notifyListeners();
  }
}
