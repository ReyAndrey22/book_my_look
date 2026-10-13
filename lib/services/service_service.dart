import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_my_look/models/service_model.dart';

class ServiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ServiceModel>> getAllServices() {
    return _firestore
        .collection('services')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return ServiceModel.fromMap(doc.data(), doc.id);
            }).toList());
  }

  Future<String> addService(ServiceModel service) async {
    try {
      final docRef = await _firestore.collection('services').add(service.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception("Eroare la salvarea serviciului: $e");
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      await _firestore.collection('services').doc(serviceId).delete();
    } catch (e) {
      throw Exception("Eroare la ștergerea serviciului: $e");
    }
  }

  Future<void> updateService(ServiceModel service) async {
    try {
      await _firestore
          .collection('services')
          .doc(service.id)
          .update(service.toMap());
    } catch (e) {
      throw Exception("Eroare la actualizarea serviciului: $e");
    }
  }
}