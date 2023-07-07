import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AppColor {
  static const greenColor = Color(0xFF18460C);
}

String generatesyskey() {
  var random = Random();
  var randomNo = random.nextInt(90000) + 10000;
  var date = DateTime.now();

  var syskey =
      '${date.year}${date.month}${date.day}${date.hour}${date.minute}${date.second}$randomNo';
  return syskey;
}

String thousandsSeparatorsFormat(double number) {
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  return myFormat.format(number);
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white);
}
