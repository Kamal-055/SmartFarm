class AppConstants {
  static const String appName = "FodderFlow";
  static const String appSubtitle = "Smart Cattle Dispense & Farm IoT";
  static const String defaultDeviceId = "DEVICE_001";
  
  // Device Heartbeat Timeout (Seconds). If device lastSeen is older than this, flag offline.
  static const int deviceOfflineTimeoutSeconds = 60;
  
  // Gate Command Timeout (Seconds). If command stays OPENING/CLOSING longer than this, flag error.
  static const int gateCommandTimeoutSeconds = 15;

  // Realtime Database Paths
  static const String pathUsers = "users";
  static const String pathFarms = "farms";
  static const String pathDevices = "devices";

  // Shared Preferences Keys
  static const String keyMockMode = "pref_mock_mode";
  static const String keyLanguage = "pref_language";
  static const String keyActiveDeviceId = "pref_active_device_id";
  static const String keyActiveFarmId = "pref_active_farm_id";
  static const String keyOnboardingCompleted = "pref_onboarding_completed";
}
