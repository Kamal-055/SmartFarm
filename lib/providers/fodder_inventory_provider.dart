import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alert_model.dart';
import 'alert_provider.dart';

class FodderInventoryProvider with ChangeNotifier {
  static const String _keyAvailableFodder = 'fodder_available_kg';
  static const String _keyLastRefill = 'fodder_last_refill';

  final double _totalCapacityKg = 10.0;
  double _availableFodderKg = 10.0;
  final double _lowFodderThresholdKg = 2.0;
  final double _criticalFodderThresholdKg = 1.0;

  DateTime? _lastRefillTime;
  DateTime? _lastFeedingTime;
  bool _hasNotifiedLowFodder = false;

  // Hopper Depth Calibration: 10 cm = Full (10.0 kg), 30 cm = Empty (0.0 kg)
  static const double hopperFullCm = 10.0;
  static const double hopperEmptyCm = 30.0;

  // Getters
  double get totalCapacityKg => _totalCapacityKg;
  double get availableFodderKg => _availableFodderKg;
  double get lowFodderThresholdKg => _lowFodderThresholdKg;
  double get criticalFodderThresholdKg => _criticalFodderThresholdKg;
  DateTime? get lastRefillTime => _lastRefillTime;
  DateTime? get lastFeedingTime => _lastFeedingTime;

  double get availablePercentage => (_availableFodderKg / _totalCapacityKg).clamp(0.0, 1.0);

  // Convert available kg to calculated hopper depth cm for detailed telemetry views
  double get calculatedHopperLevelCm {
    final ratio = availablePercentage;
    return hopperFullCm + (1.0 - ratio) * (hopperEmptyCm - hopperFullCm);
  }

  // Fodder Status Enum State
  bool get isGood => _availableFodderKg > _lowFodderThresholdKg;
  bool get isLow => _availableFodderKg <= _lowFodderThresholdKg && _availableFodderKg > _criticalFodderThresholdKg;
  bool get isCritical => _availableFodderKg <= _criticalFodderThresholdKg;

  String get statusText {
    if (isGood) return 'Fodder Good';
    if (isLow) return 'Fodder Running Low';
    return 'Refill Fodder';
  }

  Color get statusColor {
    if (isGood) return const Color(0xFF52B788);
    if (isLow) return Colors.amber;
    return Colors.redAccent;
  }

  FodderInventoryProvider() {
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _availableFodderKg = prefs.getDouble(_keyAvailableFodder) ?? 10.0;
      final refillEpoch = prefs.getInt(_keyLastRefill);
      if (refillEpoch != null) {
        _lastRefillTime = DateTime.fromMillisecondsSinceEpoch(refillEpoch);
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_keyAvailableFodder, _availableFodderKg);
      if (_lastRefillTime != null) {
        await prefs.setInt(_keyLastRefill, _lastRefillTime!.millisecondsSinceEpoch);
      }
    } catch (_) {}
  }

  bool canFeed(double requestedKg) {
    return _availableFodderKg >= requestedKg;
  }

  Future<void> refillFodder(double amountAddedKg, AlertProvider alertProvider) async {
    if (amountAddedKg <= 0) return;

    _availableFodderKg = (_availableFodderKg + amountAddedKg).clamp(0.0, _totalCapacityKg + 5.0);
    _lastRefillTime = DateTime.now();
    _hasNotifiedLowFodder = false;

    await _saveToPreferences();

    alertProvider.addFarmerNotification(
      title: 'Fodder Refilled',
      message: 'Added ${amountAddedKg.toStringAsFixed(1)} kg to fodder bin. Available: ${_availableFodderKg.toStringAsFixed(2)} kg.',
      type: AlertType.info,
    );

    notifyListeners();
  }

  Future<void> deductFodder(double actualDispensedKg, AlertProvider alertProvider) async {
    if (actualDispensedKg <= 0) return;

    _availableFodderKg = (_availableFodderKg - actualDispensedKg).clamp(0.0, _totalCapacityKg + 5.0);
    _lastFeedingTime = DateTime.now();

    await _saveToPreferences();

    // Check low fodder threshold
    if (_availableFodderKg <= _lowFodderThresholdKg && !_hasNotifiedLowFodder) {
      _hasNotifiedLowFodder = true;
      alertProvider.addFarmerNotification(
        title: 'Fodder Running Low',
        message: 'Fodder level is down to ${_availableFodderKg.toStringAsFixed(2)} kg. Please refill soon.',
        type: AlertType.warning,
      );
    }

    notifyListeners();
  }
}
