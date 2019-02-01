import 'package:flutter_app/redux/app_state.dart';
import 'package:flutter_app/redux/reducers/auth_reducer.dart';
import 'cloud_message_reducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    auth: authReducer(state.auth, action),
    notification: cloudMessageReducer(state.notification, action)
  );
}