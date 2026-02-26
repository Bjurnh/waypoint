import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Simple wrapper around flutter_local_notifications for scheduling
/// and displaying local reminders or announcements.
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize plugin (call early, e.g. in main())
  static Future<void> initialize({
    AndroidInitializationSettings? androidSettings,
    DarwinInitializationSettings? iosSettings,
    LinuxInitializationSettings? linuxSettings,
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
  }) async {
    // initialize timezone database for zonedSchedule
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));

    const defaultAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const defaultIos = DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      android: androidSettings ?? defaultAndroid,
      iOS: iosSettings ?? defaultIos,
      linux: linuxSettings,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse ?? _onSelectNotification,
    );
  }

  static void _onSelectNotification(NotificationResponse response) {
    // handle tap on notification
    // we could navigate or update state via a global navigator key
    // for now this is a stub
  }

  /// Show a simple immediate notification (title/body)
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'waypoint_channel',
          'Waypoint Notifications',
          channelDescription: 'General notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  /// Schedule a notification at [scheduledDate]
  /// [scheduledDate] is converted to a [tz.TZDateTime] in the local time zone.
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'waypoint_channel',
          'Waypoint Notifications',
          channelDescription: 'Scheduled reminders',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  /// Cancel a scheduled notification
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id: id);
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
