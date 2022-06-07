import 'package:intl/intl.dart';

class Time_Chat {
  static String readTimestamp(int timestamp) {
    if (timestamp != null) {
      DateTime notification = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final date2 = DateTime.now();
      final diff = date2.difference(notification);

      if (diff.inDays > 8) {
        return DateFormat("dd-MM-yyyy HH:mm:ss").format(notification);
      } else if ((diff.inDays / 7).floor() >= 1) {
        return "Last week";
      } else if (diff.inDays >= 2) {
        return "${diff.inDays} days ago";
      } else if (diff.inDays >= 1) {
        return "1 days ago";
      } else if (diff.inHours >= 2) {
        return "${diff.inHours} Hours ago";
      } else if (diff.inDays >= 1) {
        return "1 Hour ago";
      } else if (diff.inMinutes >= 2) {
        return "${diff.inMinutes} Minute ago";
      } else if (diff.inMinutes >= 1) {
        return "1 Minute ago";
      } else if (diff.inSeconds >= 3) {
        return "${diff.inSeconds} Second ago";
      } else {
        return "Just Now";
      }
    }
  }
}
