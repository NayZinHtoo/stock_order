import 'package:flutter/material.dart';
import '../controllers/pos_payment_controller.dart';
import '../models/pos_payment.dart';

class PosPaymentProvider extends ChangeNotifier {
  PosPaymentController controller = PosPaymentController();

  List<PosPayment> paymentList = [];

  getAllPaymentList() async {
    paymentList.clear();
    paymentList.addAll(await controller.retrievePosPayment());
    notifyListeners();
    return paymentList;
  }

  addPosPayment(PosPayment posPayment) async {
    await controller.insertPosPayment(posPayment);
    if (posPayment.dftPayment == 1) {
      if (paymentList.isNotEmpty) {
        for (var element in paymentList) {
          controller.updateDefaultPosPayment(element.id!);
        }
      }
    }
    getAllPaymentList();
    notifyListeners();
  }

  removePosPayment(int id) {
    if (paymentList.isNotEmpty) {
      var posPayment = paymentList.firstWhere((item) => item.id == id);
      paymentList.remove(posPayment);
      controller.updatePosPaymentStatus(id);
      notifyListeners();
    }
  }

  updatePosPayment(PosPayment posPayment) async {
    controller.updatePosPayment(posPayment);
    if (posPayment.dftPayment == 1) {
      if (paymentList.isNotEmpty) {
        for (var element in paymentList) {
          if (element.id != posPayment.id) {
            controller.updateDefaultPosPayment(element.id!);
          }
        }
      }
    }
    // paymentList[paymentList
    //     .indexWhere((element) => element.id == posPayment.id)] = posPayment;
    getAllPaymentList();
    notifyListeners();
    return paymentList;
  }
}
