import 'package:flutter/material.dart';
import 'package:book_my_look/models/service_model.dart';
import 'package:book_my_look/theme/app_colors.dart';

class ClientServiceCard extends StatelessWidget {
  final ServiceModel service;
  final bool isSelected;
  final bool hasSelection;
  final bool isEnabled;
  final VoidCallback onTap;

  const ClientServiceCard({
    super.key,
    required this.service,
    required this.isSelected,
    required this.hasSelection,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isGreyedOut = (hasSelection && !isSelected) || !isEnabled;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        width: isSelected ? 200 : 160,
        height: isSelected ? 280 : 200, 
        margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryGold : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white10,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected 
            ? [BoxShadow(color: kPrimaryGold.withValues(alpha: 0.3), blurRadius: 10, spreadRadius: 2)] 
            : [],
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isGreyedOut ? 0.3 : 1.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.content_cut, 
                    color: isSelected ? Colors.black : kPrimaryGold,
                    size: isSelected ? 26 : 22,
                  ),
                  const SizedBox(height: 8),

                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    child: Text(
                      service.name,
                      textAlign: TextAlign.center,
                      maxLines: isSelected ? null : 1,
                      overflow: isSelected ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    child: Text(
                      service.description,
                      textAlign: TextAlign.center,
                      maxLines: isSelected ? null : 2, 
                      overflow: isSelected ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected ? Colors.black87 : Colors.white54,
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time, 
                        size: 12, 
                        color: isSelected ? Colors.black.withValues(alpha: 0.7) : Colors.white38,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${service.duration} min",
                        style: TextStyle(
                          color: isSelected ? Colors.black.withValues(alpha: 0.7) : Colors.white38,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${service.price.toStringAsFixed(0)} RON",
                    style: TextStyle(
                      color: isSelected ? Colors.black : kPrimaryGold,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
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