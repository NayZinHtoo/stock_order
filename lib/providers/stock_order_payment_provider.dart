import 'package:flutter/material.dart';
import '../controllers/stock_order_payment_controller.dart';
import '../models/stock_order_payment.dart';

class StockOrderPaymentProvider extends ChangeNotifier {
  StockOrderPaymentController controller = StockOrderPaymentController();
  bool isValidAmount = true;
  List<StockOrderPayment> orderPaymentList = [];

  Future<List<StockOrderPayment>> getStockPaymentList(String parentId) async {
    orderPaymentList = await controller.getStockPaymentList(parentId);
    notifyListeners();
    return orderPaymentList;
  }

  addOrderPayment(List<StockOrderPayment> orderPaymentList) {
    for (var orderPayment in orderPaymentList) {
      // print(
      //     'Id: ${orderPayment.paymentId} Desc: ${orderPayment.paymentdesc} Amount: ${orderPayment.amount}');
      controller.insertPosPayment(orderPayment);
    }
    notifyListeners();
  }

  setValidAmount(bool isValid) {
    isValidAmount = isValid;
    notifyListeners();
  }
}
