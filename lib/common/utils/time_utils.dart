import 'package:flutter/material.dart';

class TimeUtils{
  static int? getDurationInHours({TimeOfDay? inTime, TimeOfDay? outTime}) {
    if (inTime == null || outTime == null) return null;

    double doubleInTime =
        inTime.hour.toDouble() + (inTime.minute.toDouble() / 60);
    double doubleOutTime =
        outTime.hour.toDouble() + (outTime.minute.toDouble() / 60);

    double timeDiff = doubleOutTime - doubleInTime;

    int hr = timeDiff.truncate();

    return hr > 0 ? hr : null;
  }
}