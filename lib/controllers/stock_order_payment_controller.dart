import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/stock_order_payment.dart';

class StockOrderPaymentController {
  late Database db;

  Future<List<StockOrderPayment>> getStockPaymentList(String parentId) async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query(
      'pos007',
      where: "parentId = ?",
      whereArgs: [parentId],
    );
    return queryResult.map((e) => StockOrderPayment.fromMap(e)).toList();
  }

  // insert data
  Future<int> insertPosPayment(StockOrderPayment orderPayment) async {
    db = await StockDB.db.database;
    final result = await db.insert(
      'pos007',
      orderPayment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.update(
      'pos001',
      {'status': 128},
      where: "syskey = ?",
      whereArgs: [orderPayment.parentId],
    );
    return result;
  }
}
