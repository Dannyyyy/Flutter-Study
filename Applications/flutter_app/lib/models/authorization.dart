import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  String error;
  FirebaseUser user;

  bool get isError => error.isNotEmpty;
  bool get isAuthorize => user != null;

  Auth() {
    error = '';
  }

  @override
  String toString() {
    return "${user}, ${error}";
  }
}