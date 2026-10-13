import 'package:flutter/material.dart';
import 'package:book_my_look/services/barber_service.dart';
import 'package:book_my_look/services/user_service.dart';
import 'package:book_my_look/providers/user_provider.dart';
import 'package:book_my_look/models/user_model.dart';

class BarberViewModel extends ChangeNotifier {
  final BarberService _barberService = BarberService();
  final UserService _userService = UserService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Stream<List<UserModel>> get availableBarbersStream => _barberService.getAvailableBarbers();
  
  Future<void> toggleOnlineStatus(String uid, bool newStatus, UserProvider userProvider) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _barberService.updateIsActive(uid, newStatus);
      
      final updatedUser = await _userService.getUserData(uid);
      if (updatedUser != null) {
        userProvider.setUser(updatedUser);
      }
    } catch (e) {
      _errorMessage = "Eroare la update: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}