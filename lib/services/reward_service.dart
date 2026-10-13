import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_my_look/models/reward_model.dart';

class RewardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createReward(RewardModel reward) async {
    try {
      print("🔄 Crearea reward-ului în Firebase...");
      print("   - Titlu: ${reward.title}");
      print("   - Cost puncte: ${reward.pointsCost}");
      print("   - Tip: ${reward.type}");

      final docRef = await _firestore.collection('rewards').add(reward.toMap());

      print("✅ Reward salvat cu succes! ID: ${docRef.id}");
    } catch (e) {
      print("❌ Eroare Firebase: $e");
      throw Exception("Eroare la salvarea reward-ului în Firebase: $e");
    }
  }

  Future<List<RewardModel>> getAllRewards() async {
    try {
      print("🔍 Se încarcă toate reward-urile...");

      QuerySnapshot snapshot = await _firestore
          .collection('rewards')
          .orderBy('createdAt', descending: true)
          .get();

      final rewards = snapshot.docs.map((doc) {
        return RewardModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      print("✅ Încărcate ${rewards.length} reward-uri");
      return rewards;
    } catch (e) {
      print("❌ Eroare la preluarea reward-urilor: $e");
      return [];
    }
  }

  Future<List<RewardModel>> getActiveRewards() async {
    try {
      print("🔍 Se încarcă reward-urile active...");

      QuerySnapshot snapshot = await _firestore
          .collection('rewards')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      final rewards = snapshot.docs.map((doc) {
        return RewardModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      final now = DateTime.now();
      final activeRewards = rewards.where((reward) {
        return reward.expiresAt == null || reward.expiresAt!.isAfter(now);
      }).toList();

      print("✅ Încărcate ${activeRewards.length} reward-uri active");
      return activeRewards;
    } catch (e) {
      print("❌ Eroare la preluarea reward-urilor active: $e");
      return [];
    }
  }

  Future<void> updateReward(
    String rewardId,
    Map<String, dynamic> updates,
  ) async {
    try {
      print("🔄 Actualizarea reward-ului $rewardId...");

      await _firestore.collection('rewards').doc(rewardId).update(updates);

      print("✅ Reward actualizat cu succes!");
    } catch (e) {
      print("❌ Eroare la actualizarea reward-ului: $e");
      throw Exception("Eroare la actualizarea reward-ului: $e");
    }
  }

  Future<void> deleteReward(String rewardId) async {
    try {
      print("🗑️ Ștergerea reward-ului $rewardId...");

      await _firestore.collection('rewards').doc(rewardId).delete();

      print("✅ Reward șters cu succes!");
    } catch (e) {
      print("❌ Eroare la ștergerea reward-ului: $e");
      throw Exception("Eroare la ștergerea reward-ului: $e");
    }
  }

  Future<RewardModel?> getRewardById(String rewardId) async {
    try {
      print("🔍 Se încarcă reward-ul $rewardId...");

      DocumentSnapshot doc = await _firestore
          .collection('rewards')
          .doc(rewardId)
          .get();

      if (doc.exists) {
        final reward = RewardModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
        print("✅ Reward găsit: ${reward.title}");
        return reward;
      } else {
        print("⚠️ Reward-ul $rewardId nu există");
        return null;
      }
    } catch (e) {
      print("❌ Eroare la preluarea reward-ului: $e");
      return null;
    }
  }
}
