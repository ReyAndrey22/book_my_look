import 'package:cloud_firestore/cloud_firestore.dart';

enum RewardType { discountPercentage, freeService, freeProduct, fixedValue }

class RewardModel {
  final String id;
  final String title;
  final String description;
  final int pointsCost;
  final RewardType type;
  final double? value; 
  final String? serviceId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? expiresAt;

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsCost,
    required this.type,
    this.value,
    this.serviceId,
    this.isActive = true,
    DateTime? createdAt,
    this.expiresAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'pointsCost': pointsCost,
      'type': type.name,
      'value': value,
      'serviceId': serviceId,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
    };
  }

  factory RewardModel.fromMap(Map<String, dynamic> data, String docId) {
    return RewardModel(
      id: docId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      pointsCost: data['pointsCost'] ?? 0,
      type: RewardType.values.byName(data['type'] ?? 'discountPercentage'),
      value: data['value'] != null ? (data['value'] as num).toDouble() : null,
      serviceId: data['serviceId'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
    );
  }
}
