import 'package:flutter/material.dart';
import 'package:book_my_look/models/booking_model.dart';
import 'package:book_my_look/models/user_voucher_model.dart';
import 'package:book_my_look/services/booking_service.dart';
import 'package:book_my_look/services/user_service.dart';
import 'package:book_my_look/helpers/reward_helper.dart';

class BookingViewModel extends ChangeNotifier {
  final BookingService _bookingService = BookingService();
  final UserService _userService = UserService();

  List<DateTime> _availableSlots = [];
  List<DateTime> get availableSlots => _availableSlots;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Stream<List<BookingModel>> getBarberAgenda(String barberId, DateTime date) {
    return _bookingService.getBarberBookingsStream(barberId, date);
  }

  Future<void> updateStatus(String bookingId, BookingStatus status, {BookingModel? booking}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _bookingService.updateBookingStatus(bookingId, status);
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> confirmBookingWithVoucher({
    required BookingModel booking,
    required UserVoucherModel voucher,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      double finalPrice = RewardHelper.calculateFinalPrice(
        type: voucher.rewardType,
        originalPrice: booking.priceAtBooking,
        rewardValue: voucher.rewardValue,
      );

      final updatedBooking = booking.copyWith(
        priceAtBooking: finalPrice,
        isPaid: finalPrice == 0, 
      );

      bool success = await confirmBooking(updatedBooking);

      if (success) {
        await _userService.markVoucherAsUsed(voucher.id, updatedBooking.id);
      }

      return success;
    } catch (e) {
      _errorMessage = "Eroare la aplicarea voucherului: $e";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchAvailableSlots({
    required String barberId,
    required DateTime selectedDate,
    required int serviceDuration,
  }) async {
    _isLoading = true;
    _availableSlots = [];
    _errorMessage = null;
    notifyListeners();

    try {
      final existingBookings = await _bookingService.getBookingsByBarberAndDate(barberId, selectedDate);
      
      final DateTime nowWithBuffer = DateTime.now().add(const Duration(minutes: 15));
      DateTime startTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
      DateTime endTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 19, 0);

      List<DateTime> potentialSlots = [];
      
      while (startTime.isBefore(endTime)) {
        final bool isPast = startTime.isBefore(nowWithBuffer);

        bool isOccupied = existingBookings.any((booking) {
          final bStart = booking.scheduledAt;
          final bEnd = bStart.add(Duration(minutes: booking.duration));
          final requestedEnd = startTime.add(Duration(minutes: serviceDuration));
          
          return startTime.isBefore(bEnd) && requestedEnd.isAfter(bStart);
        });

        if (!isPast && !isOccupied) {
          potentialSlots.add(startTime);
        }
        
        startTime = startTime.add(const Duration(minutes: 30));
      }
      _availableSlots = potentialSlots;
    } catch (e) {
      _errorMessage = "Nu am putut încărca orele: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> confirmBooking(BookingModel booking) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (booking.scheduledAt.isBefore(DateTime.now())) {
        _errorMessage = "Această oră tocmai a trecut. Te rugăm să alegi alta.";
        return false;
      }

      bool stillAvailable = await _bookingService.isSlotAvailable(booking.barberId, booking.scheduledAt);
      
      if (!stillAvailable) {
        _errorMessage = "Ne pare rău, acest interval tocmai a fost ocupat.";
        return false;
      }

      await _bookingService.createBooking(booking);
      
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = "Eroare la salvarea rezervării: $e";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}