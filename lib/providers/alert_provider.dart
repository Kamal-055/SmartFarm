import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alert_model.dart';

class AlertProvider with ChangeNotifier {
  static const String _keyAlerts = 'fodder_alerts_list';

  List<AlertModel> _alerts = [];
  AlertModel? _latestToastAlert;
  StreamSubscription<List<AlertModel>>? _sub;
  final bool _isLoading = false;

  List<AlertModel> get alerts => _alerts;
  AlertModel? get latestToastAlert => _latestToastAlert;
  bool get isLoading => _isLoading;

  int get unreadCount => _alerts.where((a) => !a.read).length;

  AlertProvider() {
    _loadFromPreferences();
  }

  void initAlerts([String? deviceId, bool? isMockMode]) {
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_keyAlerts);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        _alerts = decoded.map((m) => AlertModel.fromMap(m, m['id'] ?? '')).toList();
      } else {
        _initDefaultAlerts();
      }
    } catch (_) {
      _initDefaultAlerts();
    }
    notifyListeners();
  }

  void _initDefaultAlerts() {
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
    ];
  }

  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final maps = _alerts.map((a) => a.toMap()).toList();
      await prefs.setString(_keyAlerts, jsonEncode(maps));
    } catch (_) {}
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
    _latestToastAlert = newAlert;
    _saveToPreferences();
    notifyListeners();
  }

  void clearToastAlert() {
    _latestToastAlert = null;
    notifyListeners();
  }

  Future<void> markAsRead(String deviceId, String alertId, bool isMockMode) async {
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(read: true);
      _saveToPreferences();
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    _alerts = _alerts.map((a) => a.copyWith(read: true)).toList();
    _saveToPreferences();
    notifyListeners();
  }

  Future<void> clearAll(String deviceId, bool isMockMode) async {
    _alerts.clear();
    _latestToastAlert = null;
    _saveToPreferences();
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
