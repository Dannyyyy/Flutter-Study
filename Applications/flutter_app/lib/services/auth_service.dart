import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthMethods {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();

  bool isAuthorize();
}

class AuthService implements BaseAuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser _user = null;

  bool isAuthorize() => _user != null;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    _user = user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    _user = user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    _user = null;
    return _firebaseAuth.signOut();
  }
}