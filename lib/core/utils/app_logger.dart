import 'package:flutter/foundation.dart';

class AppLogger {
  static void d(String tag, String message) {
    if (kDebugMode) {
      print('[$tag] $message');
    }
  }

  static void e(String tag, String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('❌ ERROR [$tag] $message');
      if (error != null) print('Error details: $error');
      if (stackTrace != null) print('Stack trace: $stackTrace');
    }
  }

  static void i(String tag, String message) {
    if (kDebugMode) {
      print('ℹ️ INFO [$tag] $message');
    }
  }
}
