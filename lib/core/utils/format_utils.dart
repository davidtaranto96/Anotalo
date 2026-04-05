import 'package:intl/intl.dart';

String todayId() => DateFormat('yyyy-MM-dd').format(DateTime.now());

String dateToId(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

DateTime idToDate(String dayId) => DateFormat('yyyy-MM-dd').parse(dayId);

String weekId(DateTime date) {
  final monday = date.subtract(Duration(days: date.weekday - 1));
  return 'week-${DateFormat('yyyy-ww', 'es').format(monday)}';
}

String formatDuration(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}

String dayName(DateTime date) =>
    DateFormat('EEEE', 'es').format(date);

String shortDayName(DateTime date) =>
    DateFormat('EEE', 'es').format(date);
