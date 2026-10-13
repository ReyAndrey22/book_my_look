import 'package:flutter/material.dart';
import 'package:book_my_look/models/user_voucher_model.dart';
import 'package:book_my_look/models/reward_model.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/helpers/reward_helper.dart';

class VoucherSelector extends StatelessWidget {
  final List<UserVoucherModel> vouchers;
  final String selectedServiceId;
  final UserVoucherModel? selectedVoucher;
  final Function(UserVoucherModel?) onVoucherSelected;

  const VoucherSelector({
    super.key,
    required this.vouchers,
    required this.selectedServiceId,
    required this.selectedVoucher,
    required this.onVoucherSelected,
  });

  @override
  Widget build(BuildContext context) {
    final availableVouchers = vouchers.where((v) => 
      RewardHelper.isVoucherApplicable(
        voucher: v, 
        selectedServiceId: selectedServiceId,
      )
    ).toList();

    if (availableVouchers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "APLICĂ UN VOUCHER",
            style: TextStyle(
              color: kPrimaryGold,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: availableVouchers.length,
            itemBuilder: (context, index) {
              final voucher = availableVouchers[index];
              final isSelected = selectedVoucher?.id == voucher.id;

              return GestureDetector(
                onTap: () => onVoucherSelected(isSelected ? null : voucher),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 220,
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? kPrimaryGold.withValues(alpha: 0.15) 
                        : const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? kPrimaryGold : Colors.white.withValues(alpha: 0.05),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        voucher.rewardType == RewardType.freeProduct 
                            ? Icons.card_giftcard 
                            : Icons.confirmation_number_outlined,
                        color: isSelected ? kPrimaryGold : Colors.white24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              voucher.rewardTitle,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              voucher.rewardType == RewardType.freeProduct 
                                  ? "Produs cadou inclus" 
                                  : "Reducere disponibilă",
                              style: const TextStyle(color: Colors.white24, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: kPrimaryGold, size: 18),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}