import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../services/booking_service.dart';
import '../services/notification_service.dart';
import '../services/user_service.dart';
import '../providers/user_provider.dart';

class NfcViewModel extends ChangeNotifier {
  final BookingService _bookingService = BookingService();
  final UserService _userService = UserService();
  
  bool _isScanning = false;
  String? _errorMessage;
  String? _successMessage;
  StreamSubscription? _hardwareSubscription;
  Timer? _scanTimeout;
  
  static const int scanTimeoutSeconds = 10;

  bool get isScanning => _isScanning;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void startHardwareWaiting(String userId, UserProvider userProvider) async {
    await _ensureHardwareSyncDocumentExists();
    
    _isScanning = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();


    _scanTimeout = Timer(
      Duration(seconds: scanTimeoutSeconds),
      () {
        if (_isScanning) {
          _errorMessage = "Timeout - Nu s-a detectat cardul în ${scanTimeoutSeconds}s";
          _isScanning = false;
          _hardwareSubscription?.cancel();
          notifyListeners();
        }
      },
    );

    _hardwareSubscription = FirebaseFirestore.instance
        .collection('hardware_sync')
        .doc('status')
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data['isScanned'] == true) {
          
          _scanTimeout?.cancel();
          
          _hardwareSubscription?.cancel();
          
          await FirebaseFirestore.instance
              .collection('hardware_sync')
              .doc('status')
              .update({'isScanned': false});

          await _processLoyaltyPoints(userId, userProvider);
        }
      }
    }, onError: (e) {
      _scanTimeout?.cancel();
      _errorMessage = "Eroare la conectarea cu serverul: $e";
      _isScanning = false;
      notifyListeners();
    });
  }

  Future<void> _processLoyaltyPoints(String userId, UserProvider userProvider) async {
    try {
      print("\n🔍 [NFC] === INCEPE PROCESARE PUNCTE ===");
      print("🔍 [NFC] User ID: $userId");
      
      
      await _bookingService.debugListAllUserBookings(userId);
      
      print("\n🔍 [NFC] Cautare booking ACTIV pentru azi...");
      BookingModel? currentBooking = await _bookingService.getClientActiveBookingForToday(userId);

      if (currentBooking == null) {
        print("❌ [NFC] Nu s-a gasit booking pentru azi");
        _errorMessage = "Nu ai nicio programare activă astăzi în acest moment pentru check-in. Punctele de loialitate se acordă doar în timpul programării.";
        _isScanning = false;
        notifyListeners();
        return;
      }

      print("✅ [NFC] Booking gasit: ${currentBooking.id}");
      print("   - Serviciu: ${currentBooking.serviceName}");
      print("   - Status: ${currentBooking.status}");
      print("   - EarnedPoints: ${currentBooking.earnedPoints}");

      if (currentBooking.earnedPoints > 0) {
        print("⚠️ [NFC] Punctele deja adaugate!");
        _errorMessage = "Ai primit deja punctele pentru această programare.";
        _isScanning = false;
        notifyListeners();
        return;
      }

      print("📖 [NFC] Cautare serviciu: ${currentBooking.serviceId}");
      final serviceDoc = await FirebaseFirestore.instance
          .collection('services')
          .doc(currentBooking.serviceId)
          .get();

      if (serviceDoc.exists) {
        final service = ServiceModel.fromMap(serviceDoc.data()!, serviceDoc.id);
        int pointsToAward = service.loyaltyPoints;

        print("✅ [NFC] Serviciu gasit: ${service.name}");
        print("   - Puncte: $pointsToAward");

        if (pointsToAward == 0) {
          print("⚠️ [NFC] Serviciu fara puncte!");
          _errorMessage = "Serviciul nu are puncte de loialitate asociate.";
          _isScanning = false;
          notifyListeners();
          return;
        }

        print("💾 [NFC] Adaug $pointsToAward puncte la user...");
        await _userService.addLoyaltyPoints(userId, pointsToAward);
        print("✅ [NFC] Puncte adaugate la user");
        
        print("💾 [NFC] Actualizez earnedPoints in booking...");
        try {
          await _bookingService.updateBookingEarnedPoints(currentBooking.id, pointsToAward);
          print("✅ [NFC] EarnedPoints actualizat");
        } catch (e) {
          print("❌ [NFC] Eroare la actualizare earnedPoints: $e");
          throw Exception("Eroare la actualizare earnedPoints: $e");
        }
        
        print("💾 [NFC] Marcheaza booking ca completed...");
        try {
          await _bookingService.updateBookingStatus(currentBooking.id, BookingStatus.completed);
          print("✅ [NFC] Booking marcat ca completed");
        } catch (e) {
          print("❌ [NFC] EROARE la update status: $e");
          print("   - Booking ID: ${currentBooking.id}");
          print("   - Statusul încercat: ${BookingStatus.completed}");
          throw Exception("Eroare la marcare completed: $e");
        }
        
        print("💾 [NFC] Update local provider...");
        userProvider.updateLoyaltyPoints(pointsToAward);
        print("✅ [NFC] Provider actualizat");

        await NotificationService.showNotification(
          title: "Puncte de loialitate adăugate!",
          body: "Ai primit $pointsToAward puncte pentru programarea ta la ${service.name}.",
        );

        _successMessage = "✅ Check-in reușit! Ai primit $pointsToAward puncte de loialitate.";
        print("\n🎉 [NFC] === SUCCESS! ===\n");
      } else {
        print("❌ [NFC] Serviciu nu exista!");
        _errorMessage = "Serviciul nu mai există în baza de date.";
      }
    } catch (e) {
      print("❌ [NFC] Eroare la procesare: $e");
      _errorMessage = "A apărut o eroare la procesare: $e";
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  void resetMessages() {
    _errorMessage = null;
    _successMessage = null;
    _isScanning = false;
    _hardwareSubscription?.cancel();
    _scanTimeout?.cancel();
    notifyListeners();
  }

  Future<void> _ensureHardwareSyncDocumentExists() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('hardware_sync')
          .doc('status');
      
      final snapshot = await docRef.get();
      if (!snapshot.exists) {
        await docRef.set({
          'isScanned': false,
          'lastUpdated': Timestamp.now(),
        });
        print("✅ Documentul hardware_sync/status creat cu succes");
      }
    } catch (e) {
      print("❌ Eroare la crearea documentului: $e");
    }
  }

  @override
  void dispose() {
    _hardwareSubscription?.cancel();
    _scanTimeout?.cancel();
    super.dispose();
  }
}