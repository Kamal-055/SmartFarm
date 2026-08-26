import 'dart:async';
import 'package:flutter/material.dart';
import '../models/feeding_record.dart';
import '../services/rtdb_service.dart';
import '../core/utils/app_logger.dart';

enum HistoryFilter { today, thisWeek, thisMonth, all }

class HistoryProvider with ChangeNotifier {
  final RealtimeDatabaseService _rtdbService = RealtimeDatabaseService();

  List<FeedingRecord> _allRecords = [];
  HistoryFilter _currentFilter = HistoryFilter.today;
  StreamSubscription<List<FeedingRecord>>? _sub;
  bool _isLoading = false;

  List<FeedingRecord> get records => _filteredRecords();
  HistoryFilter get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;

  int get todayCompletedCount {
    final now = DateTime.now();
    return _allRecords.where((r) {
      return r.timestamp.year == now.year &&
          r.timestamp.month == now.month &&
          r.timestamp.day == now.day &&
          r.status == 'Completed';
    }).length;
  }

  void initHistory(String deviceId, bool isMockMode) {
    _sub?.cancel();

    if (isMockMode) {
      final now = DateTime.now();
      _allRecords = [
        FeedingRecord(
          id: 'REC_001',
          title: 'Morning Feeding',
          timestamp: DateTime(now.year, now.month, now.day, 8, 0),
          type: 'Scheduled',
          status: 'Completed',
          durationSeconds: 15,
        ),
        FeedingRecord(
          id: 'REC_002',
          title: 'Afternoon Feeding',
          timestamp: DateTime(now.year, now.month, now.day, 13, 0),
          type: 'Scheduled',
          status: 'Completed',
          durationSeconds: 20,
        ),
        FeedingRecord(
          id: 'REC_003',
          title: 'Manual Feeding',
          timestamp: DateTime(now.year, now.month, now.day - 1, 17, 30),
          type: 'Manual',
          status: 'Completed',
          durationSeconds: 15,
        ),
        FeedingRecord(
          id: 'REC_004',
          title: 'Morning Feeding',
          timestamp: DateTime(now.year, now.month, now.day - 1, 8, 0),
          type: 'Scheduled',
          status: 'Completed',
          durationSeconds: 15,
        ),
      ];
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = true;
      notifyListeners();
      _sub = _rtdbService.streamHistory(deviceId).listen((list) {
        _allRecords = list;
        _isLoading = false;
        notifyListeners();
      }, onError: (e) {
        AppLogger.e('HistoryProvider', 'Error loading history', e);
        _isLoading = false;
        notifyListeners();
      });
    }
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

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
