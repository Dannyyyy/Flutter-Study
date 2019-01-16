import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => new SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _bluetooth = true;
  bool _alarms = false;
  bool _camera = false;
  bool _wifi = false;
  bool _isDelay = false;
  bool _isSaving = false;

  void _submit() {
    setState(() {
      _isDelay = true;
      _isSaving = true;
    });

    new Future.delayed(new Duration(seconds: 4), () {
      setState(() {
        _isDelay = false;
      });
    });
  }

  Future<bool> _canLeave(BuildContext context) {

    if(_isSaving)
      return new Future<bool>.value(true);

    return showDialog(
      context: context,
      builder : (context) => new AlertDialog(
        title: new Text('Warning'),
        content: new Text('Exit without save setting changes?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  List<Widget> _buildForm(BuildContext context) {
    Form form = new Form(
      child: new Column(
        children: [
          new CheckboxListTile(
            title: const Text('Enable Bluetooth?'),
            value: _bluetooth,
            onChanged: (bool value) {
              setState(() {
                _bluetooth = value;
              });
            },
            secondary: const Icon(Icons.bluetooth),
          ),
          new SwitchListTile(
            title: const Text('Alarms'),
            value: _alarms,
            onChanged: (bool value) {
              setState(() {
                _alarms = value;
              });
            },
            secondary: const Icon(Icons.access_alarms),
          ),
          new SwitchListTile(
            title: const Text('Camera'),
            value: _camera,
            onChanged: (bool value) {
              setState(() {
                _camera = value;
              });
            },
            secondary: const Icon(Icons.camera),
          ),
          new SwitchListTile(
            title: const Text('WiFi'),
            value: _wifi,
            onChanged: (bool value) {
              setState(() {
                _wifi = value;
              });
            },
            secondary: const Icon(Icons.wifi),
          ),
          new RaisedButton(
            onPressed: _submit,
            child: new Text('Save'),
          ),
        ],
      ),
    );

    var widgets = new List<Widget>();
    widgets.add(form);

    if (_isDelay) {
      var modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          new Center(
            child: new CircularProgressIndicator(),
          ),
        ],
      );
      widgets.add(modal);
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () => _canLeave(context),
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Settings'),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: new Stack(
          children: _buildForm(context),
        ),
      )
    );
  }
}