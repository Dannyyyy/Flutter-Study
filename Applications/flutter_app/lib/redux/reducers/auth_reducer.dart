import 'package:flutter_app/redux/actions/auth_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/models/authorization.dart';

final authReducer = combineReducers<Auth>([
  new TypedReducer<Auth, SignInSuccessful>(_anyAction),
  new TypedReducer<Auth, SignInFail>(_anyAction),
  new TypedReducer<Auth, SignInPageAwaySuccessful>(_anyAction),
  new TypedReducer<Auth, LogOut>(_anyAction),
]);

/*
Auth _logIn(Auth auth, action) {
  return action.auth;
}

Auth _logInFail(Auth auth, action) {
  return action.auth;
}
*/

Auth _anyAction(Auth auth, action) {
  return action.auth;
}