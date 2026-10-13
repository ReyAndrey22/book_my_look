import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/view_models/barber_view_model.dart'; 

class BarberHomeScreen extends StatelessWidget {
  const BarberHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final details = user?.barberDetails;
    final barberVM = context.watch<BarberViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: user == null || details == null
          ? const Center(child: CircularProgressIndicator(color: kPrimaryGold))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Salut, ${user.name.split(' ')[0]}! 👋",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: details.isActive,
                                  activeThumbColor: Colors.green,
                                  activeTrackColor: Colors.green.withValues(alpha: 0.5), 
                                  inactiveThumbColor: Colors.red,
                                  inactiveTrackColor: Colors.red.withValues(alpha: 0.5),
                                  onChanged: barberVM.isLoading 
                                  ? null 
                                  : (bool value) {
                                     final userProvider = context.read<UserProvider>();
                                     barberVM.toggleOnlineStatus(user.uid, value, userProvider);
                                     },
                                ),
                              ),
                              Text(
                                details.isActive ? "Ești Online" : "Ești Offline",
                                style: TextStyle(
                                  color: details.isActive ? Colors.green : Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: kPrimaryGold,
                        child: Text(user.name[0],
                            style: const TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Text("PERFORMANȚA TA",
                      style: TextStyle(
                          color: kPrimaryGold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2)),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard("Rating Mediu", "${details.rating}", Icons.star),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard("Recenzii Totale", "${details.reviewsCount}", Icons.reviews),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Text("DETALIILE TALE",
                      style: TextStyle(
                          color: kPrimaryGold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2)),
                  const SizedBox(height: 10),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.work_history_outlined, color: Colors.white70),
                    title: const Text("Experiență", style: TextStyle(color: Colors.white)),
                    trailing: Text("${details.experienceYears} ani",
                        style: const TextStyle(color: kPrimaryGold, fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("BIO",
                            style: TextStyle(
                                color: kPrimaryGold,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(
                          details.bio,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryGold,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.calendar_today),
                      label: const Text("Vezi Agenda de Azi",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kPrimaryGold, size: 20),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }
}