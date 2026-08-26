import 'package:firebase_messaging/firebase_messaging.dart';
import '../core/utils/app_logger.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    try {
      AppLogger.i('NotificationService', 'Initializing Firebase Cloud Messaging...');
      
      // Request permission on iOS / Android 13+
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      AppLogger.i('NotificationService', 'FCM permission status: ${settings.authorizationStatus}');

      // Get FCM Token for server notifications
      final token = await _fcm.getToken();
      AppLogger.i('NotificationService', 'FCM Token: $token');

      // Foreground message handling
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        AppLogger.i('NotificationService', 'Foreground FCM message: ${message.notification?.title}');
      });

      // Background notification tap handling
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        AppLogger.i('NotificationService', 'FCM notification opened app');
      });

    } catch (e, st) {
      AppLogger.e('NotificationService', 'Failed to initialize FCM', e, st);
    }
  }

  Future<void> subscribeToDeviceTopic(String deviceId) async {
    try {
      await _fcm.subscribeToTopic('device_$deviceId');
      AppLogger.i('NotificationService', 'Subscribed to FCM topic: device_$deviceId');
    } catch (e) {
      AppLogger.e('NotificationService', 'Failed to subscribe to topic', e);
    }
  }
}
