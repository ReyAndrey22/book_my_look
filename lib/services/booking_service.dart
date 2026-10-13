import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_my_look/models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createBooking(BookingModel booking) async {
    try {
      print("🔄 Crearea rezervarii in Firebase...");
      print("   - Frizer: ${booking.barberId}");
      print("   - Client: ${booking.clientId}");
      print("   - Data/ora: ${booking.scheduledAt}");
      
      final docRef = await _firestore.collection('bookings').add(booking.toMap());
      
      print("✅ Rezervare salvata cu succes! ID: ${docRef.id}");
    } catch (e) {
      print("❌ Eroare Firebase: $e");
      throw Exception("Eroare la salvarea rezervării în Firebase: $e");
    }
  }

  Stream<List<BookingModel>> getBarberBookingsStream(String barberId, DateTime date) {
    DateTime startOfDay = DateTime(date.year, date.month, date.day, 0, 0);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _firestore
        .collection('bookings')
        .where('barberId', isEqualTo: barberId)
        .where('scheduledAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('scheduledAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('scheduledAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': newStatus.name,
      });
    } catch (e) {
      throw Exception("Nu s-a putut actualiza statusul: $e");
    }
  }

  Future<void> markMissedBookingAsNoShow(BookingModel booking) async {
    final now = DateTime.now();
    final appointmentEnd = booking.scheduledAt.add(Duration(minutes: booking.duration));

    if ((booking.status == BookingStatus.confirmed || booking.status == BookingStatus.inProgress) &&
        now.isAfter(appointmentEnd) &&
        booking.earnedPoints == 0) {
      try {
        await updateBookingStatus(booking.id, BookingStatus.noShow);
        print("✅ Booking ${booking.id} marcat ca noShow deoarece clientul nu s-a prezentat.");
      } catch (e) {
        print("❌ Nu s-a putut marca booking ${booking.id} ca noShow: $e");
      }
    }
  }

  Future<void> updateBookingEarnedPoints(String bookingId, int earnedPoints) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'earnedPoints': earnedPoints,
      });
      print("✅ Punctele pentru booking $bookingId actualizate: $earnedPoints");
    } catch (e) {
      throw Exception("Nu s-a putut actualiza punctele pentru programare: $e");
    }
  }

  Future<List<BookingModel>> getBookingsByBarberAndDate(String barberId, DateTime date) async {
    try {
      print("🔍 Se cauta rezervarile pentru frizerul $barberId in data ${date.toLocal().toString()}");
      
      DateTime startOfDay = DateTime(date.year, date.month, date.day, 0, 0);
      DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('barberId', isEqualTo: barberId)
          .where('scheduledAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('scheduledAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .where('status', isNotEqualTo: 'cancelled') 
          .get();

      final bookings = snapshot.docs.map((doc) {
        return BookingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      
      print("✅ Gasite ${bookings.length} rezervari pentru aceasta zi");
      return bookings;
    } catch (e) {
      print("❌ Eroare la preluarea rezervarilor: $e");
      return [];
    }
  }

  Future<bool> isSlotAvailable(String barberId, DateTime requestedTime) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('barberId', isEqualTo: barberId)
          .where('scheduledAt', isEqualTo: Timestamp.fromDate(requestedTime))
          .where('status', isNotEqualTo: 'cancelled')
          .limit(1)
          .get();

      return snapshot.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }

  Stream<List<BookingModel>> getClientBookings(String clientId) {
    return _firestore
        .collection('bookings')
        .where('clientId', isEqualTo: clientId)
        .orderBy('scheduledAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return BookingModel.fromMap(doc.data(), doc.id);
            }).toList());
  }

  Future<BookingModel?> getClientActiveBookingForToday(String clientId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

      print("🔍 [BOOKING] Cautare booking pentru astazi:");
      print("   Client ID: $clientId");
      print("   Now: $now");
      print("   Start: $startOfDay");
      print("   End: $endOfDay");

      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('clientId', isEqualTo: clientId)
          .where('scheduledAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('scheduledAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .where('status', whereIn: [
            BookingStatus.confirmed.name,
            BookingStatus.inProgress.name
          ])
          .get();

      print("   📊 Documente gasite: ${snapshot.docs.length}");

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime scheduledAt = (data['scheduledAt'] as Timestamp).toDate();
        int duration = data['duration'] ?? 0;
        DateTime appointmentEnd = scheduledAt.add(Duration(minutes: duration));

        print("   ✅ Booking ID: ${doc.id}");
        print("      scheduledAt: $scheduledAt");
        print("      duration: ${duration}min");
        print("      appointmentEnd: $appointmentEnd");
        print("      status: ${data['status']}");
        print("      serviceName: ${data['serviceName']}");

        if (now.isAfter(scheduledAt) && now.isBefore(appointmentEnd)) {
          print("   🎯 Timpul curent ($now) este în intervalul programării!");
          return BookingModel.fromMap(data, doc.id);
        } else {
          print("   ⏰ Timpul curent ($now) NU este în intervalul programării");
        }
      }

      print("   ❌ Nu s-a gasit booking activ în intervalul de timp curent!");
      return null;
    } catch (e) {
      print("❌ Eroare la preluarea programării de azi: $e");
      return null;
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': BookingStatus.cancelled.name,
      });
      print("✅ Rezervare $bookingId anulată.");
    } catch (e) {
      print("❌ Eroare la anulare: $e");
      throw Exception("Nu s-a putut anula programarea.");
    }
  }

  Future<void> debugListAllUserBookings(String clientId) async {
    try {
      print("\n🔍 [DEBUG] ===== LISTARE TOTI BOOKINGURI =====");
      print("   Client ID: $clientId");
      
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('clientId', isEqualTo: clientId)
          .get();

      print("   📊 Total documente: ${snapshot.docs.length}");
      
      if (snapshot.docs.isEmpty) {
        print("   ❌ NU EXISTA BOOKINGURI PENTRU ACEST USER!");
      }
      
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime scheduledDate = (data['scheduledAt'] as Timestamp).toDate();
        
        print("\n   📋 Booking: ${doc.id}");
        print("      status: ${data['status']}");
        print("      scheduledAt: $scheduledDate");
        print("      serviceName: ${data['serviceName']}");
        print("      earnedPoints: ${data['earnedPoints']}");
      }
      print("🔍 [DEBUG] ===== SFARSIT LISTARE =====\n");
    } catch (e) {
      print("❌ Eroare debug: $e");
    }
  }
}