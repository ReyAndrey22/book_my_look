import 'package:book_my_look/views/widgets/dialogs/add_service_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/views/widgets/cards/service_card.dart';
import 'package:book_my_look/view_models/service_view_model.dart';
import 'package:book_my_look/models/service_model.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/views/widgets/error_dialog.dart';



class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ServiceViewModel>();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Servicii",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGold,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddServiceDialog(),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Adaugă serviciu", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: StreamBuilder<List<ServiceModel>>(
              stream: viewModel.servicesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: kPrimaryGold));
                }
                final services = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];     
                    return ServiceCard(
                      service: service,
                      onEdit: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddServiceDialog(serviceToEdit: service),
                        );
                      },
                      onDelete: () async {
                        final bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xFF1A1A1A),
                            title: const Text("Șterge Serviciu", style: TextStyle(color: Colors.white)),
                            content: Text("Ești sigur că vrei să ștergi serviciul ${service.name}?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Anulează", style: TextStyle(color: Colors.white60)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Șterge", style: TextStyle(color: Colors.redAccent)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          final String? errorMessage = await viewModel.removeService(service.id);  
                          if (errorMessage != null && context.mounted) {
                            ErrorDialog.showError(context, errorMessage);
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
    );
  }
}