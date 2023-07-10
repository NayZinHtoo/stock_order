import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/stock_detail.dart';
import '../models/stock_header.dart';

class StockOrderListViewController {
  late Database db;

  // retrieve header data
  Future<List<StockHeader>> getStockHeaderList() async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query(
      'pos001',
      orderBy: 'id DESC',
      //where: 'status = ?',
      //whereArgs: [1],
    );
    return queryResult.map((e) => StockHeader.fromMap(e)).toList();
  }

  Future<List<StockHeader>> filterStockHeaderList(int status) async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query(
      'pos001',
      orderBy: 'id DESC',
      where: 'status = ?',
      whereArgs: [status],
    );
    return queryResult.map((e) => StockHeader.fromMap(e)).toList();
  }

  // retrieve one header data
  Future<StockHeader> getStockHeader(String syskey) async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query(
      'pos001',
      where: 'syskey = ?',
      whereArgs: [syskey],
    );
    return queryResult.map((e) => StockHeader.fromMap(e)).toList().first;
  }

  // retrieve stock detail data
  Future<List<StockDetail>> getStockDetailList(String pid) async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query(
      'pos002',
      where: 'parentId = ? and status = ?',
      whereArgs: [pid, 0],
    );
    return queryResult.map((e) => StockDetail.fromMap(e)).toList();
  }

  Future<void> updateStockHeaderStatus(int id, int status) async {
    db = await StockDB.db.database;
    await db.update(
      'pos001',
      {'status': status},
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
