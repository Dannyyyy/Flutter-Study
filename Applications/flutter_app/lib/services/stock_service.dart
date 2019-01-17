import 'package:http/http.dart' as http;
import 'dart:async';

class StockService
{
  Future<double> getStockCost(String name) async
  {
    String url = "https://api.iextrading.com/1.0/stock/$name/price";

    http.Response response = await http.get(url);
    double price = double.tryParse(response.body);
    return price;
  }
}