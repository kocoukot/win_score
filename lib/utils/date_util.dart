import 'package:intl/intl.dart';

String requestDateFormat(DateTime date) => DateFormat("yyyyMMdd").format(date);

String formatGameTime(String startTime) =>
    DateFormat('HH:mm').format(_getDateTime(startTime));

String formatGameDate(String startTime) =>
    DateFormat('dd.MM').format(_getDateTime(startTime));

DateTime _getDateTime(String startTime) =>
    DateTime.fromMillisecondsSinceEpoch(int.parse(startTime) * 1000);
