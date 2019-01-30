import 'package:flutter/material.dart';
import 'package:flutter_app/models/stock.dart';

class StockViewList extends StatefulWidget {
  StockViewList({Key key, this.stocks}) : super(key: key);

  final List<Stock> stocks;

  @override
  createState() => new _StockViewListState();
}

class _StockViewListState extends State<StockViewList> {
  _removeStock(Stock stock) {
    setState(() {
      this.widget.stocks.remove(stock);
    });

    Scaffold.of(context).removeCurrentSnackBar();

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: new Text('Removed ${stock.name}!'),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.red[300],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: widget.stocks.length,
      itemBuilder: (context, index) {
        Stock stock = widget.stocks[index];

        return Dismissible(
          key: Key(stock.name),
          background: Container(color: Colors.blue),
          onDismissed: (direction) {
            _removeStock(stock);
          },
          child: new ListTile(title: new Text(stock.name), subtitle: new Text('${stock.cost ?? "Cost not found"} , last update: ${stock.lastUpdateDateTime}'))
        );
      }
    );
  }
}

