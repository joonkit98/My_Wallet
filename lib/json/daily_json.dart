import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  const Event(this.title);

  @override
  String toString() => title;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
