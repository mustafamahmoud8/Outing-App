import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static bool _initialized = false;

  /// Initialize notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        print('Notification tapped: ${response.payload}');
      },
    );

    _initialized = true;
    print('✅ Notification service initialized');
  }

  /// Request notification permission
  static Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    
    if (status.isGranted) {
      print('✅ Notification permission granted');
      return true;
    } else {
      print('❌ Notification permission denied');
      return false;
    }
  }

  /// Show a local notification
  static Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails = 
          AndroidNotificationDetails(
        'outing_channel',
        'Outing Notifications',
        channelDescription: 'Notifications for Outing app',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iosDetails = 
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );

      print('✅ Notification sent: $title');
    } catch (e) {
      print('❌ Error showing notification: $e');
    }
  }

  /// Show a welcome notification
  static Future<void> showWelcomeNotification(String userName) async {
    await showNotification(
      id: 1,
      title: '👋 Welcome to Outing!',
      body: 'Hi $userName, start exploring amazing places near you!',
    );
  }

  /// Show a new offer notification
  static Future<void> showOfferNotification(String placeName, String offer) async {
    await showNotification(
      id: 2,
      title: '🎉 New Offer at $placeName',
      body: offer,
    );
  }

  /// Show a plan reminder notification
  static Future<void> showPlanReminder(String planDetails) async {
    await showNotification(
      id: 3,
      title: '📅 Plan Reminder',
      body: planDetails,
    );
  }

  /// Show a group message notification
  static Future<void> showGroupMessageNotification(String groupName, String message) async {
    await showNotification(
      id: 4,
      title: '💬 New message in $groupName',
      body: message,
    );
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
