import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:book_my_look/theme/app_colors.dart';

class RewardSuccessDialog extends StatelessWidget {
  final String rewardTitle;
  final int pointsCost;

  const RewardSuccessDialog({
    super.key,
    required this.rewardTitle,
    required this.pointsCost,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/success.json',
              width: 150,
              height: 150,
              repeat: false,
            ),
            const SizedBox(height: 20),
            Text(
              'Recompensa "$rewardTitle" a fost revendicată!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kPrimaryGold,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ai plătit $pointsCost puncte. Mulțumim că folosești clubul de loialitate!',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryGold,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Perfect',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
