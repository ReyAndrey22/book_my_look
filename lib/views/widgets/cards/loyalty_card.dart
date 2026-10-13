import 'package:flutter/material.dart';
import 'package:book_my_look/theme/app_colors.dart';

class LoyaltyCard extends StatelessWidget {
  final int currentPoints;
  final String userName;
  final String milestoneMessage;
  final bool isMaxLevel;

  const LoyaltyCard({
    super.key,
    required this.currentPoints,
    required this.userName,
    required this.milestoneMessage,
    this.isMaxLevel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: kPrimaryGold.withValues(alpha: 0.3),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kPrimaryGold, Color(0xFFE6B800)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Punctele tale",
                      style: TextStyle(
                        color: Color(0xFF8B6F00),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Icon(
                      Icons.emoji_events_rounded,
                      size: 28,
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "$currentPoints",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Text(
              milestoneMessage,
              style: TextStyle(
                color: isMaxLevel ? kPrimaryGold : Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}