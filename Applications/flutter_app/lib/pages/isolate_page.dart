import 'package:flutter/material.dart';
import 'dart:async';
import 'package:english_words/english_words.dart';
import 'dart:math';

class IsolatePageListView extends StatefulWidget {
  IsolatePageListView({Key key, this.tiles, this.scrollController}) : super(key: key);

  final ScrollController scrollController;
  final List<String> tiles;

  @override
  IsolatePageListViewState createState() => IsolatePageListViewState();
}

class IsolatePageListViewState extends State<IsolatePageListView> {

  final Random random = new Random(DateTime.now().millisecond);
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Center(
            child: new ListView.builder(
              controller: widget.scrollController,
              itemCount: widget.tiles.length,
              itemBuilder: (context, index) {
                return new Container(child:
                      new Column(children: <Widget>[
                      new ListTile(title: new Text(widget.tiles[index])),
                      new Divider(height: 5)
                    ]
                  ),
                  decoration: BoxDecoration(color: Color.fromARGB(random.nextInt(200), random.nextInt(200), random.nextInt(200), random.nextInt(200))),
                );
              }
            )
        ),
      ),
    );
  }
}

class IsolatePage extends StatefulWidget {

  List<String> tiles = new List<String>();

  @override
  IsolatePageState createState() => IsolatePageState();
}

class IsolatePageState extends State<IsolatePage> {

  ScrollController _scrollController = new ScrollController();
  Timer _timer;
  bool _scroll = false;

  void runTimer() {
    _timer = Timer.periodic(new Duration(seconds: 1), (Timer t) {
     setState(() {
       widget.tiles.add(WordPair.random().toString());
     });
     if(_scroll)
     {
       _scrollController.animateTo(
         _scrollController.position.maxScrollExtent,
         curve: Curves.easeOut,
         duration: const Duration(milliseconds: 500),
       );
     }
    });
  }

  @override
  void initState() {
    super.initState();
    runTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Isolate page"),
        backgroundColor: Colors.blueAccent,
      ),
      body: new IsolatePageListView(tiles: widget.tiles, scrollController: _scrollController,),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _scroll = !_scroll;
            });
          },
        child: Icon(!_scroll ? Icons.visibility_off : Icons.visibility),
      ),
    );
  }
}