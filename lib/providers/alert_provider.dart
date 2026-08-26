import 'dart:async';
import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../services/rtdb_service.dart';
import '../core/utils/app_logger.dart';

class AlertProvider with ChangeNotifier {
  final RealtimeDatabaseService _rtdbService = RealtimeDatabaseService();

  List<AlertModel> _alerts = [];
  StreamSubscription<List<AlertModel>>? _sub;
  bool _isLoading = false;

  List<AlertModel> get alerts => _alerts;
  bool get isLoading => _isLoading;

  int get unreadCount => _alerts.where((a) => !a.read).length;

  void initAlerts(String deviceId, bool isMockMode) {
    _sub?.cancel();

    if (isMockMode) {
      final now = DateTime.now();
      _alerts = [
        AlertModel(
          id: 'ALT_001',
          title: 'Feed Level Good',
          message: 'The fodder level is currently at 78%. System is ready.',
          type: AlertType.info,
          timestamp: now.subtract(const Duration(hours: 1)),
          read: false,
        ),
        AlertModel(
          id: 'ALT_002',
          title: 'Morning Feeding Completed',
          message: 'Morning scheduled feeding finished successfully (15s duration).',
          type: AlertType.info,
          timestamp: now.subtract(const Duration(hours: 3)),
          read: true,
        ),
        AlertModel(
          id: 'ALT_003',
          title: 'Hardware Heartbeat',
          message: 'ESP8266 node connected with 100% signal strength.',
          type: AlertType.info,
          timestamp: now.subtract(const Duration(hours: 5)),
          read: true,
        ),
      ];
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = true;
      notifyListeners();
      _sub = _rtdbService.streamAlerts(deviceId).listen((list) {
        _alerts = list;
        _isLoading = false;
        notifyListeners();
      }, onError: (e) {
        AppLogger.e('AlertProvider', 'Error streaming alerts', e);
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  Future<void> markAsRead(String deviceId, String alertId, bool isMockMode) async {
    if (isMockMode) {
      final index = _alerts.indexWhere((a) => a.id == alertId);
      if (index != -1) {
        _alerts[index] = _alerts[index].copyWith(read: true);
        notifyListeners();
      }
    } else {
      await _rtdbService.markAlertRead(deviceId, alertId);
    }
  }

  Future<void> clearAll(String deviceId, bool isMockMode) async {
    if (isMockMode) {
      _alerts.clear();
      notifyListeners();
    } else {
      await _rtdbService.clearAlerts(deviceId);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
