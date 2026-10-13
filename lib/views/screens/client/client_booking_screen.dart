import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/services/booking_service.dart';
import 'package:book_my_look/models/booking_model.dart';
import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/views/widgets/cards/booking_card.dart';

class ClientBookingScreen extends StatelessWidget {
  const ClientBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UserProvider>().user?.uid;
    final bookingService = BookingService();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBackgroundBlack,
        appBar: AppBar(
          backgroundColor: kSurfaceGrey,
          toolbarHeight: 0,
          bottom: const TabBar(
            indicatorColor: kPrimaryGold,
            labelColor: kPrimaryGold,
            unselectedLabelColor: Colors.white30,
            tabs: [
              Tab(text: "ACTIVE"),
              Tab(text: "ISTORIC"),
            ],
          ),
        ),
        body: userId == null
            ? const Center(child: Text("Te rugăm să te loghezi", style: TextStyle(color: Colors.white)))
            : StreamBuilder<List<BookingModel>>(
                stream: bookingService.getClientBookings(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: kPrimaryGold));
                  }

                  final allBookings = snapshot.data ?? [];

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _markMissedBookings(allBookings, bookingService);
                  });
                  
                  // Programări ce urmează să aibă loc
                  final active = allBookings.where((b) => 
                    b.status == BookingStatus.confirmed || b.status == BookingStatus.inProgress
                  ).toList();

                  // Programări finalizate, anulate sau no-show
                  final history = allBookings.where((b) => 
                    b.status == BookingStatus.completed || 
                    b.status == BookingStatus.cancelled || 
                    b.status == BookingStatus.noShow
                  ).toList();

                  return TabBarView(
                    children: [
                      _buildList(context, active, "Nu ai programări active.", bookingService),
                      _buildList(context, history, "Istoricul tău este gol.", bookingService),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<BookingModel> bookings, String emptyMsg, BookingService service) {
    if (bookings.isEmpty) {
      return Center(
        child: Text(emptyMsg, style: const TextStyle(color: Colors.white30)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return BookingCard(
          booking: booking,
          onCancel: () => _confirmCancel(context, booking, service),
        );
      },
    );
  }

  void _markMissedBookings(List<BookingModel> bookings, BookingService service) {
    final now = DateTime.now();

    for (final booking in bookings) {
      final appointmentEnd = booking.scheduledAt.add(Duration(minutes: booking.duration));
      if ((booking.status == BookingStatus.confirmed || booking.status == BookingStatus.inProgress) &&
          now.isAfter(appointmentEnd) &&
          booking.earnedPoints == 0) {
        service.markMissedBookingAsNoShow(booking);
      }
    }
  }

  void _confirmCancel(BuildContext context, BookingModel booking, BookingService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kSurfaceGrey,
        title: const Text("Confirmă anularea", style: TextStyle(color: Colors.white)),
        content: Text("Sigur vrei să anulezi programarea la ${booking.barberName}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("NU")),
          TextButton(
            onPressed: () async {
              await service.cancelBooking(booking.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("DA, ANULEAZĂ", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}