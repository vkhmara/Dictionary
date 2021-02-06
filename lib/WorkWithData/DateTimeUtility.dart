import 'package:flutter/material.dart';

class DateTimeUtility {

  static TimeOfDay timeFromHour(int hour) {
    return TimeOfDay(hour: hour, minute: 0);
  }

  static bool isTimeLessOrEqual(TimeOfDay tod1, TimeOfDay tod2) {
    return tod1.hour < tod2.hour ||
        (tod1.hour == tod2.hour && tod1.minute <= tod2.minute);
  }

  static bool isTimeBetween(TimeOfDay checkedTod, TimeOfDay tod1,
      TimeOfDay tod2) {
    return (
        isTimeLessOrEqual(tod1, tod2) &&
            isTimeLessOrEqual(tod1, checkedTod) &&
            isTimeLessOrEqual(checkedTod, tod2)
    ) || (!isTimeLessOrEqual(tod1, tod2) && (
        isTimeLessOrEqual(tod1, checkedTod) ||
            isTimeLessOrEqual(checkedTod, tod2))
    );
  }

  static bool isLess(DateTime dt1, DateTime dt2) {
    return dt1.compareTo(dt2) < 0;
  }

  static bool isLessOrEqual(DateTime dt1, DateTime dt2) {
    return dt1.compareTo(dt2) <= 0;
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static String timeAsString(DateTime dt) {
    return '${_twoDigits(dt.hour)}:${_twoDigits(dt.minute)}';
  }

  static String dateAsString(DateTime dt) {
    return '${_twoDigits(dt.day)}.${_twoDigits(dt.month)}' + (
        (dt.year == DateTime.now().year) ? '' : '.${dt.year}'
    );
  }

  static TimeOfDay fromMinutes(int minutes) {
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  static int toMinutes(TimeOfDay tod) {
    return tod.hour * 60 + tod.minute;
  }

  static DateTime withoutTime(DateTime dt) {
    return dt.subtract(Duration(
        hours: dt.hour,
        minutes: dt.minute,
        seconds: dt.second,
        milliseconds: dt.millisecond,
        microseconds: dt.microsecond
    ));
  }

  static DateTime joinDateAndTime(DateTime dt, TimeOfDay tod) {
    return DateTimeUtility
        .withoutTime(dt)
        .add(Duration(hours: tod.hour, minutes: tod.minute));
  }

  static String dateTimeToString(DateTime dt) {
    return "${dt.year}-${_twoDigits(dt.month)}-${_twoDigits(dt.day)} "
        "${_twoDigits(dt.hour)}:${_twoDigits(dt.minute)}:${_twoDigits(
        dt.second)}";
  }
}