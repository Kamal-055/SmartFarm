enum GateState { closed, opening, open, closing, error }

enum FeedLevelStatus { high, good, low, empty }

class GateStatus {
  final GateState state;
  final String command; // "OPEN" or "CLOSE"
  final String lastCommand;
  final int lastCommandTimestamp;
  final String? errorMessage;

  GateStatus({
    required this.state,
    required this.command,
    required this.lastCommand,
    required this.lastCommandTimestamp,
    this.errorMessage,
  });

  bool get isOperating => state == GateState.opening || state == GateState.closing;
  bool get isOpen => state == GateState.open;
  bool get isClosed => state == GateState.closed;

  String get displayStatus {
    switch (state) {
      case GateState.open:
        return "Gate Open";
      case GateState.closed:
        return "Gate Closed";
      case GateState.opening:
        return "Opening gate...";
      case GateState.closing:
        return "Closing gate...";
      case GateState.error:
        return errorMessage ?? "Gate Error";
    }
  }

  factory GateStatus.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return GateStatus(
        state: GateState.closed,
        command: "CLOSE",
        lastCommand: "CLOSE",
        lastCommandTimestamp: 0,
      );
    }

    final statusStr = (map['status'] as String? ?? 'CLOSED').toUpperCase();
    GateState parsedState;
    switch (statusStr) {
      case 'OPEN':
        parsedState = GateState.open;
        break;
      case 'OPENING':
        parsedState = GateState.opening;
        break;
      case 'CLOSING':
        parsedState = GateState.closing;
        break;
      case 'ERROR':
        parsedState = GateState.error;
        break;
      case 'CLOSED':
      default:
        parsedState = GateState.closed;
        break;
    }

    return GateStatus(
      state: parsedState,
      command: map['command'] as String? ?? 'CLOSE',
      lastCommand: map['lastCommand'] as String? ?? 'CLOSE',
      lastCommandTimestamp: map['lastCommandTimestamp'] as int? ?? 0,
      errorMessage: map['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': state.name.toUpperCase(),
      'command': command,
      'lastCommand': lastCommand,
      'lastCommandTimestamp': lastCommandTimestamp,
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }
}

class FeedStatus {
  final int levelPercentage; // 0 to 100
  final FeedLevelStatus status;

  FeedStatus({
    required this.levelPercentage,
    required this.status,
  });

  String get displayText {
    switch (status) {
      case FeedLevelStatus.high:
        return "HIGH";
      case FeedLevelStatus.good:
        return "GOOD";
      case FeedLevelStatus.low:
        return "LOW";
      case FeedLevelStatus.empty:
        return "EMPTY";
    }
  }

  factory FeedStatus.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return FeedStatus(levelPercentage: 78, status: FeedLevelStatus.good);
    }

    final level = (map['level'] as num? ?? 78).toInt();
    FeedLevelStatus parsedStatus;
    if (level > 80) {
      parsedStatus = FeedLevelStatus.high;
    } else if (level > 40) {
      parsedStatus = FeedLevelStatus.good;
    } else if (level > 15) {
      parsedStatus = FeedLevelStatus.low;
    } else {
      parsedStatus = FeedLevelStatus.empty;
    }

    return FeedStatus(
      levelPercentage: level,
      status: parsedStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'level': levelPercentage,
      'status': displayText,
    };
  }
}

class SystemStatus {
  final bool online;
  final int lastSeen; // Epoch millis
  final String firmwareVersion;

  SystemStatus({
    required this.online,
    required this.lastSeen,
    required this.firmwareVersion,
  });

  bool isHeartbeatAlive(int timeoutSeconds) {
    if (lastSeen == 0) return false;
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - lastSeen) <= (timeoutSeconds * 1000);
  }

  factory SystemStatus.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return SystemStatus(
        online: false,
        lastSeen: 0,
        firmwareVersion: "v1.0.0",
      );
    }

    return SystemStatus(
      online: map['online'] as bool? ?? false,
      lastSeen: map['lastSeen'] as int? ?? 0,
      firmwareVersion: map['firmwareVersion'] as String? ?? "v1.0.0",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'online': online,
      'lastSeen': lastSeen,
      'firmwareVersion': firmwareVersion,
    };
  }
}

class DeviceModel {
  final String deviceId;
  final String farmId;
  final String name;
  final GateStatus gate;
  final FeedStatus feed;
  final SystemStatus system;

  DeviceModel({
    required this.deviceId,
    required this.farmId,
    required this.name,
    required this.gate,
    required this.feed,
    required this.system,
  });

  bool isDeviceOnline(int timeoutSeconds) => system.isHeartbeatAlive(timeoutSeconds);

  factory DeviceModel.fromMap(Map<dynamic, dynamic>? map, String deviceId) {
    if (map == null) {
      return DeviceModel(
        deviceId: deviceId,
        farmId: 'FARM_001',
        name: 'Fodder Dispenser 1',
        gate: GateStatus(state: GateState.closed, command: 'CLOSE', lastCommand: 'CLOSE', lastCommandTimestamp: 0),
        feed: FeedStatus(levelPercentage: 78, status: FeedLevelStatus.good),
        system: SystemStatus(online: true, lastSeen: DateTime.now().millisecondsSinceEpoch, firmwareVersion: 'v1.0.0'),
      );
    }

    return DeviceModel(
      deviceId: deviceId,
      farmId: map['farmId'] as String? ?? 'FARM_001',
      name: map['name'] as String? ?? 'Fodder Dispenser 1',
      gate: GateStatus.fromMap(map['gate'] as Map?),
      feed: FeedStatus.fromMap(map['feed'] as Map?),
      system: SystemStatus.fromMap(map['system'] as Map?),
    );
  }
}
