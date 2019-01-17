import 'package:flutter/material.dart';
import 'package:flutter_app/models/stock.dart';

class StockViewList extends StatefulWidget
{
  StockViewList({Key key, this.stocks}) : super(key: key);

  final List<Stock> stocks;

  @override
  StockViewListState createState() => new StockViewListState();
}

class StockViewListState extends State<StockViewList>
{
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(

        itemCount: widget.stocks.length,
        itemBuilder: (context, index) {
          Stock stock = widget.stocks[index];
          return new ListTile(title: new Text(stock.name), subtitle: new Text('${stock.cost ?? "Cost not found"} , Last update: ${stock.lastUpdateDateTime}'));
        }
    );
  }
}

