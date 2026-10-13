import 'package:flutter/material.dart';
import 'package:book_my_look/models/booking_model.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/helpers/date_format.dart';
import 'package:book_my_look/views/widgets/booking/booking_badge.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onCancel;

  const BookingCard({
    super.key,
    required this.booking,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final bool canCancel = booking.status == BookingStatus.confirmed &&  booking.scheduledAt.isAfter(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurfaceGrey,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(booking.serviceName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              BookingBadge(status: booking.status),
            ],
          ),
          const SizedBox(height: 8),
          Text("Frizer: ${booking.barberName}", style: const TextStyle(color: Colors.white70)),
          const Divider(color: Colors.white10, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: kPrimaryGold, size: 18),
                  const SizedBox(width: 8),
                  Text(DateHelper.formatDateTime(booking.scheduledAt), style: const TextStyle(color: Colors.white)),
                ],
              ),
              Text("${booking.priceAtBooking.toStringAsFixed(0)} RON", 
                   style: const TextStyle(color: kPrimaryGold, fontWeight: FontWeight.bold)),
            ],
          ),
          if (canCancel && onCancel != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
                child: const Text("ANULEAZĂ PROGRAMAREA", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
              ),
            ),
          ],
        ],
      ),
    );
  }

}