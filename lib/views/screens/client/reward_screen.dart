import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/view_models/reward_view_model.dart';
import 'package:book_my_look/view_models/nfc_view_model.dart'; // IMPORT NOU ADAUGAT
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/views/widgets/cards/loyalty_card.dart';
import 'package:book_my_look/views/widgets/cards/reward_tile.dart';
import 'package:book_my_look/views/widgets/cards/user_voucher_tile.dart';
import 'package:book_my_look/views/widgets/reward/reward_success_dialog.dart';
import 'package:book_my_look/views/widgets/error_dialog.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    Future.microtask(() async {
      if (!mounted) return;
      final rewardVM = context.read<RewardViewModel>();
      final user = context.read<UserProvider>().user;
      
      await rewardVM.loadActiveRewards();
      if (user != null) {
        await rewardVM.loadRedeemedVouchers(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    final viewModel = context.watch<RewardViewModel>();

    if (user == null) {
      return const Scaffold(
        backgroundColor: kBackgroundBlack,
        body: Center(child: CircularProgressIndicator(color: kPrimaryGold)),
      );
    }

    final int currentPoints = user.loyaltyPoints;
    final rewards = viewModel.activeRewards;
    final vouchers = viewModel.redeemedVouchers;
    final milestone = viewModel.getMilestoneState(currentPoints);

    return Scaffold(
      backgroundColor: kBackgroundBlack,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              sliver: SliverToBoxAdapter(
                child: LoyaltyCard(
                  currentPoints: currentPoints,
                  userName: user.name,
                  milestoneMessage: milestone.message,
                  isMaxLevel: milestone.isMaxLevel,
                ),
              ),
            ),

            // --- BUTONUL DE SCANARE NFC ADAUGAT AICI ---
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Consumer<NfcViewModel>(
                  builder: (context, nfcVM, child) {
                    return ElevatedButton.icon(
                      onPressed: () {
                        if (nfcVM.isScanning) {
                          nfcVM.resetMessages();
                        } else {
                          nfcVM.startHardwareWaiting(user.uid, context.read<UserProvider>());
                          _showScanningDialog(context, nfcVM);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: nfcVM.isScanning ? Colors.redAccent : kPrimaryGold,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      icon: Icon(
                        nfcVM.isScanning ? Icons.stop_circle : Icons.contactless_outlined,
                        color: Colors.black,
                        size: 26,
                      ),
                      label: Text(
                        nfcVM.isScanning ? "OPREȘTE SCANAREA" : "SCANEAZĂ PENTRU PUNCTE",
                        style: const TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // --- FINAL BUTON NFC ---

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 15),
                  const Text(
                    "RECOMPENSE DISPONIBILE",
                    style: TextStyle(
                      color: kPrimaryGold,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (viewModel.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(child: CircularProgressIndicator(color: kPrimaryGold)),
                    )
                  else if (rewards.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.card_giftcard_rounded, 
                                 size: 48, 
                                 color: Colors.white.withValues(alpha: 0.1)),
                            const SizedBox(height: 12),
                            const Text(
                              "Momentan nu sunt recompense active.",
                              style: TextStyle(color: Colors.white38, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...rewards.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RewardTile(
                        reward: r,
                        currentPoints: currentPoints,
                        onRedeem: () async {
                          final success = await viewModel.redeemReward(user: user, reward: r);
                          
                          if (!context.mounted) return;
                          
                          if (success) {
                            userProvider.updateLoyaltyPoints(-r.pointsCost);
                            _refreshData();
                            showDialog(
                              context: context,
                              builder: (ctx) => RewardSuccessDialog(
                                rewardTitle: r.title, 
                                pointsCost: r.pointsCost,
                              ),
                            );
                          } else {
                            ErrorDialog.showError(context, viewModel.errorMessage ?? "Eroare");
                          }
                        },
                      ),
                    )),
                ]),
              ),
            ),
            if (vouchers.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const Text(
                      "VOUCHERELE TALE",
                      style: TextStyle(
                        color: kPrimaryGold,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...vouchers.map((v) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: UserVoucherTile(voucher: v),
                    )),
                  ]),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  void _showScanningDialog(BuildContext context, NfcViewModel nfcVM) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context) => Consumer<NfcViewModel>(
        builder: (context, vm, child) {
          return Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (vm.isScanning) ...[
                  const Icon(Icons.contactless_outlined, size: 60, color: kPrimaryGold),
                  const SizedBox(height: 20),
                  const Text(
                    "Apropie cardul de senzorul NFC de la recepție...",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ] else if (vm.successMessage != null) ...[
                  const Icon(Icons.check_circle, size: 60, color: Colors.green),
                  const SizedBox(height: 20),
                  Text(
                    vm.successMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ] else if (vm.errorMessage != null) ...[
                  const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                  const SizedBox(height: 20),
                  Text(
                    vm.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
                
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    vm.resetMessages();
                    Navigator.pop(context);
                  },
                  child: Text(
                    vm.isScanning ? "ANULEAZĂ" : "ÎNCHIDE", 
                    style: const TextStyle(color: kPrimaryGold)
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}