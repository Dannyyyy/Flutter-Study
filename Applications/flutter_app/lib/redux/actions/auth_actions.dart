import 'package:flutter/foundation.dart';
import 'package:flutter_app/redux/models/authorization.dart';

class AuthErrorShow { }

class AuthErrorShowSuccessful {
  final Auth auth;

  AuthErrorShowSuccessful({@required this.auth});
}

class SignIn {
  final String email;
  final String password;

  SignIn(this.email, this.password);
}

class SignUp {
  final String email;
  final String password;

  SignUp(this.email, this.password);
}

class SignInSuccessful {
  final Auth auth;

  SignInSuccessful({@required this.auth});

  @override
  String toString() {
    return "SignIn auth: ${auth}";
  }
}

class SignUpSuccessful {
  final Auth auth;

  SignUpSuccessful({@required this.auth});

  @override
  String toString() {
    return "SignUp auth: ${auth}";
  }
}

class SignInFail {
  final Auth auth;

  SignInFail({@required this.auth});

  @override
  String toString() {
    return "SignIn error: ${auth}";
  }
}

class SignUpFail {
  final Auth auth;

  SignUpFail({@required this.auth});

  @override
  String toString() {
    return "SignUp error: ${auth}";
  }
}

class LogOut {}

class LogOutSuccessful {
  final Auth auth;

  LogOutSuccessful({@required this.auth});

  @override
  String toString() {
    return "SignIn user: null";
  }
}