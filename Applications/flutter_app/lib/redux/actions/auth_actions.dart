import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/authorization.dart';


class SignInPageAway {

}

class SignInPageAwaySuccessful {
  final Auth auth;

  SignInPageAwaySuccessful({@required this.auth});
}


class SignIn {
  final String email;
  final String password;

  SignIn(this.email, this.password);
}

class SignInSuccessful {
  final Auth auth;

  SignInSuccessful({@required this.auth});

  @override
  String toString() {
    return "SignIn auth: ${auth}";
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

class LogOut {}

class LogOutSuccessful {
  final Auth auth;

  LogOutSuccessful({@required this.auth});

  @override
  String toString() {
    return "SignIn user: null";
  }
}