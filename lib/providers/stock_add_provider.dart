import 'package:flutter/material.dart';

import '../controllers/stock_add_item_controller.dart';
import '../models/stock_item.dart';

class StockAddProvider extends ChangeNotifier {
  AddStockItemController controller = AddStockItemController();

  addStockItem(StockItem stockItem) async {
    var res = await controller.insertStockItem(stockItem);
    notifyListeners();
    return res;
  }
}
