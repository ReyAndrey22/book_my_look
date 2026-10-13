import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_my_look/models/chair_model.dart';
import 'package:book_my_look/models/user_model.dart';

class ChairService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  Stream<List<ChairModel>> getChairsStream() {
    return _firestore
        .collection('chairs')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChairModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  
  Future<void> addChair(ChairModel chair) async {
    try {
      await _firestore.collection('chairs').add(chair.toMap());
    } catch (e) {
      throw Exception("Eroare la crearea scaunului: $e");
    }
  }

  
  Future<void> assignBarberToChair(String chairId, UserModel barber) async {
    final batch = _firestore.batch();
    
    final chairRef = _firestore.collection('chairs').doc(chairId);
    final userRef = _firestore.collection('users').doc(barber.uid);

    
    batch.update(chairRef, {
      'assignedBarberId': barber.uid,
      'assignedBarberName': barber.name,
    });

    
    batch.update(userRef, {
      'barberDetails.chairId': chairId,
    });

    try {
      await batch.commit();
    } catch (e) {
      throw Exception("Eroare la asignarea scaunului: $e");
    }
  }

  
  Future<void> releaseChair(String chairId, String barberId) async {
    final batch = _firestore.batch();
    
    final chairRef = _firestore.collection('chairs').doc(chairId);
    final userRef = _firestore.collection('users').doc(barberId);

    batch.update(chairRef, {
      'assignedBarberId': null,
      'assignedBarberName': null,
    });

    batch.update(userRef, {
      'barberDetails.chairId': null,
    });

    try {
      await batch.commit();
    } catch (e) {
      throw Exception("Eroare la eliberarea scaunului: $e");
    }
  }
}