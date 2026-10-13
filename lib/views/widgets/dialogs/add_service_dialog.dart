import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/view_models/service_view_model.dart';
import 'package:book_my_look/models/service_model.dart';

class AddServiceDialog extends StatefulWidget {
  final ServiceModel? serviceToEdit;

  const AddServiceDialog({super.key, this.serviceToEdit});

  @override
  State<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController durationController;
  late TextEditingController descriptionController;
  late TextEditingController loyaltyPointsController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.serviceToEdit?.name ?? '');
    priceController = TextEditingController(text: widget.serviceToEdit?.price.toString() ?? '');
    durationController = TextEditingController(text: widget.serviceToEdit?.duration.toString() ?? '');
    descriptionController = TextEditingController(text: widget.serviceToEdit?.description ?? '');
    loyaltyPointsController = TextEditingController(text: widget.serviceToEdit?.loyaltyPoints.toString() ?? '0');
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    durationController.dispose();
    descriptionController.dispose();
    loyaltyPointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ServiceViewModel>();
    final isEditing = widget.serviceToEdit != null;

    return Dialog(
      backgroundColor: const Color(0xFF121212),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 450),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? "Editează serviciu" : "Serviciu nou",
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white38, size: 20),
                  )
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Nume serviciu",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(controller: nameController, decoration: const InputDecoration(hintText: "ex. Tuns")),
              
              const SizedBox(height: 20),
              const Text(
                "Descriere",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(controller: descriptionController, decoration: const InputDecoration(hintText: "ex. Tuns clasic")),

              const SizedBox(height: 20),
              const Text(
                "Preț (RON)",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "ex. 50"),
              ),

              const SizedBox(height: 20),
              const Text(
                "Durată (minute)",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "ex. 30"),
              ),

              const SizedBox(height: 20),
              const Text(
                "Puncte de loialitate",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: loyaltyPointsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "ex. 10"),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                      
                      if (isEditing) {
                        final updatedService = ServiceModel(
                          id: widget.serviceToEdit!.id,
                          name: nameController.text,
                          description: descriptionController.text,
                          price: double.tryParse(priceController.text) ?? 0.0,
                          duration: int.tryParse(durationController.text) ?? 0,
                          loyaltyPoints: int.tryParse(loyaltyPointsController.text) ?? 0,
                        );
                        await viewModel.editService(updatedService);
                      } else {
                        await viewModel.createService(
                          nameController.text,
                          descriptionController.text,
                          double.tryParse(priceController.text) ?? 0.0,
                          int.tryParse(durationController.text) ?? 0,
                          int.tryParse(loyaltyPointsController.text) ?? 0,
                        );
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text(isEditing ? "Salvează modificările" : "Adaugă serviciu"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}