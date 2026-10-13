import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/providers/booking_provider.dart';
import 'package:book_my_look/view_models/barber_view_model.dart';
import 'package:book_my_look/view_models/service_view_model.dart';
import 'package:book_my_look/models/service_model.dart';
import 'package:book_my_look/models/user_model.dart';
import 'package:book_my_look/views/widgets/cards/client_service_card.dart';
import 'package:book_my_look/views/widgets/cards/client_barber_card.dart';

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final serviceViewModel = context.watch<ServiceViewModel>();
    final barberViewModel = context.watch<BarberViewModel>();
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: StreamBuilder<List<UserModel>>(
          stream: barberViewModel.availableBarbersStream,
          builder: (context, barberSnapshot) {
            return StreamBuilder<List<ServiceModel>>(
              stream: serviceViewModel.servicesStream,
              builder: (context, serviceSnapshot) {
                if (barberSnapshot.hasError || serviceSnapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        const Text(
                          "Eroare la încărcarea datelor",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          barberSnapshot.error?.toString() ?? serviceSnapshot.error?.toString() ?? "Eroare necunoscută",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (!barberSnapshot.hasData || !serviceSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))); // kPrimaryGold equivalent
                }

                final allBarbers = barberSnapshot.data!;
                final allServices = serviceSnapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Salut, ${user?.name.split(' ')[0] ?? 'Oaspete'}! 👋",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            const Text("Alege combinația perfectă pentru azi", 
                                style: TextStyle(color: Colors.white54)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("1. SERVICIUL DORIT", 
                            style: TextStyle(color: kPrimaryGold, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 20),
                          itemCount: allServices.length,
                          itemBuilder: (context, index) {
                            final service = allServices[index];
                            return ClientServiceCard(
                              service: service,
                              isSelected: bookingProvider.selectedServiceId == service.id,
                              hasSelection: bookingProvider.selectedServiceId != null,
                              isEnabled: bookingProvider.isServiceEnabled(service),
                              onTap: () => bookingProvider.selectService(service),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 40),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("2. FRIZERUL DISPONIBIL", 
                            style: TextStyle(color: kPrimaryGold, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 20),
                          itemCount: allBarbers.length,
                          itemBuilder: (context, index) {
                            final barber = allBarbers[index];
                            return ClientBarberCard(
                              barber: barber,
                              isSelected: bookingProvider.selectedBarberId == barber.uid,
                              isEnabled: bookingProvider.isBarberEnabled(barber),
                              onTap: () => bookingProvider.selectBarber(barber),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 50),
                      Center(
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 400),
                          scale: bookingProvider.canContinue ? 1.0 : 0.8,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 400),
                            opacity: bookingProvider.canContinue ? 1.0 : 0.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryGold,
                                  minimumSize: const Size(double.infinity, 55),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  elevation: 8,
                                  shadowColor: kPrimaryGold.withValues(alpha: 0.4),
                                ),
                                onPressed: bookingProvider.canContinue 
                                  ? () => Navigator.pushNamed(context, '/select_date_time')
                                  : null,
                                child: const Text("CONTINUĂ SPRE CALENDAR", 
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}