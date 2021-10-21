import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  bool isAuth() {
    bool isAuthed = false;

    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        isAuthed = false;
        notifyListeners();
      } else {
        print('User is signed in!');
        isAuthed = true;
        notifyListeners();
      }
    });
    return isAuthed;
  }
}
