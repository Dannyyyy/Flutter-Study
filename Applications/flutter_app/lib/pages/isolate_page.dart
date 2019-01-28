import 'package:flutter/material.dart';
import 'dart:async';
import 'package:english_words/english_words.dart';
import 'dart:math';

class IsolatePageListView extends StatefulWidget {
  IsolatePageListView({Key key, this.tiles, this.scrollController}) : super(key: key);

  final ScrollController scrollController;
  final List<IsolateTile> tiles;

  @override
  createState() => _IsolatePageListViewState();
}

class _IsolatePageListViewState extends State<IsolatePageListView> {

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
                    new ListTile(title: new Text(widget.tiles[index].word)),
                    new Divider(height: 5)
                  ]
                ),
                decoration: BoxDecoration(color: widget.tiles[index].color),
              );
            }
          )
        ),
      ),
    );
  }
}

class IsolatePage extends StatefulWidget {
  @override
  IsolatePageState createState() => IsolatePageState();
}

class IsolatePageState extends State<IsolatePage> {
  final List<IsolateTile> tiles = new List<IsolateTile>();
  final ScrollController _scrollController = new ScrollController();
  final Random random = new Random(DateTime.now().millisecond);
  Timer _timer;
  bool _scroll = false;

  void runTimer() {
    String word;
    Color color;

    _timer = Timer.periodic(new Duration(seconds: 1), (Timer t) {
      word = WordPair.random().toString();
      color = Color.fromARGB(random.nextInt(200), random.nextInt(200), random.nextInt(200), random.nextInt(200));
      setState(() {
        tiles.add(new IsolateTile(word, color));
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
        title: new Text("Dynamic Tiles"),
        backgroundColor: Colors.blueAccent,
      ),
      body: new IsolatePageListView(tiles: tiles, scrollController: _scrollController,),
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

class IsolateTile {
  Color color;
  String word;

  IsolateTile(this.word, this.color);
}