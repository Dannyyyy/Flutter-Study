import 'package:flutter/material.dart';
import 'package:flutter_app/db/db_service.dart';
import 'package:flutter_app/models/city.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:async';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_app/redux/actions/cloud_message_actions.dart';
import 'package:flutter_app/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/redux/models/cloud_message.dart';

class DynamicListView extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  DynamicListView(this._scaffoldKey);

  @override
  createState() => new _DynamicListViewState();
}

class _DynamicListViewState extends State<DynamicListView> with SingleTickerProviderStateMixin {

  final TextEditingController eCtrl = new TextEditingController();
  final DBService _service = new DBService();

  Future<List<City>> _getCities() async {
    return await _service.getCities();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[ new Flexible(
          child: FutureBuilder<List<City>>(
            future: _getCities(),
            builder: (BuildContext context, AsyncSnapshot<List<City>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return new Slidable(
                      delegate: new SlidableDrawerDelegate(),
                      actionExtentRatio: 0.25,
                      child: new Column(
                        children: <Widget>[
                          new Row(children: <Widget>[
                            new Expanded(
                              child: new ListTile(
                                title: new Text('City: ${snapshot.data[index].name}'),
                                subtitle: new Row(
                                  children: <Widget>[
                                    new Text('Likes: ${snapshot.data[index].likeCount}'),
                                    new SizedBox(width: 20),
                                    new Text('Dislikes: ${snapshot.data[index].dislikeCount}')
                                  ],
                                ),
                              ),
                              flex: 3,
                            ),
                            new Expanded(
                              child: new RawMaterialButton(
                                onPressed: () async {
                                  await _service.updateCity(snapshot.data[index]..likeCount += 1);
                                  setState(() {});
                                },
                                shape: new CircleBorder(),
                                elevation: 2.0,
                                fillColor: Colors.orange[100],
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.exposure_plus_1,
                                  color: Colors.green[300]
                                )
                              ),
                              flex: 1
                            ),
                            new Expanded(
                              child: new RawMaterialButton(
                                onPressed: () async {
                                  await _service.updateCity(snapshot.data[index]..dislikeCount += 1);
                                  setState(() {});
                                },
                                shape: new CircleBorder(),
                                elevation: 2.0,
                                fillColor: Colors.orange[100],
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.exposure_neg_1,
                                  color: Colors.red[300])
                              ),
                              flex: 1
                            ),
                          ]),
                          new Divider(height: 5)
                        ]
                      ),
                      secondaryActions: <Widget>[
                        new IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete_forever,
                          onTap: () async {
                            String name = snapshot.data[index].name;
                            await _service.deleteCity(snapshot.data[index]);
                            setState(() { });
                            widget._scaffoldKey.currentState.showSnackBar(
                              new SnackBar(
                                backgroundColor: Colors.red[300],
                                content: new Text('Deleted city: ${name}'),
                                duration: Duration(seconds: 2),
                              )
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              else if (snapshot.data == null) {
                return new Center(child: new Text("No Data found"));
              }
              return new Container(
                alignment: AlignmentDirectional.center,
                child: new CircularProgressIndicator()
              );
            }
          ),
        ),
        Divider(),
        new Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: eCtrl,
                  onSubmitted: (text) async {
                    if (text != null && text.isNotEmpty) {
                      String inputText = text;
                      eCtrl.clear();
                      await _service.saveCity(new City(inputText, 0, 0));
                    }
                  },
                  decoration: new InputDecoration.collapsed(hintText: "Enter city name ..."),
                ),
              ),
              new Container(
                child: new IconButton(
                  icon: new Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () async {
                    if (eCtrl.text != null && eCtrl.text.isNotEmpty) {
                      String inputText = eCtrl.text;
                      eCtrl.clear();
                      await _service.saveCity(new City(inputText, 0, 0));
                    }
                  }
                ),
              ),
            ],
          ),
        ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      )
    );
  }
}

class FirstTab extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  FirstTab(this._scaffoldKey);

  List<Widget> _buildForm(BuildContext context, FirstTabStore store) {
    var widgets = new List<Widget>();

    widgets.add(DynamicListView(this._scaffoldKey));

    if (store.notification?.isCloudMessage ?? false) {
      var notification = store.notification;
      var modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false, color: Colors.grey),
          ),
        AlertDialog(
          title: new Text(notification.title.isNotEmpty ? notification.title : "Without title"),
          content: Text(notification.text.isNotEmpty ? notification.text : "Without text"),
          actions: <Widget>[
            RaisedButton(
              child: Text("Close", style: TextStyle(color: Colors.black54),),
              color: Colors.grey[300],
              elevation: 4.0,
              splashColor: Colors.blueGrey,
              onPressed: () {store.onMessageShowCallback();}
            )
          ],
        ),
        ]
      );

      widgets.add(modal);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, FirstTabStore>(
      converter: FirstTabStore.fromStore,
      builder: (BuildContext context, FirstTabStore model) {
        return new Stack(
          children: _buildForm(context, model),
        );
      }
    );
  }
}

class FirstTabStore {
  final Function onMessageShowCallback;
  final CloudMessage notification;

  FirstTabStore({this.notification, this.onMessageShowCallback});

  static FirstTabStore fromStore(Store<AppState> store) {
    return new FirstTabStore(
      onMessageShowCallback: () {
        store.dispatch(CloudMessageShowSuccessful(new CloudMessage()));
      },
      notification: store.state.notification
    );
  }
}