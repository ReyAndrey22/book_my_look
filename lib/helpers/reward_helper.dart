import 'package:book_my_look/models/reward_model.dart';
import 'package:book_my_look/models/user_voucher_model.dart';

class RewardHelper {

  static double calculateFinalPrice({
    required RewardType type,
    required double originalPrice,
    double? rewardValue,
  }) {
    switch (type) {
      case RewardType.discountPercentage:
        double percent = (rewardValue ?? 0).clamp(0, 100);
        return originalPrice - (originalPrice * percent / 100);
      
      case RewardType.fixedValue:
        double discount = (rewardValue ?? 0).clamp(0, originalPrice);
        return originalPrice - discount;
      
      case RewardType.freeService:
        return 0.0;
      
      case RewardType.freeProduct:
        return originalPrice;
    }
  }

  static bool isVoucherApplicable({
    required UserVoucherModel voucher,
    required String selectedServiceId,
  }) {
    if (voucher.rewardType == RewardType.freeProduct) {
      return true;
    }

    if (voucher.serviceId != null) {
      return voucher.serviceId == selectedServiceId;
    }

    return true;
  }
}