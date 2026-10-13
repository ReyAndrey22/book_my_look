class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration;
  final int loyaltyPoints;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    this.loyaltyPoints = 0,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> data, String docId) {
    return ServiceModel(
      id: docId, 
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      duration: data['duration'] ?? 30,
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'loyaltyPoints': loyaltyPoints,
    };
  }
}