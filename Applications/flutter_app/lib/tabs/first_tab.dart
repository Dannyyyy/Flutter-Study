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
        body: new Column(
          children: <Widget>[
            new SizedBox(
              child: new TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      hintText: "Enter text"
                  ),
                  controller: eCtrl,
                  onSubmitted: (text) async {
                    if (text != null && text.isNotEmpty) {
                      await _service.saveCity(new City(text, 0,0));
                      eCtrl.clear();
                    }
                  }
              ),
              height: 50,
            ),
            /*
            new TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    hintText: "Enter text"
                ),
                controller: eCtrl,
                onSubmitted: (text) async {
                  if (text != null && text.isNotEmpty) {
                    await _service.saveCity(new City(text, 0,0));
                    eCtrl.clear();
                  }
                }
            ),
            */
            new SizedBox(height: 400, child:
            new Center(
                child: FutureBuilder<List<City>>(
                  future: _getCities(),
                  builder: (BuildContext context, AsyncSnapshot<List<City>> snapshot)
                  {
                    print(snapshot);
                    if(snapshot.hasData)
                    {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index)
                          {
                            return new ListTile(
                              title: new Text(snapshot.data[index].name),
                              subtitle: new Row(
                                children: <Widget>[
                                  new Text('Likes: ${snapshot.data[index].likeCount}'),
                                  new SizedBox(width: 20),
                                  new Text('Dislikes: ${snapshot.data[index].dislikeCount}')
                                ],
                              ),
                            );
                          }
                      );
                    }
                    else if (snapshot.data == null)
                    {
                      return new Text("No Data found");
                    }
                    return new Container(alignment: AlignmentDirectional.center,child: new CircularProgressIndicator(),);
                  }
                )
              )
            )
          ],
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