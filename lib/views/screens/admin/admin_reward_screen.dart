import 'package:book_my_look/views/widgets/dialogs/add_reward_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/views/widgets/cards/reward_card.dart';
import 'package:book_my_look/view_models/reward_view_model.dart';
import 'package:book_my_look/view_models/service_view_model.dart';
import 'package:book_my_look/models/service_model.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/views/widgets/error_dialog.dart';

class AdminRewardScreen extends StatefulWidget {
  const AdminRewardScreen({super.key});

  @override
  State<AdminRewardScreen> createState() => _AdminRewardScreenState();
}

class _AdminRewardScreenState extends State<AdminRewardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<RewardViewModel>().loadAllRewards();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RewardViewModel>();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recompense",
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddRewardDialog(),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  "Adaugă recompensă",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: StreamBuilder<List<ServiceModel>>(
              stream: context.read<ServiceViewModel>().servicesStream,
              builder: (context, serviceSnapshot) {
                final availableServices = serviceSnapshot.data ?? [];

                if (viewModel.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimaryGold),
                  );
                }

                if (viewModel.rewards.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nu există recompense disponibile",
                      style: TextStyle(color: kTextGrey, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: viewModel.rewards.length,
                  itemBuilder: (context, index) {
                    final reward = viewModel.rewards[index];
                    return RewardCard(
                      reward: reward,
                      availableServices: availableServices,
                      onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                AddRewardDialog(rewardToEdit: reward),
                          );
                        },
                        onDelete: () async {
                          final bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: kSurfaceGrey,
                              title: const Text(
                                "Șterge Recompensă",
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Text(
                                "Ești sigur că vrei să ștergi recompensa '${reward.title}'?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text(
                                    "Anulează",
                                    style: TextStyle(color: kTextGrey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Șterge",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            try {
                              await viewModel.deleteReward(reward.id);
                            } catch (e) {
                              if (context.mounted) {
                                ErrorDialog.showError(
                                  context,
                                  "Eroare la ștergerea recompensei: $e",
                                );
                              }
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
