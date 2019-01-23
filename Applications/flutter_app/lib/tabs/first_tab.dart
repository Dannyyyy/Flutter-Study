import 'package:flutter/material.dart';
import 'package:flutter_app/db/db_service.dart';
import 'package:flutter_app/models/city.dart';

class DynamicListView extends StatefulWidget {
  @override
  createState() => new DynamicListViewState();
}

class DynamicListViewState extends State<DynamicListView> {
  final TextEditingController eCtrl = new TextEditingController();

  DBService _service;

  Future<List<City>> _getCities() async
  {
    return await _service.getCities();
  }

  @override
  void initState() {
    _service = new DBService();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
       leading: new Icon(Icons.edit, color: Colors.black,),
       backgroundColor: Colors.white,
       title: new TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15),
            hintText: "Enter city name ..."
          ),
          controller: eCtrl,
          onSubmitted: (text) async {
            if (text != null && text.isNotEmpty) {
              await _service.saveCity(new City(text, 0, 0));
              eCtrl.clear();
            }
          }
        )
      ),
      body: new Center(
        child: FutureBuilder<List<City>>(
          future: _getCities(),
          builder: (BuildContext context, AsyncSnapshot<List<City>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return new Dismissible(
                    key: Key(snapshot.data[index].id.toString()),
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
                          //)
                        ]),
                        new Divider(height: 5)
                      ]
                    ),
                    onDismissed: (direction) async
                    {
                      await _service.deleteCity(snapshot.data[index]);
                    },
                    background: Container(color: Colors.red[300]),
                  );
                },
                scrollDirection: Axis.vertical
              );
            }
            else if (snapshot.data == null) {
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

class FirstTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: DynamicListView(),
    );
  }
}