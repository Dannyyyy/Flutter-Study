import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter_app/models/contact.dart';
import 'package:flutter_app/db/db_service.dart';

class ContactService {
  static const _serviceUrl = 'http://mockbin.org/echo';
  static final _headers = {'Content-Type': 'application/json'};

  Future<Contact> createContact(Contact contact) async {
    try {
      String json = _toJson(contact);
      final response = await http.post(_serviceUrl, headers: _headers, body: json);
      var c = _fromJson(response.body);

      DBService service = new DBService();
      await service.saveContact(contact);

      return c;
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      return null;
    }
  }

  Contact _fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    var contact = new Contact(map['name'],map['email'], map['phone'], map['favoriteColor'], new DateFormat.yMd().parseStrict(map['dob']));
    return contact;
  }

  String _toJson(Contact contact) {
    var mapData = new Map();
    mapData["name"] = contact.name;
    mapData["dob"] = new DateFormat.yMd().format(contact.dob);
    mapData["phone"] = contact.phone;
    mapData["email"] = contact.email;
    mapData["favoriteColor"] = contact.favoriteColor;
    String json = jsonEncode(mapData);
    return json;
  }
}