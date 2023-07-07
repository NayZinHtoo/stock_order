import 'package:flutter/material.dart';
import '../controllers/stock_order_payment_controller.dart';
import '../models/stock_order_payment.dart';

class StockOrderPaymentProvider extends ChangeNotifier {
  StockOrderPaymentController controller = StockOrderPaymentController();

  addOrderPayment(List<StockOrderPayment> orderPaymentList) {
    for (var orderPayment in orderPaymentList) {
      controller.insertPosPayment(orderPayment);
    }
    notifyListeners();
  }
}
