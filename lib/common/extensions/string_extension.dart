import 'package:flutter/material.dart';

extension StringExtension on String? {
  bool get isNullOrEmpty {
    return this == null || this!.trim().isEmpty;
  }

  TimeOfDay? get toTimeOfDay {
    if (isNullOrEmpty || !this!.contains(":")) {
      return null;
    }

    List<String> list = this!.split(":");

    if (list.length != 2) {
      return null;
    }

    try {
      int hour = int.parse(list[0]);
      int minute = int.parse(list[1]);

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }
}
