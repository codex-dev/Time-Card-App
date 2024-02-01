import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:time_card_app/common/enums/toast_type_enum.dart';

class AppToast {
  static void showMessage({required ToastType type, required String message}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: type == ToastType.error ? Colors.red : Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
