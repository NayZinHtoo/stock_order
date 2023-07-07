import 'package:flutter/material.dart';
import '../controllers/stock_order_list_view_controller.dart';
import '../models/stock_detail.dart';
import '../models/stock_header.dart';

class StockOrderViewProvider extends ChangeNotifier {
  StockOrderListViewController controller = StockOrderListViewController();

  List<StockHeader> stockHeaderList = [];
  List<StockDetail> stockDetailList = [];

  int totalQty = 0;

  Future<void> getStockHeaderList() async {
    stockHeaderList.clear();
    stockHeaderList = await controller.getStockHeaderList();
    notifyListeners();
  }

  Future<StockHeader> getStockHeader(String syskey) async {
    return await controller.getStockHeader(syskey);
  }

  Future<void> getStockDetailList(String parentId) async {
    stockDetailList.clear();
    stockDetailList = await controller.getStockDetailList(parentId);
    await getToalQty();
    notifyListeners();
  }

  Future<void> getToalQty() async {
    totalQty = 0;
    // for (var item in stockDetailList) {
    //   totalQty += item.qty;
    // }
    totalQty = stockDetailList.fold(0, (previous, item) => previous + item.qty);
    notifyListeners();
  }

  Future<void> removeStockHeader(StockHeader stockHeader) async {
    await controller.updateStockHeaderStatus(stockHeader.id!, 0);
    stockHeaderList.remove(stockHeader);
    notifyListeners();
  }
}
