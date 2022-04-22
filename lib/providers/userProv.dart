import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/user.dart';

import 'auth.dart';

class UserProv with ChangeNotifier {
  User? _user;

  User get getUser {
    return _user!;
  }

  Future<Map> authAccount() async {
    var idAndKey = '004b2d9d74e33f20000000003:K004vzBfb9w+bLUXQqtlb9O7B6n7I0A';
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

  Future<void> fetchAndSetUser(context) async {
    final uid = Provider.of<Auth>(context, listen: false).userId!;
    final userDoc =
        await FirebaseFirestore.instance.collection('/users').doc(uid).get();

    // var email = 'teenfitness.fit@gmail.com';

    // var userId = 'fu9uLdEgQCX3jsVrOMcU4KFmNCr1';

    // final userRef =
    //     await FirebaseFirestore.instance.collection('/users').doc(userId);

    // await userRef.set({
    //   'email': email,
    //   'name': 'user_${userId.toLowerCase()}'.substring(0, 30),
    //   'bio': null,
    //   'profilePic': null,
    //   'following': null,
    //   'followers': null,
    //   'uid': ('$userId'),
    //   'date': null,
    //   'searchTerms': null,
    //   'link': null,
    // });

    _user = User(
      email: userDoc.data()!['email'],
      name: userDoc.data()!['name'],
      uid: userDoc.data()!['uid'],
      date: userDoc.data()!['date'],
      bio: userDoc.data()!['bio'],
      profilePic: userDoc.data()!['profilePic'],
      followers: userDoc.data()!['followers'],
      following: userDoc.data()!['following'],
      searchTerms: userDoc.data()!['searchTerms'],
      link: userDoc.data()!['link'],
      instagram: userDoc.data()!['instagram'],
      tiktok: userDoc.data()!['tiktok'],
    );
    notifyListeners();
  }

  Future<User> fetchAUser(context, uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('/users').doc(uid).get();

    return User(
      email: userDoc.data()!['email'],
      name: userDoc.data()!['name'],
      uid: userDoc.data()!['uid'],
      date: userDoc.data()!['date'],
      bio: userDoc.data()!['bio'],
      profilePic: userDoc.data()!['profilePic'],
      followers: userDoc.data()!['followers'],
      following: userDoc.data()!['following'],
      searchTerms: userDoc.data()!['searchTerms'],
      link: userDoc.data()!['link'],
      instagram: userDoc.data()!['instagram'],
      tiktok: userDoc.data()!['tiktok'],
    );
  }

  Future<void> updateUser(User? useR, context) async {
    List<String> searchTermsList = [];

    Future<void> addSearchTerms(String workoutName) async {
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

    try {
      addSearchTerms(useR!.name!);
      var uploadResponse = await getUploadUrl();
      var uploadUrl = uploadResponse['uploadUrl'];
      var uploadAuthToken = uploadResponse['authorizationToken'];
      var contentType = 'b2/x-auto';
      var sha1 = 'do_not_verify';

      if (useR.profilePicFile != null) {
        File file = useR.profilePicFile!;
        Uint8List fileData = await file.readAsBytes();
        String fileName = useR.uid!;

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

      await FirebaseFirestore.instance
          .collection('/users')
          .doc(useR.uid)
          .update({
        'profilePic': useR.profilePicFile != null
            ? 'https://f004.backblazeb2.com/file/profilePics/${useR.uid}'
            : useR.profilePic,
        'name': useR.name,
        'bio': useR.bio,
        'instagram': useR.instagram,
        'tiktok': useR.tiktok,
        'searchTerms': searchTermsList,
      });

      await fetchAndSetUser(context);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void addFollower(String uid) {
    FirebaseFirestore.instance.collection('/users').doc(uid.toString()).update({
      'followers': FieldValue.arrayUnion([_user!.uid.toString()])
    });

    FirebaseFirestore.instance
        .collection('/users')
        .doc(_user!.uid.toString())
        .update({
      'following': FieldValue.arrayUnion([uid.toString()])
    });

    notifyListeners();
  }

  void removeFollower(String uid) {
    FirebaseFirestore.instance.collection('/users').doc(uid.toString()).update({
      'followers': FieldValue.arrayRemove([_user!.uid.toString()])
    });

    FirebaseFirestore.instance
        .collection('/users')
        .doc(_user!.uid.toString())
        .update({
      'following': FieldValue.arrayRemove([uid.toString()])
    });

    notifyListeners();
  }
}
