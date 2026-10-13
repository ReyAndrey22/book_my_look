import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_my_look/models/user_model.dart';
import 'package:book_my_look/models/barber_model.dart';
import 'package:book_my_look/models/user_voucher_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      throw Exception("Nu am putut încărca datele utilizatorului.");
    }
    return null;
  }

  Future<void> addLoyaltyPoints(String uid, int points) async {
    if (points == 0) return;
    try {
      await _firestore.collection('users').doc(uid).update({
        'loyaltyPoints': FieldValue.increment(points),
      });
    } catch (e) {
      throw Exception("Nu am putut actualiza punctele de loialitate: $e");
    }
  }

  Future<void> createUserVoucher(UserVoucherModel voucher) async {
    try {
      await _firestore.collection('user_vouchers').add(voucher.toMap());
    } catch (e) {
      throw Exception("Nu am putut salva voucherul utilizatorului: $e");
    }
  }

  Future<List<UserVoucherModel>> getUserVouchers(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('user_vouchers')
          .where('userId', isEqualTo: userId)
          .orderBy('redeemedAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => UserVoucherModel.fromMap(
              doc.data(),
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  Stream<List<UserModel>> getAllUsers() {
    return _firestore
        .collection('users')
        .orderBy('name', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> toggleUserRole(String uid, String currentRole) async {
    try {
      final userDoc = _firestore.collection('users').doc(uid);

      if (currentRole == 'client') {
        List<String> allServiceIds = [];

        try {
          final servicesSnapshot = await _firestore
              .collection('services')
              .get();

          allServiceIds = servicesSnapshot.docs.map((doc) => doc.id).toList();
        } catch (e) {
          throw Exception(
            "Notă: Nu am putut prelua serviciile, listă goală creată. Eroare: $e",
          );
        }

        BarberModel newBarber = BarberModel(
          bio: 'Recent promovat în echipa noastră.',
          experienceYears: 0,
          rating: 5.0,
          reviewsCount: 0,
          isActive: true,
          serviceIds: allServiceIds,
          chairId: null,
        );

        await userDoc.update({
          'role': 'barber',
          'barberDetails': newBarber.toMap(),
        });
      } else {
        await userDoc.update({
          'role': 'client',
          'barberDetails': FieldValue.delete(),
        });
      }
    } catch (e) {
      throw Exception("Eroare critică la schimbarea rolului: $e");
    }
  }

  Future<void> addServiceToAllBarbers(String serviceId) async {
    try {
      final barberQuery = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'barber')
          .get();

      for (final doc in barberQuery.docs) {
        await _firestore.collection('users').doc(doc.id).update({
          'barberDetails.serviceIds': FieldValue.arrayUnion([serviceId]),
        });
      }
    } catch (e) {
      throw Exception("Eroare la actualizarea serviciilor barberilor: $e");
    }
  }

  Future<void> removeServiceFromAllBarbers(String serviceId) async {
    try {
      final barberQuery = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'barber')
          .get();

      for (final doc in barberQuery.docs) {
        await _firestore.collection('users').doc(doc.id).update({
          'barberDetails.serviceIds': FieldValue.arrayRemove([serviceId]),
        });
      }
    } catch (e) {
      throw Exception("Eroare la eliminarea serviciului din frizeri: $e");
    }
  }

  Future<void> markVoucherAsUsed(String voucherId, String bookingId) async {
  try {
    await _firestore.collection('user_vouchers').doc(voucherId).update({
      'isUsed': true,
      'usedAt': Timestamp.fromDate(DateTime.now()),
      'bookingId': bookingId,
    });
  } catch (e) {
    throw Exception("Nu s-a putut marca voucherul ca utilizat: $e");
  }
}
}
