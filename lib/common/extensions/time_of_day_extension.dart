import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  String get asString {
    var time = this;
    return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
  }
  
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }

  static String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}