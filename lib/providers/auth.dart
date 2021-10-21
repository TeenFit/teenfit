import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../Custom/http_execption.dart';

class Auth with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Stream<User>? get onAuthStateChanged {
    return isAuthChanged();
  }

  Stream<User>? isAuthChanged() {
    return FirebaseAuth.instance.authStateChanges().asBroadcastStream().cast();
  }

  String get userId {
    return getCurrentUID();
  }

  String getCurrentUID() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> signup(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((_) async {
        if (user != null && !user!.emailVerified) {
          await user!.sendEmailVerification();
        }
      });
      getCurrentUID();
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
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
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
    } catch (e) {
      throw e;
    }
  }
}
