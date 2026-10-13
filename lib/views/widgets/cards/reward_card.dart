import 'package:flutter/material.dart';
import 'package:book_my_look/models/reward_model.dart';
import 'package:book_my_look/models/service_model.dart';
import 'package:book_my_look/theme/app_colors.dart';

class RewardCard extends StatelessWidget {
  final RewardModel reward;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final List<ServiceModel>? availableServices;

  const RewardCard({
    super.key,
    required this.reward,
    this.onDelete,
    this.onEdit,
    this.availableServices,
  });

  String _getRewardTypeText(RewardType type) {
    switch (type) {
      case RewardType.discountPercentage:
        return 'Reducere procentuală';
      case RewardType.freeService:
        return 'Serviciu gratuit';
      case RewardType.freeProduct:
        return 'Produs gratuit';
      case RewardType.fixedValue:
        return 'Valoare fixă';
    }
  }

  String _getRewardValueText(RewardModel reward) {
    switch (reward.type) {
      case RewardType.discountPercentage:
        return '${reward.value?.toStringAsFixed(0)}% reducere';
      case RewardType.freeService:
        return 'Serviciu gratuit';
      case RewardType.freeProduct:
        return 'Produs gratuit';
      case RewardType.fixedValue:
        return '${reward.value?.toStringAsFixed(0)} RON';
    }
  }

  String _getServiceName(BuildContext context) {
    if (reward.serviceId == null) return '';

    final services = availableServices ?? [];
    if (services.isEmpty) {
      return 'Serviciu necunoscut';
    }

    final service = services.firstWhere(
      (s) => s.id == reward.serviceId,
      orElse: () => ServiceModel(
        id: '',
        name: 'Serviciu necunoscut',
        description: '',
        price: 0,
        duration: 0,
      ),
    );
    return service.name;
  }

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
                  reward.title,
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
                  if (!reward.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x33FF0000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Inactiv',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
          const SizedBox(height: 8),
          Text(
            reward.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, size: 15, color: kPrimaryGold),
              const SizedBox(width: 3),
              Text(
                "${reward.pointsCost} puncte",
                style: const TextStyle(
                  color: kPrimaryGold,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                _getRewardTypeText(reward.type),
                style: const TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ],
          ),
          if (reward.value != null) ...[
            const SizedBox(height: 8),
            Text(
              _getRewardValueText(reward),
              style: const TextStyle(
                color: kPrimaryGold,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          if (reward.serviceId != null) ...[
            const SizedBox(height: 8),
            Text(
              "Serviciu aplicabil: ${_getServiceName(context)}",
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
          if (reward.expiresAt != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, size: 14, color: Colors.white38),
                const SizedBox(width: 4),
                Text(
                  "Expiră: ${reward.expiresAt!.day.toString().padLeft(2, '0')}.${reward.expiresAt!.month.toString().padLeft(2, '0')}.${reward.expiresAt!.year}",
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
