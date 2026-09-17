import 'dart:async';
import 'package:flutter/material.dart';
import '../models/alert_model.dart';

class AlertProvider with ChangeNotifier {
  List<AlertModel> _alerts = [];
  StreamSubscription<List<AlertModel>>? _sub;
  bool _isLoading = false;

  List<AlertModel> get alerts => _alerts;
  bool get isLoading => _isLoading;

  int get unreadCount => _alerts.where((a) => !a.read).length;

  void initAlerts(String deviceId, bool isMockMode) {
    _sub?.cancel();

    final now = DateTime.now();
    _alerts = [
      AlertModel(
        id: 'ALT_001',
        title: 'Morning Feeding Complete',
        message: 'Morning cattle feeding completed successfully. 1.20 kg dispensed.',
        type: AlertType.info,
        timestamp: now.subtract(const Duration(minutes: 25)),
        read: false,
      ),
      AlertModel(
        id: 'ALT_002',
        title: 'Feed Flow Check',
        message: 'Flow assist vibration activated briefly to ensure smooth hay movement.',
        type: AlertType.warning,
        timestamp: now.subtract(const Duration(hours: 2)),
        read: false,
      ),
      AlertModel(
        id: 'ALT_003',
        title: 'Fodder Hopper Level Good',
        message: 'Fodder hopper capacity is currently at 78%. System is ready.',
        type: AlertType.info,
        timestamp: now.subtract(const Duration(hours: 5)),
        read: true,
      ),
    ];
    _isLoading = false;
    notifyListeners();
  }

  void addFarmerNotification({
    required String title,
    required String message,
    required AlertType type,
  }) {
    final newAlert = AlertModel(
      id: 'ALT_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
      read: false,
    );
    _alerts.insert(0, newAlert);
    notifyListeners();
  }

  Future<void> markAsRead(String deviceId, String alertId, bool isMockMode) async {
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(read: true);
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    _alerts = _alerts.map((a) => a.copyWith(read: true)).toList();
    notifyListeners();
  }

  Future<void> clearAll(String deviceId, bool isMockMode) async {
    _alerts.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
