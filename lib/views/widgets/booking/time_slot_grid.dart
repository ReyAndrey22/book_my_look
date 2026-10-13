import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:book_my_look/theme/app_colors.dart';

class TimeSlotGrid extends StatelessWidget {
  final List<DateTime> slots;
  final DateTime? selectedTime;
  final Function(DateTime time) onTimeSelected;

  const TimeSlotGrid({
    super.key,
    required this.slots,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const Center(
        child: Text(
          "Nicio oră disponibilă",
          style: TextStyle(color: Colors.white24),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final time = slots[index];
        final isSelected = selectedTime == time;
        return GestureDetector(
          onTap: () => onTimeSelected(time),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? kPrimaryGold : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white10,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              DateFormat('HH:mm').format(time),
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
