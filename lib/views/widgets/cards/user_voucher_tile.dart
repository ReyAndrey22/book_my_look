import 'package:flutter/material.dart';
import 'package:coupon_uikit/coupon_uikit.dart'; 
import 'package:book_my_look/models/user_voucher_model.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/helpers/date_format.dart';

class UserVoucherTile extends StatelessWidget {
  final UserVoucherModel voucher;

  const UserVoucherTile({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    final bool isUsed = voucher.isUsed;

    return Opacity(
      opacity: isUsed ? 0.6 : 1.0,
      child: CouponCard(
        height: 150,
        backgroundColor: const Color(0xFF1A1A1A),
        curveAxis: Axis.vertical,
        curvePosition: 80, 
        curveRadius: 30,
        borderRadius: 15,
        border: BorderSide(
          color: isUsed ? Colors.white10 : kPrimaryGold.withValues(alpha: 0.3),
          width: 2,
        ),
        // FIRST CHILD - Stânga (Iconiță dinamică)
        firstChild: Container(
          decoration: BoxDecoration(
            color: isUsed ? Colors.white.withValues(alpha: 0.02) : kPrimaryGold.withValues(alpha: 0.1),
          ),
          child: Center(
            child: Icon(
              // Schimbăm iconița dacă e folosit
              isUsed ? Icons.block_flipped : Icons.local_activity_rounded,
              color: isUsed ? Colors.white24 : kPrimaryGold,
              size: 32,
            ),
          ),
        ),
        // SECOND CHILD - Dreapta
        secondChild: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLU
              Text(
                voucher.rewardTitle,
                style: TextStyle(
                  color: isUsed ? Colors.white38 : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              
              // DESCRIERE
              Expanded(
                child: Text(
                  voucher.rewardDescription,
                  style: TextStyle(
                    color: isUsed ? Colors.white12 : Colors.white60,
                    fontSize: 12,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                ),
              ),
              
              // STATUS ȘI DATA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Etichetă Dinamică (ACTIV vs FOLOSIT)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isUsed 
                          ? Colors.white.withValues(alpha: 0.05) 
                          : kPrimaryGold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isUsed ? "Folosit" : "Activ",
                      style: TextStyle(
                        color: isUsed ? Colors.white24 : kPrimaryGold,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // DATA JOS DREAPTA
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Data revendicării",
                        style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateHelper.formatDate(voucher.redeemedAt),
                        style: TextStyle(
                          color: isUsed ? Colors.white10 : Colors.white60,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}