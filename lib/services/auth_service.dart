import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/utils/app_logger.dart';
import '../models/user_model.dart';

class AuthService {
  FirebaseAuth? get _auth {
    try {
      if (Firebase.apps.isNotEmpty) {
        return FirebaseAuth.instance;
      }
    } catch (_) {}
    return null;
  }

  // Stream of user auth state
  Stream<User?> get authStateChanges {
    try {
      final auth = _auth;
      if (auth != null) {
        return auth.authStateChanges();
      }
    } catch (e) {
      AppLogger.e('AuthService', 'Error getting authStateChanges', e);
    }
    return Stream.value(null);
  }

  User? get currentUser {
    try {
      return _auth?.currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final auth = _auth;
      if (auth == null) return null;
      
      AppLogger.i('AuthService', 'Attempting sign in for: $email');
      final UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        return UserModel(
          uid: user.uid,
          email: user.email ?? email,
          name: user.displayName ?? 'Farmer',
          farmId: 'FARM_${user.uid.substring(0, 6).toUpperCase()}',
          createdAt: DateTime.now(),
        );
      }
    } catch (e, st) {
      AppLogger.e('AuthService', 'Sign in failed', e, st);
      rethrow;
    }
    return null;
  }

  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String farmName,
    required int cattleCount,
  }) async {
    try {
      final auth = _auth;
      if (auth == null) return null;

      AppLogger.i('AuthService', 'Registering new farmer: $email');
      final UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        final farmId = 'FARM_${user.uid.substring(0, 6).toUpperCase()}';
        return UserModel(
          uid: user.uid,
          email: user.email ?? email,
          name: name,
          farmId: farmId,
          createdAt: DateTime.now(),
        );
      }
    } catch (e, st) {
      AppLogger.e('AuthService', 'Registration failed', e, st);
      rethrow;
    }
    return null;
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      final auth = _auth;
      if (auth != null) {
        await auth.sendPasswordResetEmail(email: email.trim());
      }
    } catch (e, st) {
      AppLogger.e('AuthService', 'Password reset failed', e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      final auth = _auth;
      if (auth != null) {
        await auth.signOut();
      }
    } catch (e, st) {
      AppLogger.e('AuthService', 'Sign out error', e, st);
    }
  }
}
