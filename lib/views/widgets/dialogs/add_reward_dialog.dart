import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/view_models/reward_view_model.dart';
import 'package:book_my_look/view_models/service_view_model.dart';
import 'package:book_my_look/models/reward_model.dart';
import 'package:book_my_look/models/service_model.dart';
import 'package:book_my_look/theme/app_colors.dart';

class AddRewardDialog extends StatefulWidget {
  final RewardModel? rewardToEdit;

  const AddRewardDialog({super.key, this.rewardToEdit});

  @override
  State<AddRewardDialog> createState() => _AddRewardDialogState();
}

class _AddRewardDialogState extends State<AddRewardDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController pointsCostController;
  late TextEditingController valueController;
  late RewardType selectedType;
  DateTime? selectedExpiryDate;
  String? selectedServiceId;
  List<ServiceModel> availableServices = [];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
      text: widget.rewardToEdit?.title ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.rewardToEdit?.description ?? '',
    );
    pointsCostController = TextEditingController(
      text: widget.rewardToEdit?.pointsCost.toString() ?? '',
    );
    valueController = TextEditingController(
      text: widget.rewardToEdit?.value?.toString() ?? '',
    );
    selectedType = widget.rewardToEdit?.type ?? RewardType.discountPercentage;
    selectedExpiryDate = widget.rewardToEdit?.expiresAt;
    selectedServiceId = widget.rewardToEdit?.serviceId;
    _loadServices();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    pointsCostController.dispose();
    valueController.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    if (!mounted) return;

    final serviceVM = context.read<ServiceViewModel>();
    final services = await serviceVM.servicesStream.first;
    if (mounted) {
      setState(() {
        availableServices = services;
      });
    }
  }

  String _getRewardTypeDisplayName(RewardType type) {
    switch (type) {
      case RewardType.discountPercentage:
        return 'Reducere procentuală';
      case RewardType.freeService:
        return 'Serviciu gratuit';
      case RewardType.freeProduct:
        return 'Produs gratuit';
      case RewardType.fixedValue:
        return 'Valoare fixă (RON)';
    }
  }

  bool _requiresValueField(RewardType type) {
    return type == RewardType.discountPercentage ||
        type == RewardType.fixedValue;
  }

  bool _requiresServiceSelection(RewardType type) {
    return type == RewardType.freeService ||
        type == RewardType.discountPercentage ||
        type == RewardType.fixedValue;
  }

  ServiceModel? _getSelectedService() {
    if (selectedServiceId == null) return null;
    return availableServices.firstWhere(
      (service) => service.id == selectedServiceId,
      orElse: () => ServiceModel(
        id: '',
        name: 'Serviciu necunoscut',
        description: '',
        price: 0,
        duration: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rewardViewModel = context.read<RewardViewModel>();
    final isEditing = widget.rewardToEdit != null;

    return Dialog(
      backgroundColor: kBackgroundBlack,
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
                    isEditing ? "Editează recompensă" : "Recompensă nouă",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Titlu recompensă",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "ex. Reducere 20%",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: kSurfaceGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Descriere",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "ex. Reducere de 20% la orice serviciu",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: kSurfaceGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Cost în puncte",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: pointsCostController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "ex. 100",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: kSurfaceGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Tip recompensă",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: kSurfaceGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<RewardType>(
                  value: selectedType,
                  isExpanded: true,
                  dropdownColor: kSurfaceGrey,
                  style: const TextStyle(color: Colors.white),
                  underline: const SizedBox(),
                  items: RewardType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getRewardTypeDisplayName(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedType = value;
                        if (!_requiresValueField(value)) {
                          valueController.clear();
                        }
                        if (!_requiresServiceSelection(value)) {
                          selectedServiceId = null;
                        }
                      });
                    }
                  },
                ),
              ),
              if (_requiresValueField(selectedType)) ...[
                const SizedBox(height: 20),
                Text(
                  selectedType == RewardType.discountPercentage
                      ? "Procent reducere (%)"
                      : "Valoare (RON)",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: valueController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: selectedType == RewardType.discountPercentage
                        ? "ex. 20"
                        : "ex. 50",
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: kSurfaceGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
              if (_requiresServiceSelection(selectedType)) ...[
                const SizedBox(height: 20),
                Text(
                  selectedType == RewardType.freeService
                      ? "Selectează serviciul gratuit"
                      : "Selectează un serviciu (opțional, se aplică doar acestuia)",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: kSurfaceGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String?>(
                    value: selectedServiceId,
                    isExpanded: true,
                    dropdownColor: kSurfaceGrey,
                    style: const TextStyle(color: Colors.white),
                    underline: const SizedBox(),
                    hint: const Text(
                      "Alege un serviciu",
                      style: TextStyle(color: Colors.white38),
                    ),
                    items: availableServices.map((service) {
                      return DropdownMenuItem<String?>(
                        value: service.id,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              service.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${service.price.toStringAsFixed(0)} RON • ${service.duration} min",
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedServiceId = value;
                      });
                    },
                  ),
                ),
                if (selectedServiceId != null &&
                    _getSelectedService() != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kPrimaryGold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: kPrimaryGold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: kPrimaryGold,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Serviciu selectat: ${_getSelectedService()!.name}",
                            style: const TextStyle(
                              color: kPrimaryGold,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],

              const SizedBox(height: 20),
              const Text(
                "Data expirare (opțional)",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate:
                        selectedExpiryDate ??
                        DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: kPrimaryGold,
                            surface: kSurfaceGrey,
                            onSurface: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    setState(() {
                      selectedExpiryDate = date;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: kSurfaceGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedExpiryDate != null
                              ? "${selectedExpiryDate!.day.toString().padLeft(2, '0')}.${selectedExpiryDate!.month.toString().padLeft(2, '0')}.${selectedExpiryDate!.year}"
                              : "Selectează dată",
                          style: TextStyle(
                            color: selectedExpiryDate != null
                                ? Colors.white
                                : Colors.white38,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white38,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: rewardViewModel.isLoading
                      ? null
                      : () async {
                          if (titleController.text.isEmpty ||
                              descriptionController.text.isEmpty ||
                              pointsCostController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Completează toate câmpurile obligatorii",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final pointsCost = int.tryParse(
                            pointsCostController.text,
                          );
                          if (pointsCost == null || pointsCost <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Costul în puncte trebuie să fie un număr pozitiv",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (selectedType == RewardType.freeService &&
                              selectedServiceId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Selectează un serviciu pentru recompensa gratuită",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          double? value;
                          if (_requiresValueField(selectedType)) {
                            value = double.tryParse(valueController.text);
                            if (value == null || value <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Valoarea trebuie să fie un număr pozitiv",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                          }

                          try {
                            if (isEditing) {
                              await rewardViewModel
                                  .updateReward(widget.rewardToEdit!.id, {
                                    'title': titleController.text,
                                    'description': descriptionController.text,
                                    'pointsCost': pointsCost,
                                    'type': selectedType.name,
                                    'value': value,
                                    'serviceId': selectedServiceId,
                                    'expiresAt': selectedExpiryDate,
                                  });
                            } else {
                              await rewardViewModel.addReward(
                                title: titleController.text,
                                description: descriptionController.text,
                                pointsCost: pointsCost,
                                type: selectedType,
                                value: value,
                                serviceId: selectedServiceId,
                                expiresAt: selectedExpiryDate,
                              );
                            }

                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Eroare: $e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: rewardViewModel.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          isEditing
                              ? "Salvează modificările"
                              : "Adaugă recompensă",
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
