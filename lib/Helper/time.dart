import 'package:intl/intl.dart';

class Time_Chat {
  static String readTimestamp(int timestamp) {
    if (timestamp != null) {
      DateTime notification = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final date2 = DateTime.now();
      final diff = date2.difference(notification);

      if (diff.inDays > 8) {
        return DateFormat("MMM d").format(notification);
      } else if ((diff.inDays / 7).floor() >= 1) {
        return DateFormat("MMM d").format(notification);
      } else if (diff.inDays >= 2) {
        return DateFormat("MMM d").format(notification);
      } else if (diff.inDays >= 1) {
        return DateFormat("MMM d").format(notification);
      } else if (diff.inHours >= 2) {
        return DateFormat("MMM d").format(notification);
      } else if (diff.inDays >= 1) {
        return DateFormat("HH:mm a").format(notification);
      } else if (diff.inMinutes >= 2) {
        return DateFormat("HH:mm a").format(notification);
      } else if (diff.inMinutes >= 1) {
        return "1m";
      } else if (diff.inSeconds >= 3) {
        return "${diff.inSeconds} s";
      } else {
        return "Now";
      }
    }
  }
}
