import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget
{
  @override
  InfoPageState createState() => new InfoPageState();
}

void _navHome(BuildContext context) {
  Navigator.pop(context);
}

Future<bool> _exitApp(BuildContext context) {
  return showDialog(
    context: context,
    builder : (context) => new AlertDialog(
      title: new Text('Do you want to go Home?'),
      content: new Text('Info page...'),
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

class InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () => _exitApp(context),
        child: Scaffold(
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
            new Text("Info about app."),
            new RaisedButton(
              child: new Text('Back to Home Page'),
              onPressed: () => _navHome(context),
            ),
            ],
          )
        ),
      )
    );
  }
}