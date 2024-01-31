import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormatter{
  static String formatDateToString({required String dateFormat, required DateTime date}){
    return DateFormat(dateFormat).format(date);
  }
}