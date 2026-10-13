import 'package:flutter/material.dart';
import 'package:book_my_look/models/service_model.dart';
import 'package:book_my_look/services/service_service.dart';
import 'package:book_my_look/services/user_service.dart';

class ServiceViewModel extends ChangeNotifier {
  final ServiceService _serviceService = ServiceService();
  final UserService _userService = UserService();

  Stream<List<ServiceModel>> get servicesStream => _serviceService.getAllServices();

  Future<void> createService(String name, String description, double price, int duration, int loyaltyPoints) async {
    final newService = ServiceModel(
      id: '',
      name: name,
      description: description,
      price: price,
      duration: duration,
      loyaltyPoints: loyaltyPoints,
    );

    final String newServiceId = await _serviceService.addService(newService);

    await _userService.addServiceToAllBarbers(newServiceId);
  }
  
  Future<String?> removeService(String serviceId) async {
     try {
      await _serviceService.deleteService(serviceId);
      await _userService.removeServiceFromAllBarbers(serviceId);
      return null; 
      } catch (e) {
        return e.toString();
        }
  }

  Future<String?> editService(ServiceModel service) async {
    try {
      await _serviceService.updateService(service);
      return null; 
    } catch (e) {
      return e.toString(); 
    }
  }

}