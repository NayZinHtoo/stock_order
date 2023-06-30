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
    await db.execute('CREATE TABLE IF NOT EXISTS stock_header('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'slipNumber INT(11),'
        'amount DOUBLE,'
        'date TEXT,'
        'time TEXT,'
        'status INTEGER DEFAULT 0'
        ')');
    await db.execute('CREATE TABLE IF NOT EXISTS stock_detail('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'parentId INT,'
        'stkId INT,'
        'stkName TEXT,'
        'qty INT,'
        'stkprice DOUBLE,'
        'amount DOUBLE,'
        'status INTEGER DEFAULT 0'
        ')');

    await db.rawInsert(
        'INSERT INTO stock_item(name, description, price,category,image,status) VALUES("Lemon","Lemon Desc", 1500.0, "Drink","assets/lemon.jpeg",0)');
    await db.rawInsert(
        'INSERT INTO stock_item(name, description, price,category,image,status) VALUES("Rice","Rice Desc", 2500.0, "Food","assets/rice.jpg",0)');
    await db.rawInsert(
        'INSERT INTO stock_item(name, description, price,category,image,status) VALUES("Strawberry","Strawberry Desc", 2000.0, "Drink","assets/strawberry.jpg",0)');
    await db.rawInsert(
        'INSERT INTO stock_item(name, description, price,category,image,status) VALUES("Noodle","Noodle Desc", 3000.0, "Food","assets/noodle.jpeg",0)');
  }
}
