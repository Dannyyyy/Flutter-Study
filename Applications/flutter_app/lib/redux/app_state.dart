import 'package:flutter_app/models/authorization.dart';

class AppState {
  Auth auth;

  AppState() {
    auth = new Auth();
  }

  AppState copyWith({Auth auth}) {
    return new AppState()
      ..auth = auth ?? this.auth;
  }

  @override
  String toString() {
    return 'AppState{auth: $auth}';
  }
}