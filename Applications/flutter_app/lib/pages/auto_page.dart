import 'package:flutter/material.dart';
import 'package:flutter_app/models/record.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class AutoPage extends StatefulWidget{
  @override
  createState() => new _AutoPageState();
}

class _AutoPageState extends State<AutoPage>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController eCtrl = new TextEditingController();
  final String collectionsName = "cars";

  Widget _buildBody(BuildContext context)
  {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(collectionsName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return new Center(child: LinearProgressIndicator());
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot)
  {
    return ListView(
      padding: EdgeInsets.only(top: 10),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data)
  {
    final record = Record.fromSnapshot(data);

    return Container(child:
      ListTile(
        title: Text(record.name),
        trailing: Text(record.votes.toString()),
        onLongPress: () async {
          String model = record.name;
          bool result = await showDialog(
            context: context,
            builder : (context) => new AlertDialog(
              title: new Text('Attention'),
              content: new Text("Do you want deleted '$model'?"),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () async {
                    Firestore.instance.collection(collectionsName)
                      .document(record.reference.documentID)
                      .delete()
                      .then((_) => Navigator.of(context).pop(true))
                      .catchError((_) => Navigator.of(context).pop(false));
                    ;
                  },
                  child: new Text('Yes'),
                ),
              ],
            ),
          ) ?? false;
          if (result)
          {
            _scaffoldKey.currentState
              .showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[300],
                  content: Text("Delete `$model`"),
                  duration: Duration(seconds: 3)
                )
              );
          }
        },
        onTap: () => Firestore.instance.runTransaction((transaction) async {
          final freshSnapshot = await transaction.get(record.reference);
          final fresh = Record.fromSnapshot(freshSnapshot);

          await transaction
              .update(record.reference, {'votes': fresh.votes + 1});
        }),
      ),
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey)
      ),
    );
  }

  Future<void> _addCarModel(String model) async {
    await Firestore.instance
        .collection(collectionsName)
        .add({"name": model, "votes": 0});
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: new Text("FirebaseStore Cloud"),),
      body: new Container(
        child: Column(children: <Widget> [
          Flexible(
            child: _buildBody(context),
          ),
          Align(
            child: new Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: new Row(
                children: <Widget>[
                  new Flexible(
                    child: new TextField(
                      controller: eCtrl,
                      onSubmitted: (text) async {
                        if (text != null && text.isNotEmpty) {
                          await _addCarModel(text);
                          eCtrl.clear();
                        }
                      },
                      decoration: new InputDecoration.collapsed(hintText: "Enter car model ..."),
                    ),
                  ),
                  new Container(
                    child: new IconButton(
                      icon: new Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () async {
                        if (eCtrl.text != null && eCtrl.text.isNotEmpty) {
                          await _addCarModel(eCtrl.text);
                          eCtrl.clear();
                        }
                      }),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
            ),
            alignment: Alignment.bottomCenter,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
        ),
      )
    );
  }
}