import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/app_logger.dart';

class SettingsProvider with ChangeNotifier {
  bool _isMockMode = true; // Default to Development/Mock mode so app works standalone out-of-the-box
  Locale _locale = const Locale('en');
  String _activeDeviceId = AppConstants.defaultDeviceId;
  bool _isOnboardingCompleted = false;
  bool _isInitialized = false;

  bool get isMockMode => _isMockMode;
  Locale get locale => _locale;
  String get activeDeviceId => _activeDeviceId;
  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isInitialized => _isInitialized;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isMockMode = prefs.getBool(AppConstants.keyMockMode) ?? true;
      final langCode = prefs.getString(AppConstants.keyLanguage) ?? 'en';
      _locale = Locale(langCode);
      _activeDeviceId = prefs.getString(AppConstants.keyActiveDeviceId) ?? AppConstants.defaultDeviceId;
      _isOnboardingCompleted = prefs.getBool(AppConstants.keyOnboardingCompleted) ?? false;
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      AppLogger.e('SettingsProvider', 'Failed to load settings', e);
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> setMockMode(bool value) async {
    _isMockMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyMockMode, value);
    AppLogger.i('SettingsProvider', 'Mock Mode toggled: $value');
  }

  Future<void> setLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyLanguage, languageCode);
  }

  Future<void> setActiveDeviceId(String deviceId) async {
    _activeDeviceId = deviceId;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyActiveDeviceId, deviceId);
  }

  Future<void> setOnboardingCompleted(bool value) async {
    _isOnboardingCompleted = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingCompleted, value);
    AppLogger.i('SettingsProvider', 'Onboarding completed set to: $value');
  }
}
