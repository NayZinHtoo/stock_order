import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class StockDB with ChangeNotifier {
  static Database? _database;
  static final StockDB db = StockDB._();
  StockDB._();

  Future<Database> get database async {
    // If database exists, return database
    // If database don't exists, create one
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = p.join(documentsDirectory.path, 'stock_pos.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
      onUpgrade: _updateTable,
    );
    return db;
  }

  Future _updateTable(Database db, int oldVersion, int newVersion) async {
    /// alter table or field in update db version
  }

  Future _createTable(Database db, int version) async {
    await db.execute('CREATE TABLE IF NOT EXISTS stock_item('
        'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
        'name TEXT NOT NULL,'
        'description TEXT NOT NULL,'
        'price DOUBLE,'
        'category TEXT NOT NULL,'
        'image TEXT NOT NULL,'
        'status INTEGER DEFAULT 0'
        ')');
    await db.execute('CREATE TABLE IF NOT EXISTS pos001('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'syskey TEXT,'
        'slipNumber INT(11),'
        'amount DOUBLE,'
        'date TEXT,'
        'time TEXT,'
        'status INTEGER DEFAULT 0'
        ')');
    await db.execute('CREATE TABLE IF NOT EXISTS pos002('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'syskey TEXT,'
        'parentId TEXT,'
        'stkId INT,'
        'stkName TEXT,'
        'qty INT,'
        'stkprice DOUBLE,'
        'amount DOUBLE,'
        'status INTEGER DEFAULT 0'
        ')');

    await db.rawInsert(
        'INSERT INTO stock_item(name, description, price,category,image,status) VALUES("Lemon","Lemons include many vitamins and nutrients that can provide a boost to your body: Vitamin C: Lemons are a good source of Vitamin C, which promotes immunity, battles infection, heals wounds, and more.", 1500.0, "Drink","assets/lemon.jpeg",0)');
    await db.rawInsert(
        'INSERT INTO stock_item(name, description, price,category,image,status) VALUES("Rice","Rice is a rich source of carbohydrates, the body\'s main fuel source. Carbohydrates can keep you energized and satisfied, and are important for fueling exercise. Brown rice, especially, is an excellent source of many nutrients, including fiber, manganese, selenium, magnesium, and B vitamins.", 2500.0, "Food","assets/rice.jpg",0)');
    await db.rawInsert(
        'INSERT INTO stock_item(name, description, price,category,image,status) VALUES("Strawberry","Strawberry Juice is rich in antioxidants, such as flavonoids and polyphenols, which can help to reduce inflammation and promote healthy blood flow.", 2000.0, "Drink","assets/strawberry.jpg",0)');
    await db.rawInsert(
        'INSERT INTO stock_item(name, description, price,category,image,status) VALUES("Noodle","A vast majority of instant noodles are low in calories, but are also low in fibre and protein. They are also notorious for being high in fat, carbohydrates, and sodium. While you will be able to get some micronutrients from instant noodles, they lack important nutrients like vitamin A, vitamin C, vitamin B12, and more.", 3000.0, "Food","assets/noodle.jpeg",0)');
  }
}
