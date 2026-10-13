import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/view_models/booking_view_model.dart';
import 'package:book_my_look/models/booking_model.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/views/widgets/barber_agenda_tile.dart';

class BarberAgendaScreen extends StatelessWidget {
  const BarberAgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final barberId = context.watch<UserProvider>().user?.uid;
    final bookingVM = context.watch<BookingViewModel>();

    return Scaffold(
      backgroundColor: kBackgroundBlack,
      body: barberId == null
          ? const Center(child: CircularProgressIndicator(color: kPrimaryGold))
          : StreamBuilder<List<BookingModel>>(
              stream: bookingVM.getBarberAgenda(barberId, DateTime.now()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: kPrimaryGold));
                }

                final bookings = (snapshot.data ?? [])
                    .where((b) => b.status != BookingStatus.cancelled)
                    .toList();

                if (bookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 40, color: Colors.white.withValues(alpha: 0.05)),
                        const SizedBox(height: 12),
                        const Text("LIBER PENTRU ASTĂZI",
                        style: TextStyle(
                          color: Colors.white24, 
                          fontSize: 12, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2
                           ),
                           ),
                           ],
                            ),
                             );
                             }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return BarberAgendaTile(booking: bookings[index]);
                  },
                );
              },
            ),
    );
  }

}