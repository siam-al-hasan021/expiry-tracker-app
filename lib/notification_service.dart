import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Chrome/Web does not support flutter_local_notifications
    if (kIsWeb) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings);

    // Android 13+ notification permission
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'expiry_channel',
      'Expiry Notifications',
      channelDescription:
          'Notifications for expiring products',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}