class BarberModel {
  final List<String> serviceIds; 
  final double rating;
  final String bio;
  final int reviewsCount;
  final bool isActive;
  final int experienceYears;
  final String? chairId;

  BarberModel({
    this.serviceIds = const [], 
    this.rating = 5.0,
    this.bio = '',
    this.reviewsCount = 0,
    this.isActive = true,
    this.experienceYears = 0,
    this.chairId
  });

  factory BarberModel.fromMap(Map<String, dynamic> data) {
    return BarberModel(
      serviceIds: List<String>.from(data['serviceIds'] ?? []),
      rating: (data['rating'] ?? 5.0).toDouble(),
      bio: data['bio'] ?? '',
      reviewsCount: data['reviewsCount'] ?? 0,
      isActive: data['isActive'] ?? true,
      experienceYears: data['experienceYears'] ?? 0,
      chairId: data['chairId']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceIds': serviceIds,
      'rating': rating,
      'bio': bio,
      'reviewsCount': reviewsCount,
      'isActive': isActive,
      'experienceYears': experienceYears,
      'chairId': chairId
    };
  }
}