import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/redux/actions/auth_actions.dart';
import 'package:flutter_app/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/models/authorization.dart';

class SignInPage extends StatefulWidget {
  @override
  createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Timer _timer;
  bool _onlyOnceShowError = true;

  SignInModel model = new SignInModel();
  String _password = '';

  @override
  dispose(){
    _timer?.cancel();
    super.dispose();
  }

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

  void _submitForm(SignInStore _model) {
    final FormState form = _formKey.currentState;
    FocusScope.of(context).requestFocus(new FocusNode());
    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save();
      _onlyOnceShowError = true;
      _model.onPressedCallback(model.email, model.password);
    }
  }

  Widget _buildModalBarrier()
  {
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
          new Text("Succesful sign in...")
        ],
          mainAxisAlignment: MainAxisAlignment.center,
        )
        ),
      ],
    );
  }

  Future<bool>_goAway(SignInStore _model) {
    _model.goAway();
    return Future<bool>.value(true);
  }

  Widget _buildForm(SignInStore _model)
  {
    if((_model.auth?.isError ?? false) && _onlyOnceShowError)
    {
      _onlyOnceShowError = false;
      showMessage(_model.auth.error);
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
                  onPressed: () => _submitForm(_model),
                )),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, SignInStore>(
      converter: SignInStore.fromStore,
      builder: (BuildContext context, SignInStore model)
      {
        return new WillPopScope(
          onWillPop: () => _goAway(model),
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
  final Function goAway;
  final Function onPressedCallback;
  final Auth auth;

  SignInStore({this.onPressedCallback, this.goAway, this.auth});

  static SignInStore fromStore(Store<AppState> store) {

    print(store.state);

    return new SignInStore(
      onPressedCallback: (String email, String password) {
        store.dispatch(SignIn(email, password));
      },
      goAway: () {
        store.dispatch(SignInPageAway());
      },
      auth: store.state.auth
    );
  }
}

class SignInModel {
  String email;
  String password;
}