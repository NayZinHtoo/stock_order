import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/stock_item.dart';

class AddStockItemController {
  late Database db;

  // insert data
  Future<int> insertStockItem(StockItem stockItem) async {
    db = await StockDB.db.database;

    /* Method 1 */
    final result = await db.insert(
      'stock_item',
      stockItem.toJson(),
    );
    return result;

    /* Method 2 */
    // final result = await db.rawInsert(
    //     'INSERT INTO stock_item(name,price,category,image,status) VALUES("${stockItem.name}", ${stockItem.price}, "${stockItem.category}","${stockItem.image}",0)');
    // return result;
  }
}
