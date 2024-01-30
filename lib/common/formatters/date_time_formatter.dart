class DateTimeFormatter{
  static DateTime parseStringToDateTime({required String date, required String delimiter}) {
    return DateTime.parse(date.replaceAll(delimiter, '-'));
  }
}