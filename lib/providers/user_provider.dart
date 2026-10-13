import 'package:flutter/material.dart';
import 'package:book_my_look/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void updateLoyaltyPoints(int delta) {
    if (_user != null) {
      _user = _user!.copyWith(loyaltyPoints: _user!.loyaltyPoints + delta);
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
