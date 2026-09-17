import 'dart:async';
import 'package:flutter/material.dart';
import '../models/ai_prediction_model.dart';
import '../models/simulation_record.dart';
import '../services/blockage_prediction_service.dart';
import '../services/feed_prediction_service.dart';
import '../services/simulation_data_service.dart';

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

  List<CombinedSimulationPair> _dataset = SimulationDataService.pairedDataset;
  int _currentIndex = 0;
  Timer? _simulationTimer;
  bool _isSimulating = true;
  bool _isPaused = false;
  int _simulationIntervalSeconds = 3;

  // Telemetry state
  late CombinedSimulationPair _currentPair;
  late FeedQuantityPrediction _currentFeedPrediction;
  late BlockagePrediction _currentBlockagePrediction;

  // Active feeding animation state
  bool _isFeedingActive = false;
  double _dispenseProgress = 0.0;
  double _currentDispensedKg = 0.0;
  Timer? _dispenseTimer;

  // Activity Timeline log
  final List<SystemActivityItem> _activityLog = [];

  // Getters
  bool get isSimulating => _isSimulating;
  bool get isPaused => _isPaused;
  int get currentIndex => _currentIndex;
  int get totalRecords => _dataset.length;
  CombinedSimulationPair get currentPair => _currentPair;
  FeedQuantityRecord get currentFeedRecord => _currentPair.feedRecord;
  BlockageRecord get currentBlockageRecord => _currentPair.blockageRecord;
  FeedQuantityPrediction get currentFeedPrediction => _currentFeedPrediction;
  BlockagePrediction get currentBlockagePrediction => _currentBlockagePrediction;

  bool get isFeedingActive => _isFeedingActive;
  double get dispenseProgress => _dispenseProgress;
  double get currentDispensedKg => _currentDispensedKg;
  List<SystemActivityItem> get activityLog => List.unmodifiable(_activityLog);

  SimulationProvider() {
    _currentPair = _dataset[0];
    _evaluateCurrentPredictions();
    _logActivity("System Initialized", "Simulated Live IoT Engine ready", Icons.power_settings_new, Colors.lightGreenAccent);
    startSimulation();
  }

  void startSimulation() {
    _isSimulating = true;
    _isPaused = false;
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(Duration(seconds: _simulationIntervalSeconds), (_) {
      if (!_isPaused && !_isFeedingActive) {
        nextRecord();
      }
    });
    notifyListeners();
  }

  void pauseSimulation() {
    _isPaused = true;
    notifyListeners();
  }

  void resumeSimulation() {
    _isPaused = false;
    notifyListeners();
  }

  void toggleSimulationState() {
    if (_isPaused) {
      resumeSimulation();
    } else {
      pauseSimulation();
    }
  }

  void setRecordIndex(int index) {
    if (index >= 0 && index < _dataset.length) {
      _currentIndex = index;
      _currentPair = _dataset[_currentIndex];
      _evaluateCurrentPredictions();
      _logActivity(
        "Record #${_currentIndex + 1} Loaded",
        "Hopper: ${_currentPair.feedRecord.hopperLevelCm}cm | Trough: ${_currentPair.feedRecord.troughWeightBeforeKg}kg",
        Icons.data_usage,
        Colors.blueAccent,
      );
      notifyListeners();
    }
  }

  void nextRecord() {
    _currentIndex = (_currentIndex + 1) % _dataset.length;
    _currentPair = _dataset[_currentIndex];
    _evaluateCurrentPredictions();
    _logActivity(
      "Telemetry Stream Update",
      "Sensor values updated from dataset record #${_currentIndex + 1}",
      Icons.sensors,
      Colors.greenAccent,
    );
    notifyListeners();
  }

  void _evaluateCurrentPredictions() {
    _currentFeedPrediction = _feedService.predictFeedQuantity(_currentPair.feedRecord);
    _currentBlockagePrediction = _blockageService.predictBlockage(_currentPair.blockageRecord);
  }

  // Preset Demo Scenarios required by Section 20
  void triggerDemoNormal() {
    setRecordIndex(0); // Record 1 = Normal flow
    _logActivity("DEMO 1 Triggered", "Scenario: Normal Flow dispensing", Icons.check_circle, Colors.green);
    executeFeedingCycle();
  }

  void triggerDemoModerateBlockage() {
    setRecordIndex(1); // Record 2 = Moderate blockage risk
    _logActivity("DEMO 2 Triggered", "Scenario: Moderate Blockage Risk (Vibration ON)", Icons.warning_amber, Colors.orange);
    executeFeedingCycle();
  }

  void triggerDemoSevereBlockage() {
    setRecordIndex(2); // Record 3 = Severe blockage risk
    _logActivity("DEMO 3 Triggered", "Scenario: Severe Blockage Risk (Vibration + Gate Adjust)", Icons.report_problem, Colors.redAccent);
    executeFeedingCycle();
  }

  // Execute full automated feeding cycle
  void executeFeedingCycle([double? manualTargetKg]) {
    if (_isFeedingActive) return;

    final targetQty = manualTargetKg ?? _currentFeedPrediction.predictedQuantityKg;
    _isFeedingActive = true;
    _dispenseProgress = 0.0;
    _currentDispensedKg = 0.0;
    notifyListeners();

    _logActivity("Sensor Stream Read", "Hopper: ${_currentPair.feedRecord.hopperLevelCm}cm", Icons.sensors, Colors.cyan);

    // Step 1: AI Evaluation
    Future.delayed(const Duration(milliseconds: 600), () {
      _logActivity("AI Feed Prediction", "Target Hay: ${targetQty.toStringAsFixed(2)}kg", Icons.psychology, Colors.purpleAccent);

      // Step 2: Risk Check & Vibration
      Future.delayed(const Duration(milliseconds: 600), () {
        if (_currentBlockagePrediction.vibratorActivated) {
          _logActivity("Preventive Action", "Vibration Motor ON for 1.5s", Icons.vibration, Colors.orangeAccent);
        } else {
          _logActivity("Flow Check", "Flow status: NORMAL", Icons.done_all, Colors.greenAccent);
        }

        // Step 3: Gate Opening & Dispense Loop
        Future.delayed(const Duration(milliseconds: 600), () {
          _logActivity("Gate Actuation", "Servo Gate opened to ${_currentBlockagePrediction.adjustedGateOpeningPercent}%", Icons.door_sliding, Colors.amber);

          _dispenseTimer?.cancel();
          int steps = 20;
          int currentStep = 0;
          _dispenseTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
            currentStep++;
            _dispenseProgress = (currentStep / steps).clamp(0.0, 1.0);
            _currentDispensedKg = double.parse((targetQty * _dispenseProgress).toStringAsFixed(2));

            if (currentStep >= steps) {
              timer.cancel();
              _isFeedingActive = false;
              _logActivity(
                "Feeding Cycle Completed",
                "Dispensed ${_currentDispensedKg.toStringAsFixed(2)}kg in ${_currentPair.blockageRecord.gateTimeSeconds}s",
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
    });
  }

  void stopFeedingCycle() {
    _dispenseTimer?.cancel();
    _isFeedingActive = false;
    _dispenseProgress = 0.0;
    _currentDispensedKg = 0.0;
    _logActivity("Feeding Stopped", "Manual override triggered", Icons.stop_circle, Colors.red);
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
    _dispenseTimer?.cancel();
    super.dispose();
  }
}
