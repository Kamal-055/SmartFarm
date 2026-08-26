enum AlertType { info, warning, critical }

class AlertModel {
  final String id;
  final String title;
  final String message;
  final AlertType type;
  final DateTime timestamp;
  final bool read;

  AlertModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.read,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'read': read,
    };
  }

  factory AlertModel.fromMap(Map<dynamic, dynamic> map, String id) {
    final typeStr = (map['type'] as String? ?? 'info').toLowerCase();
    AlertType parsedType;
    if (typeStr == 'critical') {
      parsedType = AlertType.critical;
    } else if (typeStr == 'warning') {
      parsedType = AlertType.warning;
    } else {
      parsedType = AlertType.info;
    }

    return AlertModel(
      id: id,
      title: map['title'] as String? ?? 'Notice',
      message: map['message'] as String? ?? '',
      type: parsedType,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch),
      read: map['read'] as bool? ?? false,
    );
  }

  AlertModel copyWith({bool? read}) {
    return AlertModel(
      id: id,
      title: title,
      message: message,
      type: type,
      timestamp: timestamp,
      read: read ?? this.read,
    );
  }
}
