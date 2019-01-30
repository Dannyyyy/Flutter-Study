import 'package:flutter_app/redux/actions/auth_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/redux/models/authorization.dart';

final authReducer = combineReducers<Auth>([
  new TypedReducer<Auth, SignInSuccessful>(_anyAction),
  new TypedReducer<Auth, SignInFail>(_anyAction),
  new TypedReducer<Auth, SignUpSuccessful>(_anyAction),
  new TypedReducer<Auth, SignUpFail>(_anyAction),
  new TypedReducer<Auth, AuthErrorShowSuccessful>(_anyAction),
  new TypedReducer<Auth, LogOut>(_anyAction),
]);

Auth _anyAction(Auth auth, action) {
  return action.auth;
}