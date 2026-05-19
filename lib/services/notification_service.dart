import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../core/platform.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized || !AppPlatform.supportsNativeNotifications) return;
    try {
      const init = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      );
      await _plugin.initialize(init);
      _initialized = true;
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  Future<void> notify({
    required BuildContext? context,
    required String title,
    required String body,
  }) async {
    if (AppPlatform.supportsNativeNotifications) {
      try {
        await _plugin.show(
          DateTime.now().millisecondsSinceEpoch.remainder(1 << 31),
          title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'bookings_channel',
              'Bookings',
              channelDescription: 'Booking notifications',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );
        return;
      } catch (e) {
        debugPrint('NotificationService.notify native error: $e');
      }
    }
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$title — $body')),
      );
    }
  }
}
