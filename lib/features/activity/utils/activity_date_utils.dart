import 'package:intl/intl.dart';

class ActivityDateUtils {
  ActivityDateUtils._();

  // Single source of truth for Activity Date format (YYYY-MM-DD)
  static String normalizeDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String today() {
    return normalizeDate(DateTime.now());
  }

  // Ensures safety against malformed external strings
  static bool isValidFormat(String dateStr) {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return regex.hasMatch(dateStr);
  }
}
