import 'package:flutter/material.dart';
import 'package:book_my_look/models/service_model.dart';
import 'package:book_my_look/theme/app_colors.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit; 

  const ServiceCard({
    super.key, 
    required this.service, 
    this.onDelete, 
    this.onEdit, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  service.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
             
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: onEdit, 
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white38, 
                      size: 20,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFD32F2F),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          Text(
            service.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Text(
                "${service.price.toStringAsFixed(0)} RON",
                style: const TextStyle(
                  color: kPrimaryGold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.access_time,
                size: 15,
                color: Colors.white38,
              ),
              const SizedBox(width: 3),
              Text(
                "${service.duration}min",
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 15,
                ),
              ),
              if (service.loyaltyPoints > 0) ...[
                const SizedBox(width: 12),
                const Icon(
                  Icons.star,
                  size: 15,
                  color: kPrimaryGold,
                ),
                const SizedBox(width: 3),
                Text(
                  "${service.loyaltyPoints} pts",
                  style: const TextStyle(
                    color: kPrimaryGold,
                    fontSize: 15,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}