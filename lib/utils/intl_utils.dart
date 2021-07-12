import 'package:intl/intl.dart';

class IntlUtils {
  //This method is used when parameter is in millisecondsSinceEpoch
  static String formatDateTime(int millisecondsSinceEpoch) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return DateFormat('MMMM d hh:mm a').format(dateTime);
  }

  static String getTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }
}
