import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:teenfit/providers/user.dart';

import 'auth.dart';

class UserProv with ChangeNotifier {
  User? _user;

  User get getUser {
    return _user!;
  }

  Future<void> fetchAndSetUser(context) async {
    final uid = Provider.of<Auth>(context, listen: false).userId!;
    final userDoc =
        await FirebaseFirestore.instance.collection('/users').doc(uid).get();

    var email = 'teenfitness.fit@gmail.com';

    var userId = 'fu9uLdEgQCX3jsVrOMcU4KFmNCr1';

    final userRef =
        await FirebaseFirestore.instance.collection('/users').doc(userId);

    await userRef.set({
      'email': email,
      'name': 'user_${userId.toLowerCase()}'.substring(0, 30),
      'bio': null,
      'profilePic': null,
      'following': null,
      'followers': null,
      'uid': ('$userId'),
      'date': null,
      'searchTerms': null,
      'link': null,
    });

    _user = User(
      email: userDoc.data()!['email'],
      name: userDoc.data()!['name'],
      uid: userDoc.data()!['uid'],
      date: userDoc.data()!['date'],
      bio: userDoc.data()!['bio'],
      profilePic: userDoc.data()!['profilePic'],
      followers: userDoc.data()!['followers'],
      following: userDoc.data()!['following'],
      followersNum: userDoc.data()!['followers'] != null
          ? (userDoc.data()!['followers'] as List).length
          : 0,
      followingNum: userDoc.data()!['following'] != null
          ? (userDoc.data()!['following'] as List).length
          : 0,
      searchTerms: userDoc.data()!['searchTerms'],
      link: userDoc.data()!['link'],
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
      followersNum: userDoc.data()!['followers'] != null
          ? (userDoc.data()!['followers'] as List).length
          : 0,
      followingNum: userDoc.data()!['following'] != null
          ? (userDoc.data()!['following'] as List).length
          : 0,
      searchTerms: userDoc.data()!['searchTerms'],
      link: userDoc.data()!['link'],
    );
  }
}
