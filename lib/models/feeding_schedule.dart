class FeedingSchedule {
  final String id;
  final String name; // e.g. "Morning", "Afternoon", "Evening"
  final String time; // "08:00 AM" or "08:00"
  final int hour; // 0 - 23
  final int minute; // 0 - 59
  final int durationSeconds; // Gate open duration
  final double targetQtyKg;
  final bool enabled;

  FeedingSchedule({
    required this.id,
    required this.name,
    required this.time,
    required this.hour,
    required this.minute,
    this.durationSeconds = 15,
    this.targetQtyKg = 1.20,
    required this.enabled,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'hour': hour,
      'minute': minute,
      'durationSeconds': durationSeconds,
      'targetQtyKg': targetQtyKg,
      'enabled': enabled,
    };
  }

  factory FeedingSchedule.fromMap(Map<dynamic, dynamic> map, String id) {
    return FeedingSchedule(
      id: id,
      name: map['name'] as String? ?? 'Feeding',
      time: map['time'] as String? ?? '08:00 AM',
      hour: map['hour'] as int? ?? 8,
      minute: map['minute'] as int? ?? 0,
      durationSeconds: map['durationSeconds'] as int? ?? 15,
      targetQtyKg: (map['targetQtyKg'] as num?)?.toDouble() ?? 1.20,
      enabled: map['enabled'] as bool? ?? true,
    );
  }

  FeedingSchedule copyWith({
    String? name,
    String? time,
    int? hour,
    int? minute,
    int? durationSeconds,
    double? targetQtyKg,
    bool? enabled,
  }) {
    return FeedingSchedule(
      id: id,
      name: name ?? this.name,
      time: time ?? this.time,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      targetQtyKg: targetQtyKg ?? this.targetQtyKg,
      enabled: enabled ?? this.enabled,
    );
  }
}
