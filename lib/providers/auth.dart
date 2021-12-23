import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teenfit/screens/auth/error_screen.dart';
import 'package:teenfit/screens/auth/loading.dart';
import 'package:teenfit/screens/auth/signup_screen.dart';
import 'package:teenfit/screens/home_screen.dart';
import 'package:teenfit/screens/my_workouts.dart';
import 'package:teenfit/screens/workout_page.dart';

import '../Custom/http_execption.dart';

class Auth with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Stream<User?>? get onAuthStateChanged {
    return isAuthChanged();
  }

  Stream<User?>? isAuthChanged() {
    return FirebaseAuth.instance.authStateChanges().asBroadcastStream().cast();
  }

  String get userId {
    return getCurrentUID();
  }

  StreamBuilder isAuth() {
    return StreamBuilder<User?>(
      initialData: FirebaseAuth.instance.currentUser,
      stream: onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var isAuth = snapshot.data;
          return Builder(
            builder: (context) {
              return isAuth != null ? CreateWorkout() : SignupScreen();
            },
          );
        } else if (snapshot.hasError) {
          return ErrorScreen();
        } else {
          return LoadingScreen();
        }
      },
    );
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

    if (userId == "fu9uLdEgQCX3jsVrOMcU4KFmNCr1" ||
        userId == '68SoGmjDUaXpEPP4VfbCB2j9lr32') {
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
      Navigator.of(context).pushReplacementNamed(CreateWorkout.routeName);
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

      Navigator.of(context).pushReplacementNamed(WorkoutPage.routeName);
      await FirebaseAnalytics.instance.logLogin();
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
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
    } catch (e) {
      throw e;
    }
  }
}
