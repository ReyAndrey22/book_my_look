import 'package:book_my_look/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:book_my_look/models/user_model.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

  
  Future<String?> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      return "Te rugăm să completezi toate câmpurile.";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return "Introdu o adresă de email validă.";
    }

    if (phone.length != 10) {
      return "Numărul de telefon trebuie să aibă 10 cifre.";
    }

    if (password.length < 6) {
      return "Parola trebuie să aibă cel puțin 6 caractere.";
    }
    
    if (password != confirmPassword) {
      return "Parolele nu coincid!";
    }

    _isLoading = true;
    notifyListeners(); 

    try {
      UserModel newUser = UserModel(
        uid: '', 
        name: name,
        email: email,
        phone: phone,
        role: 'client',
        createdAt: DateTime.now(),
      );

      await _authService.registerUser(newUser, password);
      clearFields();
      return null; 
    } catch (e) {
      return e.toString(); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}