import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Custom/http_execption.dart';
import '../screens/home_screen.dart';

class Auth with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Stream<User?>? get onAuthStateChanged {
    return isAuthChanged();
  }

  Stream<User?>? isAuthChanged() {
    return FirebaseAuth.instance.authStateChanges().asBroadcastStream().cast();
  }

  String? get userId {
    return getCurrentUID();
  }

  bool isAuth() {
    return userId != null;
  }

  String? getCurrentUID() {
    return FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser!.uid
        : null;
  }

  Future<void> updateToken() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.currentUser!.getIdToken(true);
    }
  }

  bool isAdmin() {
    bool isAdminResult = false;

    if (isAuth() &&
        (userId == "fu9uLdEgQCX3jsVrOMcU4KFmNCr1" ||
            userId == '68SoGmjDUaXpEPP4VfbCB2j9lr32')) {
      isAdminResult = true;
    } else {
      isAdminResult = false;
    }
    return isAdminResult;
  }

  Future<void> signup(
      String email, String password, BuildContext context) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      getCurrentUID();

      await FirebaseAnalytics.instance.logSignUp(signUpMethod: 'Email');

      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('/users');

      await usersCollection.doc('$userId').set({
        'email': email,
        'name':
            'user_$userId ${email.substring(0, email.indexOf('@')).toLowerCase()}'
                .substring(0, 30),
        'plannedDays': {
          'Monday': [],
          'Tuesday': [],
          'Wednesday': [],
          'Thursday': [],
          'Friday': [],
          'Saturday': [],
          'Sunday': [],
        },
        'bio': null,
        'profilePic': null,
        'following': null,
        'followers': null,
        'uid': ('$userId'),
        'date': DateTime.now().toString(),
        'searchTerms': [
          'user_$userId ${email.substring(0, email.indexOf('@'))}'
              .substring(0, 30)
              .toLowerCase(),
          ''
        ],
        'link': null,
        'instagram': null,
        'tiktok': null,
      });

      notifyListeners();
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } on FirebaseAuthException catch (e) {
      print(e);
      throw HttpException(e.code.toString());
    } catch (e) {
      throw HttpException('Unable To Signup, Connect To Servers');
    }
    notifyListeners();
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      getCurrentUID();
      await FirebaseAnalytics.instance.logLogin();
      notifyListeners();

      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } on FirebaseAuthException catch (e) {
      throw HttpException(e.code.toString());
    } catch (_) {
      throw HttpException('Unable To Login, Connect To Servers');
    }
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    try {
      await auth.signOut();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        ModalRoute.withName('/'),
      );
    } catch (e) {
      throw e;
    }
  }

  Future<void> passwordReset(String _email) async {
    try {
      await auth.sendPasswordResetEmail(email: _email);
    } catch (e) {
      throw e;
    }
  }
}
