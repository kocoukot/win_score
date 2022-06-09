import 'package:intl/intl.dart';

String requestDateFormat(DateTime date) => DateFormat("yyyyMMdd").format(date);

String formatGameTime(String startTime) =>
    DateFormat('HH:mm').format(getDateTime(startTime));

String formatGameDate(String startTime) =>
    DateFormat('dd.MM').format(getDateTime(startTime));

DateTime getDateTime(String startTime) =>
    DateTime.fromMillisecondsSinceEpoch(int.parse(startTime) * 1000);

DateTime getScheduleDateTime(String startTime) =>
    DateTime.fromMillisecondsSinceEpoch(int.parse(startTime) * 1000 + 10800000);
