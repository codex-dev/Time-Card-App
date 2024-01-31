import 'package:flutter/material.dart';

extension CustomTimeFormat on TimeOfDay {
  String get toStringFormat {
    var time = this;
    return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
  }

  static String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}