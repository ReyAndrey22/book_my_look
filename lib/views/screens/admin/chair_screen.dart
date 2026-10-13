import 'package:book_my_look/models/user_model.dart';
import 'package:book_my_look/view_models/user_view_model.dart';
import 'package:book_my_look/views/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/view_models/chair_view_model.dart';
import 'package:book_my_look/models/chair_model.dart';
import 'package:book_my_look/theme/app_colors.dart';

class ChairScreen extends StatelessWidget {
  const ChairScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chairVM = context.watch<ChairViewModel>();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Configurare Salon",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showAddChairDialog(context, chairVM),
                icon: const Icon(Icons.add_business_outlined),
                label: const Text("Scaun Nou", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Gestionează posturile de lucru și frizerii asignați.",
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: StreamBuilder<List<ChairModel>>(
              stream: chairVM.chairsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: kPrimaryGold));
                }
                
                final chairs = snapshot.data ?? [];
                
                if (chairs.isEmpty) {
                  return const Center(
                    child: Text("Niciun scaun configurat.", style: TextStyle(color: Colors.white38)),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.80,
                  ),
                  itemCount: chairs.length,
                  itemBuilder: (context, index) {
                    final chair = chairs[index];
                    final bool isOccupied = chair.assignedBarberId != null;
                    //print("Scaun: ${chair.name}, Ocupat: $isOccupied, ID: ${chair.assignedBarberId}");
                    return GestureDetector(

                      onTap: isOccupied ? null : () => _showAssignBarberDialog(context, chair),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isOccupied ? kPrimaryGold : Colors.white10,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chair_alt_rounded,
                              size: 40,
                              color: isOccupied ? kPrimaryGold : Colors.white24,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              chair.name,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isOccupied ? chair.assignedBarberName ?? "Ocupat" : "Apasă pentru asignare",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isOccupied ? kPrimaryGold : Colors.white30,
                                fontSize: 12,
                                fontStyle: isOccupied ? FontStyle.normal : FontStyle.italic,
                              ),
                            ),
                            if (isOccupied)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                                  onPressed: () => chairVM.freeChair(chair),
                                  child: const Text("Eliberează", style: TextStyle(color: Colors.redAccent, fontSize: 11)),
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAssignBarberDialog(BuildContext context, ChairModel chair) {
    final userVM = context.read<UserViewModel>();
    final chairVM = context.read<ChairViewModel>();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Asignează frizer la ${chair.name}",
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: StreamBuilder<List<UserModel>>(
                stream: userVM.usersStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  // Filtrăm: Să fie Barber ȘI să nu aibă deja un scaun asignat
                  final availableBarbers = snapshot.data!.where((u) => 
                    u.role == 'barber' && (u.barberDetails?.chairId == null || u.barberDetails!.chairId!.isEmpty)
                  ).toList();

                  if (availableBarbers.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text("Nu există frizeri disponibili.", style: TextStyle(color: Colors.white38))),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableBarbers.length,
                    itemBuilder: (context, index) {
                      final barber = availableBarbers[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: kPrimaryGold,
                          child: Text(barber.name[0].toUpperCase(), style: const TextStyle(color: Colors.black)),
                        ),
                        title: Text(barber.name, style: const TextStyle(color: Colors.white)),
                        trailing: const Icon(Icons.add_circle_outline, color: kPrimaryGold),
                        onTap: () async {
                          final error = await chairVM.assignBarber(chair, barber);
                          if (context.mounted) {
                            if (error != null) {
                              ErrorDialog.showError(context, error);
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${barber.name} a fost asignat!")),
                              );
                            }
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddChairDialog(BuildContext context, ChairViewModel vm) {
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF121212),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Adaugă Scaun", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "ex. Scaunul 1",
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: const Color(0xFF222222),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kPrimaryGold)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: kPrimaryGold),
                  onPressed: () async {
                    if (nameCtrl.text.isNotEmpty) {
                      final error = await vm.addNewChair(nameCtrl.text);
                      if (error == null && context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text("Salvează", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}