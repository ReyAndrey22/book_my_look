import 'package:flutter/material.dart';
import 'package:book_my_look/models/user_model.dart';
import 'package:book_my_look/theme/app_colors.dart';

class ClientBarberCard extends StatelessWidget {
  final UserModel barber;
  final bool isSelected;
  final bool isEnabled; 
  final VoidCallback onTap;

  const ClientBarberCard({
    super.key,
    required this.barber,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOnline = barber.barberDetails?.isActive ?? false;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isEnabled ? 1.0 : 0.2, 
        child: Container(
          width: 100,
          margin: const EdgeInsets.only(right: 15),
          child: Column(
            children: [
              Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.all(isSelected ? 3 : 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? kPrimaryGold : Colors.transparent, 
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: const Color(0xFF1E1E1E),
                      child: Text(
                        barber.name[0], 
                        style: const TextStyle(color: kPrimaryGold, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 5,
                    bottom: 5,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                barber.name.split(' ')[0],
                style: TextStyle(
                  color: isSelected ? kPrimaryGold : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              Text(
                isOnline ? "Disponibil" : "Ocupat",
                style: TextStyle(
                  color: isOnline ? const Color(0xFF3BCA40).withValues(alpha: 0.7) : Colors.white24,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}