import 'package:flutter/material.dart';
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

  Future<void> scheduleDailyNotifications(
      Note note, List<List<int>> reminderTimes) async {
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

    for (List<int> time in reminderTimes) {
      final int hour = time[0];
      final int minute = time[1];
      final tz.TZDateTime scheduledTime =
          _nextInstanceOfTime(DateTime.now(), hour, minute);

      await _notificationsPlugin.zonedSchedule(
        note.title.hashCode + hour + minute,
        'Study Reminder',
        'Time to review: ${note.title}',
        scheduledTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.inexact,
      );
      print(
          "Reminder scheduled for ${scheduledTime.hour}:${scheduledTime.minute}");
    }
  }

  Future<void> cancelDailyNotifications(Note note) async {
    final times = [8, 14, 18]; // Example of predefined times
    for (int hour in times) {
      await _notificationsPlugin.cancel(note.title.hashCode + hour);
    }
    print("Daily notifications canceled for note: ${note.title}");
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime now, int hour, int minute) {
    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    return scheduledDate.isBefore(tz.TZDateTime.now(tz.local))
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }
}

class ReminderService {
  final NotificationService notificationService = NotificationService();

  Future<void> toggleReminder(Note note, bool isReminderSet,
      BuildContext context, List<List<int>> reminderTimes) async {
    if (isReminderSet) {
      await notificationService.cancelDailyNotifications(note);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Study reminders turned off."),
        ),
      );
    } else {
      if (reminderTimes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select a reminder time first."),
          ),
        );
      } else {
        await notificationService.scheduleDailyNotifications(
            note, reminderTimes);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Study reminders scheduled!"),
          ),
        );
      }
    }
  }
}
