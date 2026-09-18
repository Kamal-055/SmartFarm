class FeedingRecord {
  final String id;
  final String title;
  final DateTime timestamp;
  final String type; // "Manual" or "Scheduled"
  final String status; // "Completed", "Failed", "Interrupted"
  final int durationSeconds;
  final double targetQuantityKg;
  final double actualQuantityKg;
  final double remainingFodderKg;
  final bool flowAssisted;

  FeedingRecord({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.type,
    required this.status,
    required this.durationSeconds,
    this.targetQuantityKg = 1.20,
    this.actualQuantityKg = 1.18,
    this.remainingFodderKg = 8.82,
    this.flowAssisted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type,
      'status': status,
      'durationSeconds': durationSeconds,
      'targetQuantityKg': targetQuantityKg,
      'actualQuantityKg': actualQuantityKg,
      'remainingFodderKg': remainingFodderKg,
      'flowAssisted': flowAssisted,
    };
  }

  factory FeedingRecord.fromMap(Map<dynamic, dynamic> map, String id) {
    return FeedingRecord(
      id: id,
      title: map['title'] as String? ?? 'Feeding',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch),
      type: map['type'] as String? ?? 'Manual',
      status: map['status'] as String? ?? 'Completed',
      durationSeconds: map['durationSeconds'] as int? ?? 15,
      targetQuantityKg: (map['targetQuantityKg'] as num?)?.toDouble() ?? 1.20,
      actualQuantityKg: (map['actualQuantityKg'] as num?)?.toDouble() ?? 1.18,
      remainingFodderKg: (map['remainingFodderKg'] as num?)?.toDouble() ?? 8.82,
      flowAssisted: map['flowAssisted'] as bool? ?? false,
    );
  }
}
