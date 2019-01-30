import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/redux/actions/auth_actions.dart';
import 'package:flutter_app/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/redux/models/authorization.dart';

class SignInPage extends StatefulWidget {
  @override
  createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _emailKey = new GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordKey = new GlobalKey<FormFieldState<String>>();

  Timer _timer;

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String isPassword(String password) {
    if (!password.isEmpty) {
      if(password.length < 6) {
        return "At least 6 characters";
      }

      return null;
    }

    return "Required password";
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState
      .showSnackBar(
        new SnackBar(
          backgroundColor: color,
          content: new Text(message),
          duration: Duration(seconds: 3),
        )
    );
  }

  void _submitForm(SignInStore _model) {
    final FormState form = _formKey.currentState;

    FocusScope.of(context).requestFocus(new FocusNode());

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    }
    else {
      final FormFieldState<String> passwordField = _passwordKey.currentState;
      final FormFieldState<String> emailField = _emailKey.currentState;
      _model.onSignInPressedCallback(emailField.value, passwordField.value);
    }
  }

  Widget _buildModalBarrier() {
    _timer = Timer(Duration(seconds: 2), () => Navigator.of(context).pop());

    return new Stack(
      children: [
        new Opacity(
          opacity: 0.3,
          child: const ModalBarrier(dismissible: false, color: Colors.grey),
        ),
        new Center(
          child: new Column(
            children: <Widget>[
              new LinearProgressIndicator(
                backgroundColor: Colors.orange,
              ),
              new Text("Successful sign in...")
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
        ),
      ],
    );
  }

  Future<bool> _leavePage(SignInStore _store) {
    if(_store.auth.isError) {
      _store.onErrorShowCallback();
    }

    return Future<bool>.value(true);
  }

  Widget _buildForm(SignInStore _store) {
    if(_store.auth?.isError ?? false) {
      _store.onErrorShowCallback();
      showMessage(_store.auth.error);
    }

    return new Form(
      key: _formKey,
      autovalidate: true,
      child: new ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          new TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.email),
              hintText: 'Enter your email',
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [new LengthLimitingTextInputFormatter(30)],
            validator: (val) => val.isEmpty ? 'Email is required' : null,
            key: _emailKey,
          ),
          new TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.apps),
              hintText: 'Enter a password',
              labelText: 'Password',
            ),
            keyboardType: TextInputType.text,
            inputFormatters: [new LengthLimitingTextInputFormatter(10)],
            validator: (val) => isPassword(val),
            key: _passwordKey,
          ),
          new Container(
            padding: const EdgeInsets.only(left: 40.0, top: 20.0),
            child: new RaisedButton(
              child: const Text('Sign In'),
              onPressed: () => _submitForm(_store),
            )
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, SignInStore>(
      converter: SignInStore.fromStore,
      builder: (BuildContext context, SignInStore model) {
        return new WillPopScope(
          onWillPop: () => _leavePage(model),
          child: new Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(title: Text("Sign in")),
            body: new SafeArea(
              top: false,
              bottom: false,
              child: model.auth?.user != null ? _buildModalBarrier() : _buildForm(model)
            ),
          )
        );
      }
    );
  }
}

class SignInStore {
  final Function onErrorShowCallback;
  final Function onSignInPressedCallback;
  final Auth auth;

  SignInStore({this.onSignInPressedCallback, this.onErrorShowCallback, this.auth});

  static SignInStore fromStore(Store<AppState> store) {
    return new SignInStore(
      onSignInPressedCallback: (String email, String password) {
        store.dispatch(SignIn(email, password));
      },
      onErrorShowCallback: () {
        store.dispatch(AuthErrorShow());
      },
      auth: store.state.auth
    );
  }
}

class SignInModel {
  String email;
  String password;
}