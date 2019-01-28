import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget
{
  @override
  createState() => new _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: new AppBar(
        title: new Text('Info'),
      ),
      body: new Center(child:
        new Column(children: <Widget>[
          new Icon(
            Icons.info,
            size: 150.0,
            color: Colors.black12
          ),
          new Text("Info about app.")
          ]
        )
      ),
    );
  }
}