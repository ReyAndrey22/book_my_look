import 'package:flutter/material.dart';
import 'package:book_my_look/models/booking_model.dart';
import 'package:book_my_look/helpers/status_booking_helper.dart';

class BookingBadge extends StatelessWidget {
  final BookingStatus status;

  const BookingBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color = StatusBookingHelper.getColor(status);
    final String label = StatusBookingHelper.getLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}