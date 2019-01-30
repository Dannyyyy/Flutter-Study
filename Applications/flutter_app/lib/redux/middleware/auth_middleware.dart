import 'package:flutter_app/redux/actions/auth_actions.dart';
import 'package:flutter_app/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/redux/models/authorization.dart';

List<Middleware<AppState>> createAuthMiddlewares() {
  final signIn = _createSignInMiddleware();
  final logOut = _createLogOutMiddleware();

  final authErrorShow = _createAuthErrorShowMiddleware();

  List<Middleware<AppState>> _middlewares = new List<Middleware<AppState>>();

  _middlewares.add(new TypedMiddleware<AppState, SignIn>(signIn));
  _middlewares.add(new TypedMiddleware<AppState, LogOut>(logOut));
  _middlewares.add(new TypedMiddleware<AppState, AuthErrorShow>(authErrorShow));

  return _middlewares;
}

Middleware<AppState> _createSignInMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    if (action is SignIn) {
      try {
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: action.email, password: action.password);
        store.dispatch(SignInSuccessful(auth: new Auth()..user = user));
      }
      catch(error) {
        store.dispatch(SignInFail(auth: new Auth()..error = error.toString()));
      }
    }
    next(action);
  };
}

Middleware<AppState> _createLogOutMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    if (action is LogOut) {
      try {
        await FirebaseAuth.instance.signOut();
        store.dispatch(LogOutSuccessful(auth: new Auth()..user = null));
      }
      catch(error) {
        print("Error: ${error}");
      }
    }
    next(action);
  };
}

Middleware<AppState> _createAuthErrorShowMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    store.dispatch(AuthErrorShowSuccessful(auth: new Auth()..error = ''));
    next(action);
  };
}