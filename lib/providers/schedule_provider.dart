import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/feeding_schedule.dart';

class ScheduleProvider with ChangeNotifier {
  static const String _keyScheduleList = 'fodder_schedules_list';

  List<FeedingSchedule> _schedules = [];
  final bool _isLoading = false;

  List<FeedingSchedule> get schedules => _schedules;
  bool get isLoading => _isLoading;

  ScheduleProvider() {
    _loadFromPreferences();
  }

  void initSchedules([String? deviceId, bool? isMockMode]) {
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_keyScheduleList);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        _schedules = decoded.map((m) => FeedingSchedule.fromMap(m, m['id'] ?? '')).toList();
      } else {
        _initDefaultSchedules();
      }
    } catch (_) {
      _initDefaultSchedules();
    }
    notifyListeners();
  }

  void _initDefaultSchedules() {
    _schedules = [
      FeedingSchedule(
        id: 'SCH_001',
        name: 'Morning Feed',
        time: '08:00 AM',
        hour: 8,
        minute: 0,
        targetQtyKg: 1.20,
        enabled: true,
      ),
      FeedingSchedule(
        id: 'SCH_002',
        name: 'Afternoon Feed',
        time: '01:00 PM',
        hour: 13,
        minute: 0,
        targetQtyKg: 0.80,
        enabled: true,
      ),
      FeedingSchedule(
        id: 'SCH_003',
        name: 'Evening Feed',
        time: '06:00 PM',
        hour: 18,
        minute: 0,
        targetQtyKg: 1.40,
        enabled: true,
      ),
    ];
  }

  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final maps = _schedules.map((s) => s.toMap()).toList();
      await prefs.setString(_keyScheduleList, jsonEncode(maps));
    } catch (_) {}
  }

  Future<void> addSchedule({
    String? deviceId,
    required String name,
    required TimeOfDay timeOfDay,
    int durationSeconds = 15,
    bool isMockMode = true,
    double targetQtyKg = 1.20,
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
      targetQtyKg: targetQtyKg,
      enabled: true,
    );

    _schedules.add(schedule);
    _schedules.sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> toggleSchedule([dynamic arg1, dynamic arg2, dynamic arg3]) async {
    FeedingSchedule? target;
    if (arg1 is FeedingSchedule) {
      target = arg1;
    } else if (arg2 is FeedingSchedule) {
      target = arg2;
    }

    if (target != null) {
      final index = _schedules.indexWhere((s) => s.id == target!.id);
      if (index != -1) {
        _schedules[index] = target.copyWith(enabled: !target.enabled);
        await _saveToPreferences();
        notifyListeners();
      }
    }
  }

  Future<void> deleteSchedule([dynamic arg1, dynamic arg2, dynamic arg3]) async {
    String? idToRemove;
    if (arg1 is String && !arg1.startsWith('DEV')) {
      idToRemove = arg1;
    } else if (arg2 is String) {
      idToRemove = arg2;
    } else if (arg1 is String) {
      idToRemove = arg1;
    }

    if (idToRemove != null) {
      _schedules.removeWhere((s) => s.id == idToRemove);
      await _saveToPreferences();
      notifyListeners();
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
    return enabledList.first;
  }
}
