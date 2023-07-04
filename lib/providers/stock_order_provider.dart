import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_pos/utils/constant.dart';
import '../controllers/stock_order_controller.dart';
import '../models/stock_detail.dart';
import '../models/stock_header.dart';

class StockOrderProvider extends ChangeNotifier {
  StockOrderController controller = StockOrderController();

  List<StockDetail> stockDetailList = [];

  int totlalQty = 0;
  double totalAmount = 0.0;
  int slipNumber = 1;

  getTotalAmount() {
    var total = 0.0;
    for (var stockItem in stockDetailList) {
      total += stockItem.amount!;
    }
    totalAmount = total;
    notifyListeners();
  }

  getTotalQty() {
    var total = 0;
    for (var stockItem in stockDetailList) {
      total += stockItem.qty;
    }
    totlalQty = total;
    notifyListeners();
  }

  addStockOrderItem(StockDetail stockItem) {
    stockDetailList.add(stockItem);
    getTotalAmount();
    getTotalQty();
    notifyListeners();
  }

  removeStockOrderItem(int stockId) {
    if (stockDetailList.isNotEmpty) {
      var stockItem =
          stockDetailList.firstWhere((item) => item.stkId == stockId);
      stockDetailList.remove(stockItem);
      getTotalAmount();
      getTotalQty();
      notifyListeners();
    }
  }

  void qtyCalculate({required int index, required bool isIncreased}) {
    if (isIncreased) {
      stockDetailList.toList()[index].qty += 1;
      if (stockDetailList.toList()[index].qty > 20) {
        stockDetailList.toList()[index].qty = 20;
      } else {
        double newPrice = stockDetailList.toList()[index].qty *
            stockDetailList.toList()[index].stkprice!;
        stockDetailList.toList()[index].amount = newPrice;
      }
    } else {
      stockDetailList.toList()[index].qty -= 1;
      if (stockDetailList.toList()[index].qty < 1) {
        stockDetailList.toList()[index].qty = 1;
      } else {
        double newPrice = stockDetailList.toList()[index].stkprice! *
            stockDetailList.toList()[index].qty;
        stockDetailList.toList()[index].amount = newPrice;
      }
    }
    getTotalAmount();
    getTotalQty();
    notifyListeners();
  }

  orderStockItem(List<StockDetail> stockItemList) async {
    await controller.readMaxSlipNoforHeader().then((value) {
      if (value.isEmpty) {
        slipNumber = 1;
      } else {
        slipNumber = value[0].slipNumber! + 1;
      }
    });
    var syskey = generatesyskey();

    var stockHeader = StockHeader(
      syskey: syskey,
      slipNumber: slipNumber,
      amount: totalAmount,
      date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      time: DateFormat('HH:mm:ss a').format(DateTime.now()),
      status: 0,
    );

    await controller.insertStockHeader(stockHeader);

    for (var item in stockItemList) {
      item.parentId = syskey;
      controller.insertStockDetail(item);
    }
    stockDetailList = [];
    totlalQty = 0;
    totalAmount = 0.0;
    notifyListeners();
  }
}
