import 'package:flutter_app/redux/models/authorization.dart';

class AppState {
  final Auth auth;

  AppState({this.auth});

  AppState copyWith({Auth auth}) {
    return new AppState(
      auth: auth ?? this.auth
    );
  }

  @override
  String toString() {
    return 'AppState{auth: $auth}';
  }
}