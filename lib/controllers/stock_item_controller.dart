import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/stock_item.dart';

class StockItemListController {
  late Database db;

  // retrieve data count
  Future<int> retrieveStockItemCount() async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query('stock_item');
    return queryResult.map((e) => StockItem.fromJson(e)).toList().length;
  }

  // retrieve data
  Future<List<StockItem>> retrieveStockItem() async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query(
      'stock_item',
      where: 'status = ? ',
      whereArgs: [0],
    );
    return queryResult.map((e) => StockItem.fromJson(e)).toList();
  }

  // retrieve data by category
  Future<List<StockItem>> retrieveStockItemByCategory(String ctegory) async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query(
      'stock_item',
      where: 'category = ? and status = ?',
      whereArgs: [ctegory, 0],
    );
    return queryResult.map((e) => StockItem.fromJson(e)).toList();
  }

  //update data
  Future<void> updateStockItem(StockItem stockItem) async {
    db = await StockDB.db.database;
    await db.update(
      'stock_item',
      stockItem.toJson(),
      where: 'id = ?',
      whereArgs: [stockItem.id],
    );
  }

  // update delete status
  Future<void> updateStockItemStatus(int id) async {
    db = await StockDB.db.database;
    await db.update(
      'stock_item',
      {'status': 1},
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
