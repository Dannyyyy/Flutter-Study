import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  @override
  createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  static const MethodChannel methodChannel = MethodChannel('dannyyyy/battery_level');
  //static const EventChannel eventChannel =
  //EventChannel('samples.flutter.io/charging');

  Color batteryColor = Colors.red;
  String _batteryLevel = 'Battery level: unknown.';
  String _model = 'Model: unknown.';
  String _chargingStatus = 'Battery status: unknown.';

  bool _bluetooth = true;
  bool _alarms = false, _camera = false, _wifi = false, _isDelay = false, _isSaving = false;

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

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await methodChannel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level: $result%';
      batteryColor = new Color.fromARGB(result+150, result+150, result+150, result+150);
    } on PlatformException {
      batteryColor = Colors.red;
      batteryLevel = 'Failed to get battery level.';
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _getModel() async {
    String model;
    try {
      final String result = await methodChannel.invokeMethod('getModel');
      model = 'Model: ${result}';
    } on PlatformException {
      batteryColor = Colors.red;
      model = 'Failed to get model.';
    }
    setState(() {
      _model = model;
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
            title: Text('Enable Bluetooth?',
              style: TextStyle(color: _bluetooth ? Colors.lightBlueAccent : Colors.black54)
            ),
            value: _bluetooth,
            activeColor: Colors.lightBlueAccent,
            onChanged: (bool value) {
              setState(() {
                _bluetooth = value;
              });
            },
            secondary: Icon(Icons.bluetooth, color: _bluetooth ? Colors.lightBlueAccent : Colors.black54,),
          ),
          new SwitchListTile(
            title: Text('Alarms',
              style: TextStyle(color: _alarms ? Colors.deepPurpleAccent : Colors.black54)
            ),
            value: _alarms,
            activeColor: Colors.deepPurpleAccent,
            onChanged: (bool value) {
              setState(() {
                _alarms = value;
              });
            },
            secondary: Icon(Icons.access_alarms, color: _alarms ? Colors.deepPurpleAccent : Colors.black54,),
          ),
          new SwitchListTile(
            title: Text('Camera',
              style: TextStyle(color: _camera ? Colors.orange : Colors.black54)
            ),
            value: _camera,
            activeColor: Colors.orange,
            onChanged: (bool value) {
              setState(() {
                _camera = value;
              });
            },
            secondary: Icon(Icons.camera, color: _camera ? Colors.orange : Colors.black54,),
          ),
          new SwitchListTile(
            title: Text('WiFi',
              style: TextStyle(color: _wifi ? Colors.blue : Colors.black54)
            ),
            value: _wifi,
            onChanged: (bool value) {
              setState(() {
                _wifi = value;
              });
            },
            secondary: Icon(Icons.wifi, color: _wifi ? Colors.blue : Colors.black54),
          ),
          new RaisedButton(
            onPressed: _submit,
            child: new Text('Save'),
          ),
          new Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: batteryColor,
                borderRadius: BorderRadius.all(Radius.circular(5))
            ),

            child: Column(children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text('${_batteryLevel}'),
                  new SizedBox(width: 10,),
                  new SizedBox(child:
                    new RawMaterialButton(
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.orange[100],
                      padding: const EdgeInsets.all(5.0),
                      onPressed: _getBatteryLevel,
                      child: Icon(Icons.refresh),
                    ),
                    width: 40,
                    height: 40,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              new Row(
                children: <Widget>[
                  new Text('${_model}'),
                  new SizedBox(width: 10,),
                  new SizedBox(child:
                    new RawMaterialButton(
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.orange[100],
                      padding: const EdgeInsets.all(5.0),
                      onPressed: _getModel,
                      child: Icon(Icons.refresh),
                    ),
                    width: 40,
                    height: 40,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )
            ],
            ),
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