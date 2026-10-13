import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_my_look/models/reward_model.dart';

class UserVoucherModel {
  final String id;
  final String userId;
  final String rewardId;
  final String rewardTitle;
  final String rewardDescription;
  final RewardType rewardType; 
  final String? serviceId;     
  final double? rewardValue;
  final int pointsCost;
  final DateTime redeemedAt;
  final bool isUsed;
  final DateTime? usedAt;
  final String? bookingId;

  UserVoucherModel({
    required this.id,
    required this.userId,
    required this.rewardId,
    required this.rewardTitle,
    required this.rewardDescription,
    required this.rewardType,
    this.serviceId,
    this.rewardValue,
    required this.pointsCost,
    required this.redeemedAt,
    this.isUsed = false,
    this.usedAt,
    this.bookingId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rewardId': rewardId,
      'rewardTitle': rewardTitle,
      'rewardDescription': rewardDescription,
      'rewardType': rewardType.name,
      'serviceId': serviceId,
      'rewardValue': rewardValue,
      'pointsCost': pointsCost,
      'redeemedAt': Timestamp.fromDate(redeemedAt),
      'isUsed': isUsed,
      'usedAt': usedAt != null ? Timestamp.fromDate(usedAt!) : null,
      'bookingId': bookingId,
    };
  }

  factory UserVoucherModel.fromMap(Map<String, dynamic> data, String docId) {
    return UserVoucherModel(
      id: docId,
      userId: data['userId'] ?? '',
      rewardId: data['rewardId'] ?? '',
      rewardTitle: data['rewardTitle'] ?? '',
      rewardDescription: data['rewardDescription'] ?? '',
      rewardType: RewardType.values.byName(data['rewardType'] ?? 'discountPercentage'),
      serviceId: data['serviceId'],
      rewardValue: data['rewardValue'] != null ? (data['rewardValue'] as num).toDouble() : null,
      pointsCost: data['pointsCost'] ?? 0,
      redeemedAt: (data['redeemedAt'] as Timestamp).toDate(),
      isUsed: data['isUsed'] ?? false,
      usedAt: (data['usedAt'] as Timestamp?)?.toDate(),
      bookingId: data['bookingId'],
    );
  }

  UserVoucherModel copyWith({
    bool? isUsed,
    DateTime? usedAt,
    String? bookingId,
  }) {
    return UserVoucherModel(
      id: id,
      userId: userId,
      rewardId: rewardId,
      rewardTitle: rewardTitle,
      rewardDescription: rewardDescription,
      rewardType: rewardType,
      serviceId: serviceId,
      rewardValue: rewardValue,
      pointsCost: pointsCost,
      redeemedAt: redeemedAt,
      isUsed: isUsed ?? this.isUsed,
      usedAt: usedAt ?? this.usedAt,
      bookingId: bookingId ?? this.bookingId,
    );
  }
}