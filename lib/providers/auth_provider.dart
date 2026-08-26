import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../core/utils/app_logger.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  AuthStatus _status = AuthStatus.uninitialized;
  UserModel? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _init();
  }

  void _init() {
    try {
      _authService.authStateChanges.listen((firebaseUser) {
        if (firebaseUser != null) {
          _user = UserModel(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            name: firebaseUser.displayName ?? 'Farmer',
            farmId: 'FARM_${firebaseUser.uid.substring(0, 6).toUpperCase()}',
            createdAt: DateTime.now(),
          );
          _status = AuthStatus.authenticated;
        } else {
          // If in mock mode without Firebase active, fallback
          if (_user == null) {
            _status = AuthStatus.unauthenticated;
          }
        }
        notifyListeners();
      }, onError: (e) {
        AppLogger.e('AuthProvider', 'Auth state change error', e);
        _status = AuthStatus.unauthenticated;
        notifyListeners();
      });
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  // Fallback demo login for Mock / Offline mode
  void loginMockUser({required String email, required String name}) {
    _user = UserModel(
      uid: 'DEMO_FARMER_123',
      email: email,
      name: name,
      farmId: 'FARM_GREEN_VALLEY',
      createdAt: DateTime.now(),
    );
    _status = AuthStatus.authenticated;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password, {bool isMock = false}) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    if (isMock) {
      await Future.delayed(const Duration(milliseconds: 600));
      loginMockUser(email: email, name: "Green Valley Farmer");
      return true;
    }

    try {
      final userModel = await _authService.signInWithEmail(email, password);
      if (userModel != null) {
        _user = userModel;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = _cleanErrorMessage(e.toString());
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return false;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String farmName,
    required int cattleCount,
    bool isMock = false,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    if (isMock) {
      await Future.delayed(const Duration(milliseconds: 600));
      loginMockUser(email: email, name: name);
      return true;
    }

    try {
      final userModel = await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        farmName: farmName,
        cattleCount: cattleCount,
      );
      if (userModel != null) {
        _user = userModel;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = _cleanErrorMessage(e.toString());
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    return false;
  }

  Future<void> sendPasswordReset(String email, {bool isMock = false}) async {
    if (isMock) return;
    try {
      await _authService.sendPasswordReset(email);
    } catch (e) {
      _errorMessage = _cleanErrorMessage(e.toString());
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (_) {}
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  String _cleanErrorMessage(String errorStr) {
    if (errorStr.contains('user-not-found')) return 'No farmer account found with this email.';
    if (errorStr.contains('wrong-password')) return 'Incorrect password. Please try again.';
    if (errorStr.contains('email-already-in-use')) return 'An account already exists with this email.';
    if (errorStr.contains('weak-password')) return 'Password must be at least 6 characters.';
    if (errorStr.contains('invalid-email')) return 'Please enter a valid email address.';
    return 'Unable to connect to the login service. Please check your internet connection.';
  }
}
