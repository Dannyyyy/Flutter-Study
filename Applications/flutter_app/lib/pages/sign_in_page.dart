import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:validator/validator.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_app/services/auth_service.dart';

class SignInPage extends StatefulWidget {
  final AuthService _authService;

  SignInPage(this._authService);

  @override
  createState() => new _SignInPageState(this._authService);
}

class _SignInPageState extends State<SignInPage>
{
  FirebaseUser user = null;
  final AuthService _authService;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool _isDelay = false;

  SignInModel model = new SignInModel();
  String _password = '';
  _SignInPageState(this._authService);

  String isPassword(String password) {
    if (!password.isEmpty)
    {
      if(password.length < 6)
      {
        return "At least 6 characters";
      }

      _password = password;
      return null;
    }
    _password = '';
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

  void _submit() {
    setState(() {
      _isDelay = true;
    });

    new Future.delayed(new Duration(seconds: 4), () {
      Navigator.of(context).pop();
    });
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save();
      _authService.signIn(model.email, model.password)
        .then((value) =>
          _submit()
        )
        .catchError((_) => showMessage('Error!'));
    }
  }

  Widget _buildModalBarrier()
  {
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
          new Text("Succesful sign in...")
        ],
          mainAxisAlignment: MainAxisAlignment.center,
        )
        ),
      ],
    );
  }

  Widget _buildForm()
  {
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
              onSaved: (val) => model.email = val,
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
              onSaved: (val) => model.password = val,
            ),
            new Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: new RaisedButton(
                  child: const Text('Submit'),
                  onPressed: _submitForm,
                )),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = widget._authService;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Sign in")),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: _isDelay ? _buildModalBarrier() : _buildForm()
      ),
    );
  }
}

class SignInModel {
  String email;
  String password;
}