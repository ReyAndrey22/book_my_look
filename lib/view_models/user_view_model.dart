import 'package:flutter/material.dart';
import 'package:book_my_look/models/user_model.dart';
import 'package:book_my_look/services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<List<UserModel>> get usersStream => _userService.getAllUsers();

  Future<String?> changeUserRole(String uid, String currentRole) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userService.toggleUserRole(uid, currentRole);
      return null; 
    } catch (e) {
      return e.toString(); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}