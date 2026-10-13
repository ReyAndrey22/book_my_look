import 'package:flutter/material.dart';
import 'package:book_my_look/models/chair_model.dart';
import 'package:book_my_look/models/user_model.dart';
import 'package:book_my_look/services/chair_service.dart';

class ChairViewModel extends ChangeNotifier {
  final ChairService _chairService = ChairService();

  Stream<List<ChairModel>> get chairsStream => _chairService.getChairsStream();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  
  Future<String?> addNewChair(String name) async {
    if (name.trim().isEmpty) return "Numele scaunului nu poate fi gol.";

    _isLoading = true;
    notifyListeners();

    try {
      
      final newChair = ChairModel(
        id: '', 
        name: name.trim(),
        assignedBarberId: null,
        assignedBarberName: null,
      );

      await _chairService.addChair(newChair);
      return null; 
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<String?> assignBarber(ChairModel chair, UserModel barber) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _chairService.assignBarberToChair(chair.id, barber);
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<String?> freeChair(ChairModel chair) async {
    if (chair.assignedBarberId == null) return null;

    _isLoading = true;
    notifyListeners();

    try {
      await _chairService.releaseChair(chair.id, chair.assignedBarberId!);
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}