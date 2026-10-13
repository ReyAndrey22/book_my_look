import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { confirmed, inProgress, completed, cancelled, noShow }
enum PaymentMethod { cash, card }

class BookingModel {
  final String id;
  final String clientId;
  final String clientName;
  final String clientPhone;
  final String serviceId;
  final String serviceName;
  final int duration;
  final double priceAtBooking;
  final String barberId;
  final String barberName;
  final DateTime scheduledAt;
  final BookingStatus status;
  final PaymentMethod paymentMethod;
  bool isPaid;
  final int earnedPoints;

  BookingModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    required this.serviceId,
    required this.serviceName,
    required this.duration,
    required this.priceAtBooking,
    required this.barberId,
    required this.barberName,
    required this.scheduledAt,
    required this.paymentMethod,
    this.isPaid = false,
    this.status = BookingStatus.confirmed,
    this.earnedPoints = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'clientPhone': clientPhone,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'duration': duration,
      'priceAtBooking': priceAtBooking,
      'barberId': barberId,
      'barberName': barberName,
      'scheduledAt': Timestamp.fromDate(scheduledAt), 
      'paymentMethod': paymentMethod.name,
      'isPaid': isPaid,
      'status': status.name,
      'earnedPoints': earnedPoints,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> data, String docId) {
    return BookingModel(
      id: docId,
      clientId: data['clientId'] ?? '',
      clientName: data['clientName'] ?? '',
      clientPhone: data['clientPhone'] ?? '',
      serviceId: data['serviceId'] ?? '',
      serviceName: data['serviceName'] ?? '',
      duration: data['duration'] ?? 0,
      priceAtBooking: (data['priceAtBooking'] ?? 0.0).toDouble(),
      barberId: data['barberId'] ?? '',
      barberName: data['barberName'] ?? '',
      scheduledAt: (data['scheduledAt'] as Timestamp).toDate(),
      paymentMethod: PaymentMethod.values.byName(data['paymentMethod'] ?? 'cash'),
      isPaid: data['isPaid'] ?? false,
      status: BookingStatus.values.byName(data['status'] ?? 'confirmed'),
      earnedPoints: data['earnedPoints'] ?? 0,
    );
  }

  BookingModel copyWith({
  String? id,
  String? clientId,
  String? clientName,
  String? clientPhone,
  String? serviceId,
  String? serviceName,
  int? duration,
  double? priceAtBooking,
  String? barberId,
  String? barberName,
  DateTime? scheduledAt,
  BookingStatus? status,
  PaymentMethod? paymentMethod,
  bool? isPaid,
  int? earnedPoints,
}) {
  return BookingModel(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    clientName: clientName ?? this.clientName,
    clientPhone: clientPhone ?? this.clientPhone,
    serviceId: serviceId ?? this.serviceId,
    serviceName: serviceName ?? this.serviceName,
    duration: duration ?? this.duration,
    priceAtBooking: priceAtBooking ?? this.priceAtBooking,
    barberId: barberId ?? this.barberId,
    barberName: barberName ?? this.barberName,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    status: status ?? this.status,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    isPaid: isPaid ?? this.isPaid,
    earnedPoints: earnedPoints ?? this.earnedPoints,
  );
}
}