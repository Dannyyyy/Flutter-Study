import 'package:flutter/material.dart';
import 'package:flutter_app/view_lists/stock_view_list.dart';
import 'package:flutter_app/models/stock.dart';
import 'package:flutter_app/services/stock_service.dart';

class StockPage extends StatefulWidget
{
  @override
  StockPageState createState() => new StockPageState();
}

class StockPageState extends State<StockPage>
{
  String _stockName;
  List<Stock> _stocks = new List<Stock>();
  StockService _service = new StockService();

  Future<void> _refreshStocks() async
  {
    _stocks.forEach((s) async {
        double cost = await _service.getStockCost(s.name);
        setState(() {
          s.cost = cost;
          s.lastUpdateDateTime = DateTime.now();
        });
    });
  }
  
  Future<void> _inputStock() async
  {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Add stock"),
          content: new TextField(
            onChanged: (String value) {
              _stockName = value;
            },
          ),
          actions: <Widget>[
            new FlatButton(onPressed: () async {
                  if(_stockName.isNotEmpty)
                  {
                    double cost = await _service.getStockCost(_stockName);
                    setState(() {
                      _stocks.add(new Stock(_stockName, cost, new DateTime.now()));
                    });
                  }
                  _stockName = "";
                  Navigator.pop(context);
                },
                child: new Text("Ok")
            ),
            new FlatButton(
                onPressed: () => Navigator.pop(context),
                child: new Text("Cancel")
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Stocks"),
        backgroundColor: Colors.deepOrange[200],
      ),
      body: new Container(
        child: new Center(
          child: RefreshIndicator(
            child: new StockViewList(stocks: _stocks),
            onRefresh: _refreshStocks,
          )
        )
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _inputStock,
        child: new Icon(Icons.add)
      ),
    );
  }
}