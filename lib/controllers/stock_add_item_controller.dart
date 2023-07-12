import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/stock_item.dart';

class AddStockItemController {
  late Database db;

  // insert data
  Future<int> insertStockItem(StockItem stockItem) async {
    db = await StockDB.db.database;

    /* Method 1 */
    // final result = await db.insert(
    //   'stock_item',
    //   stockItem.toMap(),
    // );
    //return result;

    /* Method 2 */
    final result = await db.rawInsert(
        'INSERT INTO stock_item(name,price,category,image,status) VALUES("${stockItem.name}", ${stockItem.price}, "${stockItem.category}","${stockItem.image}",0)');
    return result;

    /* Test Method 2 */
    // print('${stockItem.name} ################');
    // final result = await db.rawInsert(
    //     'INSERT INTO stock_item(name, description, price,category,image,status) VALUES("${stockItem.name}","${stockItem.description}", ${stockItem.price}, "${stockItem.category}","${stockItem.image}",0)');
    // print('$result -----------');
    // final List<Map<String, Object?>> queryResult = await db.query(
    //   'stock_item',
    //   where: 'id = ?',
    //   whereArgs: [result],
    // );
    // var ll = queryResult.map((e) => StockItem.fromMap(e)).toList();

    // for (var element in ll) {
    //   print('${element.name} ****************');
    // }
    // return result;
  }
}
