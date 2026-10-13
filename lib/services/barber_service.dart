import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_my_look/models/user_model.dart';

class BarberService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateIsActive(String uid, bool status) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'barberDetails.isActive': status,
      });
    } catch (e) {
      throw Exception("Eroare la update status: $e");
    }
  }

  
  Stream<List<UserModel>> getAvailableBarbers() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'barber') 
        .where('barberDetails.isActive', isEqualTo: true) 
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data()))
            .toList());
  }
}