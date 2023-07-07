import 'package:flutter/material.dart';
import '../controllers/stock_item_controller.dart';
import '../models/stock_item.dart';

class StockProvider extends ChangeNotifier {
  StockItemListController controller = StockItemListController();
  List<StockItem> stockItemList = [];
  List<StockItem> allStockItemList = [];
  int count = 0;

  Future<int> getStockItemCount() async {
    count = await controller.retrieveStockItemCount();
    notifyListeners();
    return count;
  }

  addStockItem(StockItem stockItem) async {
    stockItemList.add(stockItem);
    allStockItemList.add(stockItem);
    notifyListeners();
    return stockItemList;
  }

  removeStockItem(StockItem stockItem) {
    //controller.deleteStockItem(stockItem.id!);
    controller.updateStockItemStatus(stockItem.id!);
    stockItemList.remove(stockItem);
    allStockItemList.remove(stockItem);
    notifyListeners();
  }

  updateStockItem(StockItem stockItem) async {
    controller.updateStockItem(stockItem);
    stockItemList[stockItemList
        .indexWhere((element) => element.id == stockItem.id)] = stockItem;
    allStockItemList[allStockItemList
        .indexWhere((element) => element.id == stockItem.id)] = stockItem;
    notifyListeners();
    return stockItemList;
  }

  getStockItem() async {
    stockItemList.clear();
    allStockItemList.clear();
    stockItemList.addAll(await controller.retrieveStockItem());
    allStockItemList.addAll(await controller.retrieveStockItem());
    await getStockItemByCategory('All');
    notifyListeners();
    return stockItemList;
  }

  getAllStockItem() async {
    stockItemList.clear();
    stockItemList.addAll(allStockItemList);
    notifyListeners();
    return stockItemList;
  }

  getStockItemByCategory(String category) async {
    stockItemList.clear();
    if (category == 'All') {
      getAllStockItem();
    } else {
      stockItemList
          .addAll(allStockItemList.where((item) => item.category == category));
    }
    notifyListeners();
    return stockItemList;
  }

  void filterSearchResults(String name, String category) async {
    stockItemList = category == 'All'
        ? await getStockItem()
        : await getStockItemByCategory(category);
    stockItemList = stockItemList
        .where((item) => item.name!.toLowerCase().contains(name.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> setStockItemSelected(int id) async {
    //var index = stockItemList.indexWhere((element) => element.id == id);
    //stockItemList[index].isSlelected = !stockItemList[index].isSlelected;

    var allindex = allStockItemList.indexWhere((element) => element.id == id);
    allStockItemList[allindex].isSlelected =
        !allStockItemList[allindex].isSlelected;

    notifyListeners();
  }

  resetStockItemSelected() {
    stockItemList.map((e) => e.isSlelected = false).toList();
    allStockItemList.map((e) => e.isSlelected = false).toList();
    notifyListeners();
  }
}
