import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/stock_item.dart';

class StockItemListController {
  late Database db;

  // retrieve data count
  Future<int> retrieveStockItemCount() async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query('stock_item');
    return queryResult.map((e) => StockItem.fromMap(e)).toList().length;
  }

  // retrieve data
  Future<List<StockItem>> retrieveStockItem() async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query(
      'stock_item',
      where: 'status = ? ',
      whereArgs: [0],
    );
    return queryResult.map((e) => StockItem.fromMap(e)).toList();
  }

  // retrieve data by category
  Future<List<StockItem>> retrieveStockItemByCategory(String ctegory) async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query(
      'stock_item',
      where: 'category = ? and status = ?',
      whereArgs: [ctegory, 0],
    );
    return queryResult.map((e) => StockItem.fromMap(e)).toList();
  }
}
