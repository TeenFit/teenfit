import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teenfit/providers/person.dart';
import 'package:teenfit/screens/auth/intro_page.dart';
import 'package:teenfit/screens/home_screen.dart';

import '../Custom/http_execption.dart';

class Auth with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Person? _person;

  Person get person {
    return _person!;
  }

  Stream<User?>? get onAuthStateChanged {
    return isAuthChanged();
  }

  Stream<User?>? isAuthChanged() {
    return FirebaseAuth.instance.authStateChanges().asBroadcastStream().cast();
  }

  String get userId {
    return getCurrentUID();
  }

  String getCurrentUID() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> updateToken() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.currentUser!.getIdToken(true);
    }
  }

  bool isAdmin() {
    bool isAdminResult = false;

    if (userId == "7fFAYf9jHDg7KtOcEiSfk4fBATv2" ||
        userId == '54D7zfq5I1eEfbeuUXaiaT8rtMH3') {
      isAdminResult = true;
    } else {
      isAdminResult = false;
    }
    return isAdminResult;
  }

  Future<void> signup(
      String email, String password, String name, BuildContext context) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/users');

    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      getCurrentUID();

      await workoutsCollection
          .doc(email)
          .set({'email': email, 'name': name, 'savedWorkouts': []});
      print(userId);

      _person = Person(name: name, email: email, savedWorkouts: []);

      print(userId);
      await FirebaseAnalytics.instance.logSignUp(signUpMethod: 'Email');

      Navigator.of(context).push(PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          transitionsBuilder: (ctx, animation, animationTime, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          pageBuilder: (ctx, animation, animationTime) {
            return HomeScreen();
          }));
    } on FirebaseAuthException catch (e) {
      await auth.signOut();
      print(e);
      throw HttpException(e.code.toString());
    } catch (e) {
      await auth.signOut();
      throw HttpException('Unable To Signup, Connect To Servers');
    }
    notifyListeners();
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    CollectionReference workoutsCollection =
        FirebaseFirestore.instance.collection('/users');

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      getCurrentUID();

      await workoutsCollection.doc(email).get().then((value) => _person =
          Person(
              name: value['name'],
              email: value['email'],
              savedWorkouts: value['savedWorkouts']));

      print(userId);
      await FirebaseAnalytics.instance.logLogin();

      Navigator.of(context).push(PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          transitionsBuilder: (ctx, animation, animationTime, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          pageBuilder: (ctx, animation, animationTime) {
            return HomeScreen();
          }));
    } on FirebaseAuthException catch (e) {
      await auth.signOut();
      throw HttpException(e.code.toString());
    } catch (_) {
      await auth.signOut();
      throw HttpException('Unable To Login, Connect To Servers');
    }
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    try {
      await auth.signOut();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => IntroPage()),
        ModalRoute.withName('/'),
      );
    } catch (e) {
      throw e;
    }
  }

  Future<void> passwordReset(String _email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
    } catch (e) {
      throw e;
    }
  }
}
