import 'package:flutter_app/redux/models/authorization.dart';
import 'package:flutter_app/redux/models/cloud_message.dart';

class AppState {
  final Auth auth;
  final CloudMessage notification;
  
  AppState({this.auth, this.notification});

  AppState copyWith({Auth auth, CloudMessage notification}) {
    return new AppState(
      auth: auth ?? this.auth,
      notification: notification ?? this.notification
    );
  }

  @override
  String toString() {
    return 'AppState{auth: $auth, message: $notification}';
  }
}