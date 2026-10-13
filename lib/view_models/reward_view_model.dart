import 'package:flutter/material.dart';
import 'package:book_my_look/models/reward_model.dart';
import 'package:book_my_look/models/user_model.dart';
import 'package:book_my_look/models/user_voucher_model.dart';
import 'package:book_my_look/services/reward_service.dart';
import 'package:book_my_look/services/user_service.dart';
import 'package:book_my_look/models/milestone_state_model.dart';

class RewardViewModel extends ChangeNotifier {
  final RewardService _rewardService = RewardService();
  final UserService _userService = UserService();

  List<RewardModel> _rewards = [];
  List<RewardModel> get rewards => _rewards;

  List<RewardModel> _activeRewards = [];
  List<RewardModel> get activeRewards => _activeRewards;

  List<UserVoucherModel> _redeemedVouchers = [];
  List<UserVoucherModel> get redeemedVouchers => _redeemedVouchers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  MilestoneState getMilestoneState(int currentPoints) {
  final locked = _activeRewards.where((r) => r.pointsCost > currentPoints).toList()
    ..sort((a, b) => a.pointsCost.compareTo(b.pointsCost));

  if (_activeRewards.isEmpty) {
    return MilestoneState(
      message: "Recompensele vor fi disponibile în curând!",
      nextMilestoneValue: currentPoints > 0 ? currentPoints : 1000,
      isMaxLevel: false,
    );
  }

  if (currentPoints == 0) {
    final minCost = _activeRewards.map((r) => r.pointsCost).reduce((a, b) => a < b ? a : b);
    return MilestoneState(
      message: "Fă prima programare și începe să aduni puncte!",
      nextMilestoneValue: minCost,
      isMaxLevel: false,
    );
  }

  if (locked.isEmpty) {
    return MilestoneState(
      message: "Felicitări! Poți debloca orice recompensă disponibilă!",
      nextMilestoneValue: currentPoints,
      isMaxLevel: true,
    );
  }

  final next = locked.first;
  return MilestoneState(
    message: "Încă ${next.pointsCost - currentPoints} puncte până la ${next.title}",
    nextMilestoneValue: next.pointsCost,
    isMaxLevel: false,
  );
}

  Future<void> addReward({
    required String title,
    required String description,
    required int pointsCost,
    required RewardType type,
    double? value,
    String? serviceId,
    DateTime? expiresAt,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final reward = RewardModel(
        id: '',
        title: title,
        description: description,
        pointsCost: pointsCost,
        type: type,
        value: value,
        serviceId: serviceId,
        expiresAt: expiresAt,
      );

      await _rewardService.createReward(reward);

      await loadAllRewards();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadAllRewards() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _rewards = await _rewardService.getAllRewards();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Eroare la încărcarea reward-urilor: $e";
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadActiveRewards() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activeRewards = await _rewardService.getActiveRewards();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Eroare la încărcarea reward-urilor active: $e";
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateReward(
    String rewardId,
    Map<String, dynamic> updates,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _rewardService.updateReward(rewardId, updates);
      await loadAllRewards();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteReward(String rewardId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _rewardService.deleteReward(rewardId);
      await loadAllRewards();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<RewardModel?> getRewardById(String rewardId) async {
    try {
      return await _rewardService.getRewardById(rewardId);
    } catch (e) {
      _errorMessage = "Eroare la încărcarea reward-ului: $e";
      notifyListeners();
      return null;
    }
  }

  Future<void> toggleRewardStatus(String rewardId, bool isActive) async {
    await updateReward(rewardId, {'isActive': isActive});
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool canRedeemReward(RewardModel reward, int userPoints) {
    return userPoints >= reward.pointsCost;
  }

  int calculateRemainingPoints(int userPoints, int pointsCost) {
    return userPoints - pointsCost;
  }

  Future<void> loadRedeemedVouchers(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _redeemedVouchers = await _userService.getUserVouchers(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Eroare la încărcarea voucherelor revendicate: $e";
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> redeemReward({
    required UserModel user,
    required RewardModel reward,
  }) async {
    if (!canRedeemReward(reward, user.loyaltyPoints)) {
      _errorMessage = 'Nu ai suficiente puncte pentru această recompensă.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.addLoyaltyPoints(user.uid, -reward.pointsCost);

      final userVoucher = UserVoucherModel(
        id: '',
        userId: user.uid,
        rewardId: reward.id,
        rewardTitle: reward.title,
        rewardDescription: reward.description,
        rewardType: reward.type,
        serviceId: reward.serviceId,
        rewardValue: reward.value,
        pointsCost: reward.pointsCost,
        redeemedAt: DateTime.now(),
      );
      await _userService.createUserVoucher(userVoucher);
      await loadRedeemedVouchers(user.uid);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Eroare la revendicarea recompensei: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
