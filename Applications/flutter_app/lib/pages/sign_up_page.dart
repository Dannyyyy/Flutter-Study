import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/redux/actions/auth_actions.dart';
import 'package:flutter_app/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/redux/models/authorization.dart';

class SignUpPage extends StatefulWidget {
  @override
  createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _emailKey = new GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordKey = new GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _repeatPasswordKey = new GlobalKey<FormFieldState<String>>();

  Timer _timer;

  bool visiblePassword = false;
  bool visibleRepeatPassword = false;

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> _leavePage(SignUpStore _store) {
    if(_store.auth?.isError ?? false) {
      _store.onErrorShowCallback();
    }

    return Future<bool>.value(true);
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

  String isRepeatPassword(String password) {
    if (!password.isEmpty) {
      if(password.length < 6) {
        return "At least 6 characters";
      }

      String _password = _passwordKey.currentState.value;

      if(_password != null &&_password.isNotEmpty && password == _password) {
        return null;
      }
      return "Password don\'t match";
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

  void _submitForm(SignUpStore _model) {
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
        new Center(child:
        new Column(children: <Widget>[
          new LinearProgressIndicator(
            backgroundColor: Colors.orange,
          ),
          new Text("Succesful sign up...")
        ],
          mainAxisAlignment: MainAxisAlignment.center,
        )
        ),
      ],
    );
  }

  Widget _buildForm(SignUpStore store) {
    if(store.auth?.isError ?? false) {
      store.onErrorShowCallback();
      showMessage(store.auth.error);
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
            key: _emailKey
          ),
          new TextFormField(
            decoration: InputDecoration(
              suffixIcon: new IconButton(
                icon: new Icon(visiblePassword ?  Icons.visibility : Icons.visibility_off),
                onPressed:() {
                  setState(() {
                    visiblePassword = !visiblePassword;
                  });
                }
              ),
              icon: const Icon(Icons.apps),
              hintText: 'Enter a password',
              labelText: 'Password',
            ),
            keyboardType: TextInputType.text,
            inputFormatters: [new LengthLimitingTextInputFormatter(10)],
            validator: (val) => isPassword(val),
            key: _passwordKey,
            obscureText: visiblePassword ? false : true,
          ),
          new TextFormField(
            decoration: InputDecoration(
              suffixIcon: new IconButton(
                icon: new Icon(visibleRepeatPassword ?  Icons.visibility : Icons.visibility_off),
                onPressed:() {
                  setState(() {
                    visibleRepeatPassword = !visibleRepeatPassword;
                  });
                }
              ),
              icon: const Icon(Icons.apps),
              hintText: 'Enter a password',
              labelText: 'Password',
            ),
            keyboardType: TextInputType.text,
            inputFormatters: [new LengthLimitingTextInputFormatter(10)],
            validator: (val) => isRepeatPassword(val),
            key: _repeatPasswordKey,
            obscureText: visibleRepeatPassword ? false : true,
          ),
          new Container(
            padding: const EdgeInsets.only(left: 40.0, top: 20.0),
            child: new RaisedButton(
              child: const Text('Sign Up'),
              onPressed: () => _submitForm(store),
            )),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, SignUpStore>(
      converter: SignUpStore.fromStore,
      builder: (BuildContext context, SignUpStore store) {
        return new WillPopScope(
          onWillPop: () => _leavePage(store),
          child: new Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(title: Text("Sign up")),
            body: new SafeArea(
              top: false,
              bottom: false,
              child: store.auth?.user != null ? _buildModalBarrier() : _buildForm(store)
            ),
          )
        );
      }
    );
  }
}

class SignUpStore {
  final Function onErrorShowCallback;
  final Function onSignInPressedCallback;
  final Auth auth;

  SignUpStore({this.onSignInPressedCallback, this.onErrorShowCallback, this.auth});

  static SignUpStore fromStore(Store<AppState> store) {
    return new SignUpStore(
      onSignInPressedCallback: (String email, String password) {
        store.dispatch(SignUp(email, password));
      },
      onErrorShowCallback: () {
        store.dispatch(AuthErrorShow());
      },
      auth: store.state.auth
    );
  }
}