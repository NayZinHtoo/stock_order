import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/stock_detail.dart';
import '../models/stock_header.dart';

class StockOrderController {
  late Database db;

  Future<int> insertStockHeader(StockHeader stockHeader) async {
    db = await StockDB.db.database;
    final res = await db.insert('pos001', stockHeader.toMap());
    return res;
  }

  insertStockDetail(StockDetail stockDetail) async {
    db = await StockDB.db.database;
    final res = await db.insert('pos002', stockDetail.toMap());
    return res;
  }

  Future<List<StockHeader>> readMaxSlipNoforHeader() async {
    db = await StockDB.db.database;
    // final List<Map<String, Object?>> queryResult1 = await db
    //     .rawQuery('SELECT MAX(slipNumber) AS slipNumber FROM pos001');
    final List<Map<String, Object?>> queryResult = await db
        .rawQuery('SELECT * FROM pos001 ORDER BY slipNumber desc limit 1');
    return queryResult.map((e) => StockHeader.fromMap(e)).toList();
  }

  Future<int> getHeaderLength() async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM pos001');
    return queryResult.map((e) => StockHeader.fromMap(e)).toList().length;
  }

  Future<List<StockDetail>> getStockOrderDetilList(String syskey) async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query(
      'pos002',
      where: 'parentId = ? ',
      whereArgs: [syskey],
    );
    return queryResult.map((e) => StockDetail.fromMap(e)).toList();
  }
}
