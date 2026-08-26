class FarmModel {
  final String id;
  final String name;
  final String ownerId;
  final int cattleCount;
  final String location;
  final DateTime createdAt;

  FarmModel({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.cattleCount,
    this.location = '',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ownerId': ownerId,
      'cattleCount': cattleCount,
      'location': location,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory FarmModel.fromMap(Map<String, dynamic> map, String id) {
    return FarmModel(
      id: id,
      name: map['name'] ?? 'Green Valley Farm',
      ownerId: map['ownerId'] ?? '',
      cattleCount: map['cattleCount'] ?? 10,
      location: map['location'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  FarmModel copyWith({
    String? name,
    int? cattleCount,
    String? location,
  }) {
    return FarmModel(
      id: id,
      name: name ?? this.name,
      ownerId: ownerId,
      cattleCount: cattleCount ?? this.cattleCount,
      location: location ?? this.location,
      createdAt: createdAt,
    );
  }
}
