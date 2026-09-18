import 'dart:async';
import 'package:flutter/material.dart';
import '../models/ai_prediction_model.dart';
import '../models/alert_model.dart';
import '../models/feeding_record.dart';
import '../models/simulation_record.dart';
import '../services/blockage_prediction_service.dart';
import '../services/feed_prediction_service.dart';
import '../services/simulation_data_service.dart';
import 'alert_provider.dart';
import 'fodder_inventory_provider.dart';
import 'history_provider.dart';
import 'schedule_provider.dart';

class SystemActivityItem {
  final DateTime timestamp;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  SystemActivityItem({
    required this.timestamp,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class SimulationProvider with ChangeNotifier {
  final FeedPredictionService _feedService = FeedPredictionService();
  final BlockagePredictionService _blockageService = BlockagePredictionService();

  final List<CombinedSimulationPair> _dataset = SimulationDataService.pairedDataset;
  int _currentIndex = 0;
  Timer? _simulationTimer;
  Timer? _scheduleCheckerTimer;

  // Telemetry state
  late CombinedSimulationPair _currentPair;
  late FeedQuantityPrediction _currentFeedPrediction;
  late BlockagePrediction _currentBlockagePrediction;

  // Active feeding animation state
  bool _isFeedingActive = false;
  String _feedingStatusText = 'Ready';
  double _dispenseProgress = 0.0;
  double _currentDispensedKg = 0.0;
  double _currentTroughWeightKg = 0.20;
  Timer? _dispenseTimer;

  // Background schedule tracking: map of "SCH_001_2026-09-17" -> bool
  final Set<String> _executedScheduleKeys = {};

  // Activity Timeline log
  final List<SystemActivityItem> _activityLog = [];

  // Getters
  int get currentIndex => _currentIndex;
  int get totalRecords => _dataset.length;
  bool get isPaused => false;
  CombinedSimulationPair get currentPair => _currentPair;
  FeedQuantityRecord get currentFeedRecord => _currentPair.feedRecord;
  BlockageRecord get currentBlockageRecord => _currentPair.blockageRecord;
  FeedQuantityPrediction get currentFeedPrediction => _currentFeedPrediction;
  BlockagePrediction get currentBlockagePrediction => _currentBlockagePrediction;

  bool get isFeedingActive => _isFeedingActive;
  String get feedingStatusText => _feedingStatusText;
  double get dispenseProgress => _dispenseProgress;
  double get currentDispensedKg => _currentDispensedKg;
  double get currentTroughWeightKg => _currentTroughWeightKg;
  List<SystemActivityItem> get activityLog => List.unmodifiable(_activityLog);

  void toggleSimulationState() {}
  void nextRecord() {
    setRecordIndex((_currentIndex + 1) % _dataset.length);
  }

  SimulationProvider() {
    _currentPair = _dataset[0];
    _evaluateCurrentPredictions();
    _logActivity("System Online", "Smart Fodder Dispensing Engine ready", Icons.power_settings_new, Colors.lightGreenAccent);
    _startTelemetryLoop();
  }

  void _startTelemetryLoop() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_isFeedingActive) {
        _currentIndex = (_currentIndex + 1) % _dataset.length;
        _currentPair = _dataset[_currentIndex];
        _evaluateCurrentPredictions();
        notifyListeners();
      }
    });
  }

  void startBackgroundScheduler({
    required ScheduleProvider scheduleProvider,
    required FodderInventoryProvider inventoryProvider,
    required HistoryProvider historyProvider,
    required AlertProvider alertProvider,
  }) {
    _scheduleCheckerTimer?.cancel();
    _scheduleCheckerTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _checkAndExecuteSchedules(
        scheduleProvider: scheduleProvider,
        inventoryProvider: inventoryProvider,
        historyProvider: historyProvider,
        alertProvider: alertProvider,
      );
    });
  }

  void _checkAndExecuteSchedules({
    required ScheduleProvider scheduleProvider,
    required FodderInventoryProvider inventoryProvider,
    required HistoryProvider historyProvider,
    required AlertProvider alertProvider,
  }) {
    if (_isFeedingActive) return;

    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    for (final schedule in scheduleProvider.schedules) {
      if (!schedule.enabled) continue;

      if (now.hour == schedule.hour && now.minute == schedule.minute) {
        final key = "${schedule.id}_$todayStr";
        if (!_executedScheduleKeys.contains(key)) {
          _executedScheduleKeys.add(key);

          // Trigger automatic feeding workflow
          executeFeedingCycle(
            inventoryProvider: inventoryProvider,
            historyProvider: historyProvider,
            alertProvider: alertProvider,
            manualTargetKg: schedule.targetQtyKg,
            titleOverride: schedule.name,
            isScheduled: true,
          );
          break;
        }
      }
    }
  }

  void setRecordIndex(int index) {
    if (index >= 0 && index < _dataset.length) {
      _currentIndex = index;
      _currentPair = _dataset[_currentIndex];
      _evaluateCurrentPredictions();
      notifyListeners();
    }
  }

  void _evaluateCurrentPredictions() {
    _currentFeedPrediction = _feedService.predictFeedQuantity(_currentPair.feedRecord);
    _currentBlockagePrediction = _blockageService.predictBlockage(_currentPair.blockageRecord);
  }

  // Scenarios for testing flow states
  void triggerDemoNormal() {
    setRecordIndex(0);
  }

  void triggerDemoModerateBlockage() {
    setRecordIndex(1);
  }

  void triggerDemoSevereBlockage() {
    setRecordIndex(2);
  }

  // Central feeding execution workflow
  bool executeFeedingCycle({
    required FodderInventoryProvider inventoryProvider,
    required HistoryProvider historyProvider,
    required AlertProvider alertProvider,
    double? manualTargetKg,
    String? titleOverride,
    bool isScheduled = false,
  }) {
    if (_isFeedingActive) return false;

    final targetQty = (manualTargetKg ?? _currentFeedPrediction.predictedQuantityKg).clamp(0.2, 5.0);

    // STEP 1: Inventory Check
    if (!inventoryProvider.canFeed(targetQty)) {
      alertProvider.addFarmerNotification(
        title: 'Feeding Could Not Start',
        message: 'Not enough fodder available. Required: ${targetQty.toStringAsFixed(2)} kg, Available: ${inventoryProvider.availableFodderKg.toStringAsFixed(2)} kg.',
        type: AlertType.critical,
      );
      _logActivity("Feeding Blocked", "Insufficient fodder in storage bin", Icons.warning_amber, Colors.redAccent);
      return false;
    }

    _isFeedingActive = true;
    _dispenseProgress = 0.0;
    _currentDispensedKg = 0.0;
    _feedingStatusText = 'Preparing system...';
    notifyListeners();

    if (isScheduled) {
      alertProvider.addFarmerNotification(
        title: '${titleOverride ?? "Scheduled Feed"} Started',
        message: 'Automatic cattle feeding started. Target quantity: ${targetQty.toStringAsFixed(2)} kg.',
        type: AlertType.info,
      );
    }

    _logActivity("Feeding Prepared", "Target: ${targetQty.toStringAsFixed(2)} kg (${isScheduled ? 'Scheduled' : 'Manual'})", Icons.play_circle_fill, Colors.greenAccent);

    // Step 2: Flow & Vibration Check
    Future.delayed(const Duration(milliseconds: 600), () {
      if (_currentBlockagePrediction.vibratorActivated) {
        _feedingStatusText = 'Flow assist active...';
        alertProvider.addFarmerNotification(
          title: 'Feed Flow Check',
          message: 'Flow assist vibration pulse activated to ensure smooth fodder flow.',
          type: AlertType.warning,
        );
      } else {
        _feedingStatusText = 'Opening gate...';
      }
      notifyListeners();

      // Step 3: Dispense Loop
      Future.delayed(const Duration(milliseconds: 600), () {
        _dispenseTimer?.cancel();
        int steps = 25;
        int currentStep = 0;
        final initialTroughWt = _currentTroughWeightKg;

        _dispenseTimer = Timer.periodic(const Duration(milliseconds: 160), (timer) {
          currentStep++;
          _dispenseProgress = (currentStep / steps).clamp(0.0, 1.0);
          _currentDispensedKg = double.parse((targetQty * _dispenseProgress).toStringAsFixed(2));
          _currentTroughWeightKg = double.parse((initialTroughWt + _currentDispensedKg).toStringAsFixed(2));

          if (_dispenseProgress < 0.3) {
            _feedingStatusText = 'Opening gate (60%)...';
          } else if (_dispenseProgress < 0.8) {
            _feedingStatusText = 'Dispensing fodder...';
          } else if (_dispenseProgress < 1.0) {
            _feedingStatusText = 'Closing gate...';
          }

          if (currentStep >= steps) {
            timer.cancel();

            // STEP 4: Completion & Actual Deduction
            final actualDispensed = (targetQty * 0.98).clamp(0.1, targetQty);
            _currentDispensedKg = actualDispensed;
            _feedingStatusText = 'Complete ✓';
            _isFeedingActive = false;

            // Deduct actual dispensed from central inventory
            inventoryProvider.deductFodder(actualDispensed, alertProvider);

            // Create History Record
            historyProvider.addRecord(FeedingRecord(
              id: 'REC_${DateTime.now().millisecondsSinceEpoch}',
              title: titleOverride ?? (isScheduled ? 'Scheduled Feed' : 'Manual Feed'),
              timestamp: DateTime.now(),
              type: isScheduled ? 'Scheduled' : 'Manual',
              status: 'Completed',
              durationSeconds: _currentPair.blockageRecord.gateTimeSeconds.toInt(),
              targetQuantityKg: targetQty,
              actualQuantityKg: actualDispensed,
              remainingFodderKg: inventoryProvider.availableFodderKg,
              flowAssisted: _currentBlockagePrediction.vibratorActivated,
            ));

            // Create Notification
            alertProvider.addFarmerNotification(
              title: '${titleOverride ?? "Feeding"} Completed',
              message: '${actualDispensed.toStringAsFixed(2)} kg dispensed successfully. ${inventoryProvider.availableFodderKg.toStringAsFixed(2)} kg remaining.',
              type: AlertType.info,
            );

            _logActivity(
              "Feeding Completed",
              "Dispensed ${actualDispensed.toStringAsFixed(2)} kg to trough",
              Icons.task_alt,
              Colors.lightGreenAccent,
            );

            notifyListeners();
          } else {
            notifyListeners();
          }
        });
      });
    });

    return true;
  }

  void stopFeedingCycle() {
    _dispenseTimer?.cancel();
    _isFeedingActive = false;
    _feedingStatusText = 'Stopped';
    _dispenseProgress = 0.0;
    _currentDispensedKg = 0.0;
    _logActivity("Feeding Cancelled", "Manual override triggered", Icons.stop_circle, Colors.redAccent);
    notifyListeners();
  }

  void _logActivity(String title, String description, IconData icon, Color color) {
    _activityLog.insert(0, SystemActivityItem(
      timestamp: DateTime.now(),
      title: title,
      description: description,
      icon: icon,
      color: color,
    ));
    if (_activityLog.length > 50) {
      _activityLog.removeLast();
    }
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _scheduleCheckerTimer?.cancel();
    _dispenseTimer?.cancel();
    super.dispose();
  }
}
