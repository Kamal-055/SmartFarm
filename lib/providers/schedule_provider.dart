import 'dart:async';
import 'package:flutter/material.dart';
import '../models/feeding_schedule.dart';
import '../services/rtdb_service.dart';
import '../core/utils/app_logger.dart';

class ScheduleProvider with ChangeNotifier {
  final RealtimeDatabaseService _rtdbService = RealtimeDatabaseService();

  List<FeedingSchedule> _schedules = [];
  StreamSubscription<List<FeedingSchedule>>? _sub;
  bool _isLoading = false;

  List<FeedingSchedule> get schedules => _schedules;
  bool get isLoading => _isLoading;

  void initSchedules(String deviceId, bool isMockMode) {
    _sub?.cancel();

    if (isMockMode) {
      _schedules = [
        FeedingSchedule(
          id: 'SCH_001',
          name: 'Morning Feeding',
          time: '08:00 AM',
          hour: 8,
          minute: 0,
          durationSeconds: 15,
          enabled: true,
        ),
        FeedingSchedule(
          id: 'SCH_002',
          name: 'Afternoon Feeding',
          time: '01:00 PM',
          hour: 13,
          minute: 0,
          durationSeconds: 20,
          enabled: true,
        ),
        FeedingSchedule(
          id: 'SCH_003',
          name: 'Evening Feeding',
          time: '06:00 PM',
          hour: 18,
          minute: 0,
          durationSeconds: 15,
          enabled: true,
        ),
      ];
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = true;
      notifyListeners();
      _sub = _rtdbService.streamSchedules(deviceId).listen((list) {
        _schedules = list;
        _isLoading = false;
        notifyListeners();
      }, onError: (e) {
        AppLogger.e('ScheduleProvider', 'Error streaming schedules', e);
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  Future<void> addSchedule({
    required String deviceId,
    required String name,
    required TimeOfDay timeOfDay,
    required int durationSeconds,
    required bool isMockMode,
  }) async {
    final id = 'SCH_${DateTime.now().millisecondsSinceEpoch}';
    final hourStr = timeOfDay.hourOfPeriod == 0 ? '12' : timeOfDay.hourOfPeriod.toString().padLeft(2, '0');
    final minStr = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    final timeFormatted = '$hourStr:$minStr $period';

    final schedule = FeedingSchedule(
      id: id,
      name: name,
      time: timeFormatted,
      hour: timeOfDay.hour,
      minute: timeOfDay.minute,
      durationSeconds: durationSeconds,
      enabled: true,
    );

    if (isMockMode) {
      _schedules.add(schedule);
      _schedules.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
      notifyListeners();
    } else {
      await _rtdbService.saveSchedule(deviceId, schedule);
    }
  }

  Future<void> toggleSchedule({
    required String deviceId,
    required FeedingSchedule schedule,
    required bool isMockMode,
  }) async {
    final updated = schedule.copyWith(enabled: !schedule.enabled);

    if (isMockMode) {
      final index = _schedules.indexWhere((s) => s.id == schedule.id);
      if (index != -1) {
        _schedules[index] = updated;
        notifyListeners();
      }
    } else {
      await _rtdbService.saveSchedule(deviceId, updated);
    }
  }

  Future<void> deleteSchedule({
    required String deviceId,
    required String scheduleId,
    required bool isMockMode,
  }) async {
    if (isMockMode) {
      _schedules.removeWhere((s) => s.id == scheduleId);
      notifyListeners();
    } else {
      await _rtdbService.deleteSchedule(deviceId, scheduleId);
    }
  }

  FeedingSchedule? get nextUpcomingSchedule {
    final enabledList = _schedules.where((s) => s.enabled).toList();
    if (enabledList.isEmpty) return null;

    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;

    for (final sch in enabledList) {
      final schMinutes = sch.hour * 60 + sch.minute;
      if (schMinutes > nowMinutes) {
        return sch;
      }
    }
    // Return first schedule for tomorrow if all passed today
    return enabledList.first;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
