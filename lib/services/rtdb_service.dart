import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/app_logger.dart';
import '../models/device_model.dart';
import '../models/farm_model.dart';
import '../models/user_model.dart';
import '../models/feeding_schedule.dart';
import '../models/feeding_record.dart';
import '../models/alert_model.dart';

class RealtimeDatabaseService {
  FirebaseDatabase? get _db {
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseDatabase.instance;
      }
    } catch (_) {}
    return null;
  }

  // Stream device status from Firebase
  Stream<DeviceModel?> streamDevice(String deviceId) {
    try {
      final db = _db;
      if (db != null) {
        AppLogger.i('RTDBService', 'Subscribing to device path: ${AppConstants.pathDevices}/$deviceId');
        return db.ref('${AppConstants.pathDevices}/$deviceId').onValue.map((event) {
          if (event.snapshot.value == null) return null;
          final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
          return DeviceModel.fromMap(data, deviceId);
        });
      }
    } catch (e) {
      AppLogger.e('RTDBService', 'Error streaming device', e);
    }
    return Stream.value(null);
  }

  // Stream schedules
  Stream<List<FeedingSchedule>> streamSchedules(String deviceId) {
    try {
      final db = _db;
      if (db != null) {
        return db.ref('${AppConstants.pathDevices}/$deviceId/schedules').onValue.map((event) {
          if (event.snapshot.value == null) return [];
          final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
          final List<FeedingSchedule> list = [];
          data.forEach((key, val) {
            if (val is Map) {
              list.add(FeedingSchedule.fromMap(val, key.toString()));
            }
          });
          list.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
          return list;
        });
      }
    } catch (e) {
      AppLogger.e('RTDBService', 'Error streaming schedules', e);
    }
    return Stream.value([]);
  }

  // Stream history records
  Stream<List<FeedingRecord>> streamHistory(String deviceId) {
    try {
      final db = _db;
      if (db != null) {
        return db.ref('${AppConstants.pathDevices}/$deviceId/history').onValue.map((event) {
          if (event.snapshot.value == null) return [];
          final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
          final List<FeedingRecord> list = [];
          data.forEach((key, val) {
            if (val is Map) {
              list.add(FeedingRecord.fromMap(val, key.toString()));
            }
          });
          list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return list;
        });
      }
    } catch (e) {
      AppLogger.e('RTDBService', 'Error streaming history', e);
    }
    return Stream.value([]);
  }

  // Stream alerts
  Stream<List<AlertModel>> streamAlerts(String deviceId) {
    try {
      final db = _db;
      if (db != null) {
        return db.ref('${AppConstants.pathDevices}/$deviceId/alerts').onValue.map((event) {
          if (event.snapshot.value == null) return [];
          final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
          final List<AlertModel> list = [];
          data.forEach((key, val) {
            if (val is Map) {
              list.add(AlertModel.fromMap(val, key.toString()));
            }
          });
          list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return list;
        });
      }
    } catch (e) {
      AppLogger.e('RTDBService', 'Error streaming alerts', e);
    }
    return Stream.value([]);
  }

  // Send Gate Command (OPEN / CLOSE)
  Future<void> sendGateCommand({
    required String deviceId,
    required String command,
  }) async {
    final db = _db;
    if (db == null) return;

    final commandId = 'CMD_${DateTime.now().millisecondsSinceEpoch}';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    AppLogger.i('RTDBService', 'Sending gate command $command ($commandId) to $deviceId');
    final gateRef = db.ref('${AppConstants.pathDevices}/$deviceId/gate');
    
    await gateRef.update({
      'command': command,
      'commandId': commandId,
      'lastCommand': command,
      'lastCommandTimestamp': timestamp,
      'status': command == 'OPEN' ? 'OPENING' : 'CLOSING',
    });
  }

  // Save User profile
  Future<void> saveUser(UserModel user) async {
    final db = _db;
    if (db != null) {
      await db.ref('${AppConstants.pathUsers}/${user.uid}').set(user.toMap());
    }
  }

  // Save Farm profile
  Future<void> saveFarm(FarmModel farm) async {
    final db = _db;
    if (db != null) {
      await db.ref('${AppConstants.pathFarms}/${farm.id}').set(farm.toMap());
    }
  }

  // Add / Update Schedule
  Future<void> saveSchedule(String deviceId, FeedingSchedule schedule) async {
    final db = _db;
    if (db != null) {
      await db.ref('${AppConstants.pathDevices}/$deviceId/schedules/${schedule.id}').set(schedule.toMap());
    }
  }

  // Delete Schedule
  Future<void> deleteSchedule(String deviceId, String scheduleId) async {
    final db = _db;
    if (db != null) {
      await db.ref('${AppConstants.pathDevices}/$deviceId/schedules/$scheduleId').remove();
    }
  }

  // Add Feeding History Record
  Future<void> addHistoryRecord(String deviceId, FeedingRecord record) async {
    final db = _db;
    if (db != null) {
      await db.ref('${AppConstants.pathDevices}/$deviceId/history/${record.id}').set(record.toMap());
    }
  }

  // Mark Alert as Read
  Future<void> markAlertRead(String deviceId, String alertId) async {
    final db = _db;
    if (db != null) {
      await db.ref('${AppConstants.pathDevices}/$deviceId/alerts/$alertId/read').set(true);
    }
  }

  // Clear Alerts
  Future<void> clearAlerts(String deviceId) async {
    final db = _db;
    if (db != null) {
      await db.ref('${AppConstants.pathDevices}/$deviceId/alerts').remove();
    }
  }
}
