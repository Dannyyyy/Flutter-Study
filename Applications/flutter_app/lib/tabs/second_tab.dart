import 'package:flutter/material.dart';
import 'package:flutter_app/models/contact.dart';
import 'package:flutter_app/db/db_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddContactTab extends StatefulWidget
{
  @override
  AddContactTabState createState() => new AddContactTabState();
}

class AddContactTabState extends State<AddContactTab>
{
  DBService _service;

  Future<List<Contact>> _getContacts() async
  {
    return await _service.getContacts();
  }

  @override
  initState()
  {
    _service = new DBService();
    super.initState();
  }

  Color _getColor(String color)
  {
    switch(color)
    {
      case 'green': return Colors.green[100];
      case 'red': return Colors.red[100];
      case 'blue': return Colors.blue[100];
      case 'orange': return Colors.orange[100];
      default: return Colors.blueGrey[100];
    }
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: new Center(
        child: FutureBuilder<List<Contact>>(
          future: _getContacts(),
          builder: (BuildContext context,AsyncSnapshot<List<Contact>> snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return new Slidable(
                    delegate: new SlidableDrawerDelegate(),
                    actionExtentRatio: 0.25,
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: _getColor(snapshot.data[index].favoriteColor)
                      ),
                      child: new Column(
                        children: <Widget>[
                          new ListTile(
                            leading: SizedBox(
                            child: new RawMaterialButton(
                            onPressed: () =>
                              launch('tel://${snapshot.data[index].phone}'),
                              shape: new CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.orange[100],
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.phone,
                              color: Colors.blue[300])
                            ),
                            width: 50.0,
                            height: 50.0,
                          ),
                          title: new Text(snapshot.data[index].name,
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0)),
                              subtitle: new Row(
                                children: <Widget>[
                                  new Text('Email: ${snapshot.data[index].email}',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0)),
                                      new SizedBox(width: 20),
                                      new Text('Phone:  ${snapshot.data[index].phone}',
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0)),
                                ]
                              ),
                            ),
                            new Divider(height: 3)
                          ]
                        )
                      ),
                      actions: <Widget>[
                        new IconSlideAction(
                          caption: 'Copy',
                          color: Colors.blue,
                          icon: Icons.filter_none,
                          onTap: () async {
                            await _service.saveContact(snapshot.data[index]..name += '-Copy');
                                  setState(() {});
                          },
                        ),
                      ],
                      secondaryActions: <Widget>[
                        new IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete_forever,
                          onTap: () async {
                            await _service.deleteContact(snapshot.data[index].id);
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  }
                );
              }
              else if (snapshot.hasError) {
                return new Text("No Data found");
              }
              return new Container(
                alignment: AlignmentDirectional.center,
                child: new CircularProgressIndicator()
              );
            }
          )
      )
    );
  }
}

class SecondTab extends StatelessWidget {

  void navAddContact(BuildContext context) {
    Navigator.of(context).pushNamed('/contact');
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(child: AddContactTab()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navAddContact(context),
        child: new Icon(Icons.person_add),
      ),
    );
  }
}