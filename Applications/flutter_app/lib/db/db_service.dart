import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/models/contact.dart';
import 'package:flutter_app/models/city.dart';

class DBService
{
  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test2.db");
    var theDb = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);

    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Contact(id INTEGER PRIMARY KEY, name TEXT, email TEXT, phone TEXT, favoriteColor TEXT, dob TEXT)");

    print("Created tables");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute(
        "CREATE TABLE City(id INTEGER PRIMARY KEY, name TEXT, likeCount INTEGER, dislikeCount INTEGER)");
    print("Upgrade tables");
  }

  Future<List<Contact>> getContacts() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Contact');
    List<Contact> contacts = new List();
    for (int i = 0; i < list.length; i++) {
      contacts.add(new Contact(list[i]["name"], list[i]["email"], list[i]["phone"], list[i]["favoriteColor"], new DateTime.now()/*new DateFormat.yMd().parseStrict(list[i]["dob"])*/));
    }
    return contacts;
  }

  Future<List<City>> getCities() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM City');
    List<City> cities = new List();
    list.forEach((l) => cities.add(new City(l["name"], l["likeCount"], l["dislikeCount"])..id=l["id"]));

    return cities;
  }

  void saveCity(City city) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
        'INSERT INTO City(name, likeCount, dislikeCount) VALUES(' +
          '\'' +
          city.name +
          '\',\'' +
          city.likeCount.toString() +
          '\',\'' +
          city.dislikeCount.toString() +
          '\'' +
          ')'
      );
    });
  }

  void updateCity(City city)  async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'UPDATE City SET likeCount = \'' + city.likeCount.toString() + '\', dislikeCount = \'' + city.dislikeCount.toString()
              +  '\' WHERE id = ' + '\'' + city.id.toString() + '\''
      );
    });
  }

  void deleteCity(City city)  async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'DELETE FROM City WHERE id = ' + '\'' + city.id.toString() + '\''
      );
    });
  }

  void saveContact(Contact contact) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
        'INSERT INTO Contact(name, email, phone, favoriteColor, dob) VALUES(' +
          '\'' +
          contact.name +
          '\',\'' +
          contact.email +
          '\',\'' +
          contact.phone +
          '\',\'' +
          contact.favoriteColor +
          '\',\'' +
          contact.dob.toString() +
          '\'' +
          ')'
        );
    });
  }
}