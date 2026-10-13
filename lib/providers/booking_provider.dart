import 'package:flutter/material.dart';
import 'package:book_my_look/models/user_model.dart';
import 'package:book_my_look/models/service_model.dart';
import 'package:book_my_look/models/user_voucher_model.dart';

class BookingProvider extends ChangeNotifier {
  ServiceModel? _selectedService;
  UserModel? _selectedBarber;
  UserVoucherModel? _selectedVoucher;

  ServiceModel? get selectedService => _selectedService;
  UserModel? get selectedBarber => _selectedBarber;
  UserVoucherModel? get selectedVoucher => _selectedVoucher;

  String? get selectedServiceId => _selectedService?.id;
  String? get selectedBarberId => _selectedBarber?.uid;

  void selectVoucher(UserVoucherModel? voucher) {
    if (_selectedVoucher?.id == voucher?.id) {
      _selectedVoucher = null;
    } else {
      _selectedVoucher = voucher;
    }
    notifyListeners();
  }

  void selectService(ServiceModel service) {
    if (_selectedService?.id == service.id) {
      _selectedService = null;
      _selectedVoucher = null;
    } else {
      _selectedService = service;
      
      if (_selectedBarber != null) {
        bool supportsNewService = _selectedBarber!.barberDetails?.serviceIds.contains(service.id) ?? false;
        if (!supportsNewService) {
          _selectedBarber = null; 
        }
      }
      
      if (_selectedVoucher != null && _selectedVoucher!.serviceId != null) {
        if (_selectedVoucher!.serviceId != service.id) {
          _selectedVoucher = null;
        }
      }
    }
    notifyListeners();
  }

  void selectBarber(UserModel barber) {
    if (_selectedBarber?.uid == barber.uid) {
      _selectedBarber = null;
    } else {
      _selectedBarber = barber;
      
      if (_selectedService != null) {
        bool providesCurrentService = barber.barberDetails?.serviceIds.contains(_selectedService!.id) ?? false;
        if (!providesCurrentService) {
          _selectedService = null; 
          _selectedVoucher = null;
        }
      }
    }
    notifyListeners();
  }

  bool isBarberEnabled(UserModel barber) {
    if (_selectedService == null) return true;
    return barber.barberDetails?.serviceIds.contains(_selectedService!.id) ?? false;
  }

  bool isServiceEnabled(ServiceModel service) {
    if (_selectedBarber == null) return true;
    return _selectedBarber!.barberDetails?.serviceIds.contains(service.id) ?? false;
  }

  bool get canContinue => _selectedService != null && _selectedBarber != null;

  void resetBooking() {
    _selectedService = null;
    _selectedBarber = null;
    _selectedVoucher = null;
    notifyListeners();
  }
}