import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/stock_item.dart';

class AddStockItemController {
  late Database db;

  AddStockItemController() {
    _initDB();
  }
  Future _initDB() async {
    db = await StockDB.db.database;
  }

  // insert data
  Future<int> insertStockItem(StockItem stockItem) async {
    // final result = await db.insert(
    //   'stock_item',
    //   stockItem.toMap(),
    // );

    final result = await db.rawInsert(
        'INSERT INTO stock_item(name, description, price,category,image,status) VALUES("${stockItem.name}","${stockItem.description}", ${stockItem.price}, "${stockItem.category}","${stockItem.image}",0)');
    return result;
  }
}
