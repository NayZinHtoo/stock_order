import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/stock_order_payment.dart';

class StockOrderPaymentController {
  late Database db;

  // insert data
  Future<int> insertPosPayment(StockOrderPayment orderPayment) async {
    db = await StockDB.db.database;
    final result = await db.insert(
      'pos007',
      orderPayment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('pos007 table $result #########');

    await db.update(
      'pos001',
      {'status': 128},
      where: "syskey = ?",
      whereArgs: [orderPayment.parentId],
    );
    return result;
  }
}
