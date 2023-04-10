import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_training/src/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isLoading = false;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? userEvent) {
      user = (userEvent == null) ? null : userEvent;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    user = _auth.currentUser;
    notifyListeners();
  }

  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        throw AuthException("Wrong password! Try again!");
      } else if (e.code == "user-not-found") {
        throw AuthException(
            "There's no user for the provided email. Try again with a different one.");
      }
    }
  }

  register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        throw AuthException("Your password is too weak! Try another one!");
      } else if (e.code == "email-already-in-use") {
        throw AuthException("The given email is already in use.");
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}
