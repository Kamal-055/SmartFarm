import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/feeding_record.dart';

enum HistoryFilter { today, thisWeek, thisMonth, all }

class HistoryProvider with ChangeNotifier {
  static const String _keyHistoryList = 'fodder_history_records';

  List<FeedingRecord> _allRecords = [];
  HistoryFilter _currentFilter = HistoryFilter.today;
  final bool _isLoading = false;

  List<FeedingRecord> get records => _filteredRecords();
  HistoryFilter get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;

  // Calculated Metrics from actual history records
  double get todayDispensedKgSum {
    final now = DateTime.now();
    return _allRecords.where((r) {
      return r.timestamp.year == now.year &&
          r.timestamp.month == now.month &&
          r.timestamp.day == now.day &&
          r.status == 'Completed';
    }).fold(0.0, (sum, r) => sum + r.actualQuantityKg);
  }

  int get todayCompletedCount {
    final now = DateTime.now();
    return _allRecords.where((r) {
      return r.timestamp.year == now.year &&
          r.timestamp.month == now.month &&
          r.timestamp.day == now.day &&
          r.status == 'Completed';
    }).length;
  }

  int get todayFlowAssistedCount {
    final now = DateTime.now();
    return _allRecords.where((r) {
      return r.timestamp.year == now.year &&
          r.timestamp.month == now.month &&
          r.timestamp.day == now.day &&
          r.flowAssisted;
    }).length;
  }

  HistoryProvider() {
    _loadFromPreferences();
  }

  void initHistory([String? deviceId, bool? isMockMode]) {
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_keyHistoryList);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        _allRecords = decoded.map((m) => FeedingRecord.fromMap(m, m['id'] ?? '')).toList();
      } else {
        _initDefaultHistory();
      }
    } catch (_) {
      _initDefaultHistory();
    }
    notifyListeners();
  }

  void _initDefaultHistory() {
    final now = DateTime.now();
    _allRecords = [
      FeedingRecord(
        id: 'REC_001',
        title: 'Morning Feeding',
        timestamp: DateTime(now.year, now.month, now.day, 8, 0),
        type: 'Scheduled',
        status: 'Completed',
        durationSeconds: 15,
        targetQuantityKg: 1.20,
        actualQuantityKg: 1.18,
        remainingFodderKg: 8.82,
      ),
      FeedingRecord(
        id: 'REC_002',
        title: 'Afternoon Feeding',
        timestamp: DateTime(now.year, now.month, now.day, 13, 0),
        type: 'Scheduled',
        status: 'Completed',
        durationSeconds: 20,
        targetQuantityKg: 0.80,
        actualQuantityKg: 0.78,
        remainingFodderKg: 8.04,
      ),
    ];
  }

  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final maps = _allRecords.map((r) => r.toMap()).toList();
      await prefs.setString(_keyHistoryList, jsonEncode(maps));
    } catch (_) {}
  }

  Future<void> addRecord(FeedingRecord record) async {
    _allRecords.insert(0, record);
    await _saveToPreferences();
    notifyListeners();
  }

  void setFilter(HistoryFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  List<FeedingRecord> _filteredRecords() {
    final now = DateTime.now();
    switch (_currentFilter) {
      case HistoryFilter.today:
        return _allRecords.where((r) {
          return r.timestamp.year == now.year &&
              r.timestamp.month == now.month &&
              r.timestamp.day == now.day;
        }).toList();
      case HistoryFilter.thisWeek:
        final weekAgo = now.subtract(const Duration(days: 7));
        return _allRecords.where((r) => r.timestamp.isAfter(weekAgo)).toList();
      case HistoryFilter.thisMonth:
        return _allRecords.where((r) {
          return r.timestamp.year == now.year && r.timestamp.month == now.month;
        }).toList();
      case HistoryFilter.all:
        return _allRecords;
    }
  }
}
