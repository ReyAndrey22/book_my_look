import 'package:flutter/material.dart';
import 'package:book_my_look/models/reward_model.dart';
import 'package:book_my_look/theme/app_colors.dart';

class RewardTile extends StatelessWidget {
  final RewardModel reward;
  final int currentPoints;
  final VoidCallback onRedeem;

  const RewardTile({
    super.key,
    required this.reward,
    required this.currentPoints,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final bool canAfford = currentPoints >= reward.pointsCost;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: canAfford ? kPrimaryGold.withValues(alpha: 0.3) : Colors.white10,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Iconița Recompensei
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: canAfford ? kPrimaryGold.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    reward.type == RewardType.discountPercentage
                        ? Icons.percent_rounded
                        : Icons.redeem_rounded,
                    color: canAfford ? kPrimaryGold : Colors.white24,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Info Text (Titlu + Descriere)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward.title,
                        style: TextStyle(
                          color: canAfford ? Colors.white : Colors.white38,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        reward.description,
                        style: TextStyle(
                          color: canAfford ? Colors.white60 : Colors.white12,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider subtil între text și acțiuni
          Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),

          // Bară de jos pentru Puncte și Buton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Costul în puncte
                Row(
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      size: 18,
                      color: canAfford ? kPrimaryGold : Colors.white10,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${reward.pointsCost} puncte",
                      style: TextStyle(
                        color: canAfford ? kPrimaryGold : Colors.white10,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                // Butonul sau Iconița Lock
                if (canAfford)
                  ElevatedButton(
                    onPressed: onRedeem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryGold,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Revendică",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline, color: Colors.white10, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "Blocat",
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.1), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}