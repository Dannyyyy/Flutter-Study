import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'package:english_words/english_words.dart';

class IsolateWorker {

  Isolate isolate;

  List<String> tiles = new List<String>();

  Future<void> start() async {
    ReceivePort receivePort = ReceivePort();
    isolate = await Isolate.spawn(runTimer, receivePort.sendPort);
    receivePort.listen((data) {
      print('RECEIVE: $data');
    });
  }

  String getTile() {
    if(tiles.length > 0)
      return tiles.last;

    return "None";
  }

  void runTimer(SendPort sendPort) {
    int counter = 0;
    Timer.periodic(new Duration(seconds: 3), (Timer t) {
      var wordPair = WordPair.random();
      wordPair.toString();
      tiles.add(wordPair.toString());
      counter++;
      String msg = 'notification' + counter.toString();
      print(msg);
      sendPort.send(msg);
    });
  }

  void stop() {
    if (isolate != null) {
      isolate.kill(priority: Isolate.immediate);
      isolate = null;
      print('Isolate killed!');
    }
  }

  void main() async {
    print('isolate start');
    await start();
    print('press enter key to exit ...');
    await stdin.first;
    stop();
    print('Good Bye');
    exit(0);
  }
}