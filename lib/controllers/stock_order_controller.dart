import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/stock_detail.dart';
import '../models/stock_header.dart';

class StockOrderController {
  late Database db;

  Future<int> insertStockHeader(StockHeader stockHeader) async {
    db = await StockDB.db.database;
    final res = await db.insert('stock_header', stockHeader.toMap());
    return res;
  }

  insertStockDetail(StockDetail stockDetail) async {
    db = await StockDB.db.database;
    final res = await db.insert('stock_detail', stockDetail.toMap());
    return res;
  }

  // Future<List<StockHeader>> readMaxSlipNoforHeader() async {
  //   db = await StockDB.db.database;
  //   final List<Map<String, Object?>> queryResult = await db
  //       .rawQuery('SELECT MAX(slipNumber) AS slipNumber FROM stock_header');
  //   return queryResult.map((e) => StockHeader.fromMap(e)).toList();
  // }

  Future<int> getHeaderLength() async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('SELECT * FROM stock_header');
    return queryResult.map((e) => StockHeader.fromMap(e)).toList().length;
  }
}
