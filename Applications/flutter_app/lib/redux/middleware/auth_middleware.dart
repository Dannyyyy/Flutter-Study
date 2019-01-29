import 'package:flutter_app/redux/actions/auth_actions.dart';
import 'package:flutter_app/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/authorization.dart';

List<Middleware<AppState>> createAuthMiddleware() {
  final logIn = _createLogInMiddleware();
  final logOut = _createLogOutMiddleware();
  final signInPageAway = _createSignInPageAwayMiddleware();

  List<Middleware<AppState>> _middlewares = new List<Middleware<AppState>>();

  _middlewares.add(new TypedMiddleware<AppState, SignIn>(logIn));
  _middlewares.add(new TypedMiddleware<AppState, LogOut>(logOut));
  _middlewares.add(new TypedMiddleware<AppState, SignInPageAway>(signInPageAway));

  return _middlewares;
}

Middleware<AppState> _createLogInMiddleware() {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  return (Store store, action, NextDispatcher next) async {

    if (action is SignIn)
    {
      try
      {
        FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
            email: action.email, password: action.password);
        store.dispatch(SignInSuccessful(auth: store.state.auth..user = user));
      }
      catch(error)
      {
        store.dispatch(SignInFail(auth: store.state.auth..error = error.toString()));
      }
    }

    next(action);
  };
}

Middleware<AppState> _createLogOutMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    if (action is LogOut) {
      try
      {
        await _firebaseAuth.signOut();
        store.dispatch(LogOutSuccessful(auth: store.state.auth..user = null));
      }
      catch(error)
      {
        print("Error: ${error}");
      }
    }

    next(action);
  };
}

Middleware<AppState> _createSignInPageAwayMiddleware() {
  return (Store store, action, NextDispatcher next) async {

    store.dispatch(SignInPageAwaySuccessful(auth: store.state.auth..error = ''));

    next(action);
  };
}