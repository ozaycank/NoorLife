class DateHelper {
  DateHelper._();

  static String toIso8601(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  static DateTime fromIso8601(String dateString) {
    return DateTime.parse(dateString);
  }
}
