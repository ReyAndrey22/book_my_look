class ChairModel {
  final String id;
  final String name; 
  final String? assignedBarberId; 
  final String? assignedBarberName; 

  ChairModel({
    required this.id,
    required this.name,
    this.assignedBarberId,
    this.assignedBarberName,
  });


  factory ChairModel.fromMap(Map<String, dynamic> data, String docId) {
    return ChairModel(
      id: docId,
      name: data['name'] ?? '',
      assignedBarberId: data['assignedBarberId'],
      assignedBarberName: data['assignedBarberName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'assignedBarberId': assignedBarberId,
      'assignedBarberName': assignedBarberName,
    };
  }

  ChairModel copyWith({
    String? id,
    String? name,
    String? assignedBarberId,
    String? assignedBarberName,
  }) {
    return ChairModel(
      id: id ?? this.id,
      name: name ?? this.name,
      assignedBarberId: assignedBarberId ?? this.assignedBarberId,
      assignedBarberName: assignedBarberName ?? this.assignedBarberName,
    );
  }
}