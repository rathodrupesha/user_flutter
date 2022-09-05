import 'dart:core';

import 'package:intl/intl.dart';

class DateUtilss {

  //region Date Conversation
  static String dateToString(DateTime date, {String? format}) {

    DateFormat formatter = DateFormat(format);
    try {
      return formatter.format(date);
    } catch (e) {
      print('Error formatting date: $e');
    }
    return '';
  }
  //endregion

  static DateTime stringToDateInLocal(String string) {
    if (string.isNotEmpty) {
      try {
        var convertedDate = (string.contains('Z')) ? DateTime.parse(string) : DateTime.parse(string + 'Z');
        return convertedDate.toLocal();
      } catch (e) { }
    }
    return DateTime.now();
  }

  static DateTime? stringToDate(String string, {String? format, bool isUTCTime = false}) {
    DateFormat formatter = DateFormat(format);
    if (string.isNotEmpty) {
      try {

        var convertedDate = formatter.parse(string);
        if (isUTCTime) {
          convertedDate = convertedDate.add(DateTime.now().timeZoneOffset);
        }
        return convertedDate;
      } catch (e) {
        print('---- Error :: ${e.toString()} ----');
      }
    }
    return null;
  }
  


}
  
