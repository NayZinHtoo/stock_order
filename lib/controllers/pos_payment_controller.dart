import 'package:sqflite/sqflite.dart';
import 'package:stock_pos/models/pos_payment.dart';

import '../database/db.dart';

class PosPaymentController {
  late Database db;

  // insert data
  Future<int> insertPosPayment(PosPayment posPayment) async {
    db = await StockDB.db.database;
    final result = await db.insert('pos_payment', posPayment.toMap());
    return result;
  }

  // retrieve data
  Future<List<PosPayment>> retrievePosPayment() async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query(
      'pos_payment',
      where: 'status = ? ',
      whereArgs: [0],
      orderBy: 'dftPayment DESC',
    );
    return queryResult.map((e) => PosPayment.fromMap(e)).toList();
  }

  // update delete status
  Future<void> updatePosPaymentStatus(int id) async {
    db = await StockDB.db.database;
    await db.update(
      'pos_payment',
      {'status': 1},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // update Default status
  Future<void> updateDefaultPosPayment(int id) async {
    db = await StockDB.db.database;
    await db.update(
      'pos_payment',
      {'dftPayment': 0},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //update data
  Future<void> updatePosPayment(PosPayment posPayment) async {
    db = await StockDB.db.database;
    await db.update(
      'pos_payment',
      posPayment.toMap(),
      where: 'id = ?',
      whereArgs: [posPayment.id],
    );
  }

  Future<int> getPaymentItemCount() async {
    db = await StockDB.db.database;
    final List<Map<String, Object?>> queryResult = await db.query(
      'pos_payment',
    );
    return queryResult.map((e) => PosPayment.fromMap(e)).toList().length;
  }
}
