import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/app_logger.dart';
import '../models/device_model.dart';
import '../services/rtdb_service.dart';

class DeviceProvider with ChangeNotifier {
  final RealtimeDatabaseService _rtdbService = RealtimeDatabaseService();

  DeviceModel? _device;
  StreamSubscription<DeviceModel?>? _deviceSub;
  Timer? _mockTimer;
  Timer? _heartbeatTimer;
  
  bool _isLoading = false;
  String? _errorMessage;

  DeviceModel? get device => _device;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Gate Safety checks
  bool get isDeviceOnline {
    if (_device == null) return false;
    return _device!.isDeviceOnline(AppConstants.deviceOfflineTimeoutSeconds);
  }

  bool get canOpenGate {
    if (_device == null || !isDeviceOnline) return false;
    final gate = _device!.gate;
    return gate.state == GateState.closed;
  }

  bool get canCloseGate {
    if (_device == null || !isDeviceOnline) return false;
    final gate = _device!.gate;
    return gate.state == GateState.open;
  }

  void initDevice(String deviceId, bool isMockMode) {
    AppLogger.i('DeviceProvider', 'Initializing device $deviceId (Mock: $isMockMode)');
    _deviceSub?.cancel();
    _mockTimer?.cancel();
    _heartbeatTimer?.cancel();

    if (isMockMode) {
      _initMockDevice(deviceId);
    } else {
      _initFirebaseDevice(deviceId);
    }
  }

  void _initFirebaseDevice(String deviceId) {
    _isLoading = true;
    notifyListeners();

    _deviceSub = _rtdbService.streamDevice(deviceId).listen(
      (deviceModel) {
        _device = deviceModel;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        AppLogger.e('DeviceProvider', 'Firebase device stream error', error);
        _isLoading = false;
        _errorMessage = "Unable to connect to feeding system. Check internet.";
        notifyListeners();
      },
    );
  }

  void _initMockDevice(String deviceId) {
    // Initial mock state
    _device = DeviceModel(
      deviceId: deviceId,
      farmId: 'FARM_GREEN_VALLEY',
      name: 'Fodder Dispenser 1',
      gate: GateStatus(
        state: GateState.closed,
        command: 'CLOSE',
        lastCommand: 'CLOSE',
        lastCommandTimestamp: DateTime.now().millisecondsSinceEpoch,
      ),
      feed: FeedStatus(
        levelPercentage: 78,
        status: FeedLevelStatus.good,
      ),
      system: SystemStatus(
        online: true,
        lastSeen: DateTime.now().millisecondsSinceEpoch,
        firmwareVersion: 'v1.0.4-ESP8266',
      ),
    );
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();

    // Heartbeat ticker in mock mode
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_device != null) {
        _device = DeviceModel(
          deviceId: _device!.deviceId,
          farmId: _device!.farmId,
          name: _device!.name,
          gate: _device!.gate,
          feed: _device!.feed,
          system: SystemStatus(
            online: true,
            lastSeen: DateTime.now().millisecondsSinceEpoch,
            firmwareVersion: _device!.system.firmwareVersion,
          ),
        );
        notifyListeners();
      }
    });
  }

  // High-Level Gate Command Handler with safety guards
  Future<bool> openGate({required bool isMockMode}) async {
    if (_device == null) return false;
    
    // Safety check 1: Device online
    if (!isDeviceOnline) {
      _errorMessage = "System is offline. Cannot operate fodder gate.";
      notifyListeners();
      return false;
    }

    // Safety check 2: Gate already open or operating
    if (_device!.gate.state == GateState.open || _device!.gate.state == GateState.opening) {
      AppLogger.i('DeviceProvider', 'Open command ignored: Gate is already open/opening.');
      return false;
    }

    AppLogger.i('DeviceProvider', 'Executing OPEN gate command');

    if (isMockMode) {
      return _simulateGateMovement(GateState.opening, GateState.open, 'OPEN');
    } else {
      try {
        await _rtdbService.sendGateCommand(
          deviceId: _device!.deviceId,
          command: 'OPEN',
        );
        return true;
      } catch (e) {
        _errorMessage = "Failed to send open command to device.";
        notifyListeners();
        return false;
      }
    }
  }

  Future<bool> closeGate({required bool isMockMode}) async {
    if (_device == null) return false;

    // Safety check 1: Device online
    if (!isDeviceOnline) {
      _errorMessage = "System is offline. Cannot operate fodder gate.";
      notifyListeners();
      return false;
    }

    // Safety check 2: Gate already closed or operating
    if (_device!.gate.state == GateState.closed || _device!.gate.state == GateState.closing) {
      AppLogger.i('DeviceProvider', 'Close command ignored: Gate is already closed/closing.');
      return false;
    }

    AppLogger.i('DeviceProvider', 'Executing CLOSE gate command');

    if (isMockMode) {
      return _simulateGateMovement(GateState.closing, GateState.closed, 'CLOSE');
    } else {
      try {
        await _rtdbService.sendGateCommand(
          deviceId: _device!.deviceId,
          command: 'CLOSE',
        );
        return true;
      } catch (e) {
        _errorMessage = "Failed to send close command to device.";
        notifyListeners();
        return false;
      }
    }
  }

  // Smooth mock hardware servo simulation
  bool _simulateGateMovement(GateState transitionState, GateState finalState, String command) {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Step 1: Set transition state (OPENING / CLOSING)
    _device = DeviceModel(
      deviceId: _device!.deviceId,
      farmId: _device!.farmId,
      name: _device!.name,
      gate: GateStatus(
        state: transitionState,
        command: command,
        lastCommand: command,
        lastCommandTimestamp: now,
      ),
      feed: _device!.feed,
      system: _device!.system,
    );
    notifyListeners();

    // Step 2: After 2.5 seconds (simulating slow ESP8266 servo physical movement), complete operation
    _mockTimer?.cancel();
    _mockTimer = Timer(const Duration(milliseconds: 2500), () {
      if (_device != null) {
        // Slightly update feed level when opening gate
        int newLevel = _device!.feed.levelPercentage;
        if (finalState == GateState.open && newLevel > 5) {
          newLevel -= 2;
        }

        _device = DeviceModel(
          deviceId: _device!.deviceId,
          farmId: _device!.farmId,
          name: _device!.name,
          gate: GateStatus(
            state: finalState,
            command: command,
            lastCommand: command,
            lastCommandTimestamp: DateTime.now().millisecondsSinceEpoch,
          ),
          feed: FeedStatus.fromMap({'level': newLevel}),
          system: _device!.system,
        );
        notifyListeners();
      }
    });

    return true;
  }

  // Simulate mock device heartbeat toggle for testing offline banner
  void toggleMockHeartbeat(bool online) {
    if (_device == null) return;
    final lastSeen = online ? DateTime.now().millisecondsSinceEpoch : 0;
    _device = DeviceModel(
      deviceId: _device!.deviceId,
      farmId: _device!.farmId,
      name: _device!.name,
      gate: _device!.gate,
      feed: _device!.feed,
      system: SystemStatus(online: online, lastSeen: lastSeen, firmwareVersion: _device!.system.firmwareVersion),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _deviceSub?.cancel();
    _mockTimer?.cancel();
    _heartbeatTimer?.cancel();
    super.dispose();
  }
}
