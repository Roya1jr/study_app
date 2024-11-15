import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:study_app/models/models.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get notificationsPlugin =>
      _notificationsPlugin;

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  Future<void> scheduleDailyNotifications(Note note) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'daily_study_channel',
      'Daily Study Reminders',
      channelDescription: 'Reminders to study your favorite notes daily',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    final times = [8, 14, 18];

    for (int hour in times) {
      final tz.TZDateTime scheduledTime =
          _nextInstanceOfTime(DateTime.now(), hour);

      await _notificationsPlugin.zonedSchedule(
        note.title.hashCode + hour,
        'Study Reminder',
        'Time to review: ${note.title}',
        scheduledTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.inexact,
      );
      print("Daily notification scheduled for ${scheduledTime.hour}:00");
    }
  }

  Future<void> cancelDailyNotifications(Note note) async {
    final times = [8, 14, 18];
    for (int hour in times) {
      await _notificationsPlugin.cancel(note.title.hashCode + hour);
    }
    print("Daily notifications canceled for note: ${note.title}");
  }

  Future<void> printPendingNotifications() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    print("Pending Notifications: $pending");
  }
}

tz.TZDateTime _nextInstanceOfTime(DateTime now, int hour) {
  final tz.TZDateTime scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    hour,
    0,
    0,
  );

  return scheduledDate.isBefore(tz.TZDateTime.now(tz.local))
      ? scheduledDate.add(const Duration(days: 1))
      : scheduledDate;
}
