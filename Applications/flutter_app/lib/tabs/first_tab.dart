import 'package:flutter/material.dart';

class DynamicListView extends StatefulWidget {
  @override
  createState() => new DynamicListViewState();
}

class DynamicListViewState extends State<DynamicListView> {
  List<String> _items = [];
  final TextEditingController eCtrl = new TextEditingController();

  @override
  void initState() {
    _items.addAll(['Brn', 'SPb', 'Msk', 'Nsk']);
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
        body: new Column(
          children: <Widget>[
            new TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    hintText: "Enter text"
                ),
                controller: eCtrl,
                onSubmitted: (text) {
                  if (text != null && text.isNotEmpty) {
                    _items.add(text);
                    eCtrl.clear();
                    setState(() {});
                  }
                }
            ),
            new SizedBox(height: 10),
            new Expanded(
                child: new ListView.builder
                  (
                    itemCount: _items.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new ListTile(title: new Text(_items[index]));
                    }
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
      body: new Center(child: DynamicListView()),
    );
  }
}