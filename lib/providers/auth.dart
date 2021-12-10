import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teenfit/screens/auth/intro_page.dart';

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

    if (userId == "7fFAYf9jHDg7KtOcEiSfk4fBATv2") {
      isAdminResult = true;
    } else {
      isAdminResult = false;
    }
    return isAdminResult;
  }

  Future<void> signup(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      getCurrentUID();
      print(userId);
    } on FirebaseAuthException catch (e) {
      print(e);
      throw HttpException(e.code.toString());
    } catch (e) {
      throw HttpException('Unable To Signup, Connect To Servers');
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      getCurrentUID();
      print(userId);
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
