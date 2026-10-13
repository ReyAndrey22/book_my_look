import 'package:flutter/material.dart';
import 'package:book_my_look/services/auth_service.dart';
import 'package:book_my_look/services/user_service.dart'; 
import 'package:book_my_look/models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  Future<UserModel?> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      throw Exception("Te rugăm să completezi toate câmpurile.");
    }

    _isLoading = true;
    notifyListeners();

    try {
      final credential = await _authService.loginUser(email, password);
      final String uid = credential.user!.uid;
      final userData = await _userService.getUserData(uid);

      if (userData == null) {
        throw Exception("Nu am găsit datele profilului în baza de date.");
      }

      return userData; 
    } catch (e) {
      
      rethrow; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}