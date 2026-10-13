import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:book_my_look/theme/app_colors.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  const CalendarWidget({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TableCalendar(
        focusedDay: focusedDay,
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 30)),
        calendarFormat: CalendarFormat.twoWeeks,
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: kPrimaryGold,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: kPrimaryGold),
          rightChevronIcon: Icon(Icons.chevron_right, color: kPrimaryGold),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: const TextStyle(color: Colors.white),
          weekendTextStyle: const TextStyle(color: Colors.white54),
          selectedDecoration: const BoxDecoration(
            color: kPrimaryGold,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: kPrimaryGold.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
