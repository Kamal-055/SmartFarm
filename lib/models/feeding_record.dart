class FeedingRecord {
  final String id;
  final String title;
  final DateTime timestamp;
  final String type; // "Manual" or "Scheduled"
  final String status; // "Completed", "Failed", "Interrupted"
  final int durationSeconds;

  FeedingRecord({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.type,
    required this.status,
    required this.durationSeconds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type,
      'status': status,
      'durationSeconds': durationSeconds,
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
    );
  }
}
