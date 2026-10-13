import 'package:flutter/material.dart';
import 'package:book_my_look/theme/app_colors.dart';
import 'package:book_my_look/models/booking_model.dart';

class PaymentSelector extends StatelessWidget {
  final PaymentMethod selectedPaymentMethod;
  final Function(PaymentMethod method) onPaymentMethodChanged;

  const PaymentSelector({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _paymentOption("CASH", Icons.payments_outlined, PaymentMethod.cash),
          const SizedBox(width: 10),
          _paymentOption("CARD", Icons.credit_card_outlined, PaymentMethod.card),
        ],
      ),
    );
  }

  Widget _paymentOption(String title, IconData icon, PaymentMethod method) {
    bool isSelected = selectedPaymentMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () => onPaymentMethodChanged(method),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryGold.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? kPrimaryGold : Colors.white10,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? kPrimaryGold : Colors.white24,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white24,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
