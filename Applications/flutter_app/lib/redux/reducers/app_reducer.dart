import 'package:flutter_app/redux/app_state.dart';
import 'package:flutter_app/redux/reducers/counter_reducer.dart';
import 'package:flutter_app/redux/reducers/auth_reducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState()
    ..auth = authReducer(state.auth, action);
}