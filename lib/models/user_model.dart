import 'package:book_my_look/models/barber_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final DateTime createdAt; 
  final BarberModel? barberDetails;
  final int loyaltyPoints;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    this.barberDetails,
    this.loyaltyPoints = 0,
  });

  UserModel copyWith({
  String? uid,
  String? name,
  String? email,
  String? phone,
  String? role,
  DateTime? createdAt,
  BarberModel? barberDetails,
  int? loyaltyPoints,
}) {
  return UserModel(
    uid: uid ?? this.uid, 
    name: name ?? this.name,
    email: email ?? this.email, 
    phone: phone ?? this.phone,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    barberDetails: barberDetails ?? this.barberDetails,
    loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
  );
}

  
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'client',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      barberDetails: data['barberDetails'] != null 
          ? BarberModel.fromMap(data['barberDetails'] as Map<String, dynamic>) 
          : null,
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'createdAt': createdAt, 
      'barberDetails': barberDetails?.toMap(),
      'loyaltyPoints': loyaltyPoints,
    };
  }
}