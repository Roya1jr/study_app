import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:study_app/main.dart';
import 'package:study_app/models/models.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:path/path.dart';

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

class NotificationException implements Exception {
  final String message;
  NotificationException(this.message);

  @override
  String toString() => 'NotificationException: $message';
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get notificationsPlugin =>
      _notificationsPlugin;

  Future<bool> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) {
      throw NotificationException('Failed to initialize Android notifications');
    }

    final bool? granted = await androidPlugin.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> initialize() async {
    try {
      tz.initializeTimeZones();

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
      );

      final bool permissionGranted = await _requestPermissions();
      if (!permissionGranted) {
        throw NotificationException('Notification permissions not granted');
      }

      await _notificationsPlugin.initialize(settings);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  int _generateNotificationId(Note note, int hour, int minute) {
    return ((note.id.hashCode) * 10000) + (hour * 100) + minute;
  }

  Future<void> scheduleDailyNotifications(
      Note note, List<List<int>> reminderTimes) async {
    try {
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

        if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
          throw NotificationException('Invalid time values: $hour:$minute');
        }

        final tz.TZDateTime scheduledTime =
            _nextInstanceOfTime(DateTime.now(), hour, minute);

        final int notificationId = _generateNotificationId(note, hour, minute);

        await _notificationsPlugin.zonedSchedule(
          notificationId,
          'Study Reminder',
          'Time to review: ${note.title}',
          scheduledTime,
          notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.wallClockTime,
          matchDateTimeComponents: DateTimeComponents.time,
          androidScheduleMode: AndroidScheduleMode.inexact,
        );
      }
    } catch (e) {
      throw NotificationException('Failed to schedule notifications: $e');
    }
  }

  Future<void> cancelDailyNotifications(
      Note note, List<List<int>> reminderTimes) async {
    try {
      for (List<int> time in reminderTimes) {
        final int hour = time[0];
        final int minute = time[1];
        final int notificationId = _generateNotificationId(note, hour, minute);
        await _notificationsPlugin.cancel(notificationId);
      }
    } catch (e) {
      throw NotificationException('Failed to cancel notifications: $e');
    }
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
  final NotificationService notificationService =
      serviceLocator<NotificationService>();
  ReminderService({required});

  Future<ReminderResult> toggleReminder(
      Note note, bool isReminderSet, List<List<int>> reminderTimes) async {
    try {
      if (reminderTimes.isEmpty) {
        return ReminderResult.error('Please select a reminder time first.');
      }

      if (isReminderSet) {
        await notificationService.cancelDailyNotifications(note, reminderTimes);
        return ReminderResult.success('Study reminders turned off.');
      } else {
        await notificationService.scheduleDailyNotifications(
            note, reminderTimes);
        return ReminderResult.success('Study reminders scheduled!');
      }
    } catch (e) {
      return ReminderResult.error('Failed to manage reminders: $e');
    }
  }
}

class ReminderResult {
  final bool success;
  final String message;

  ReminderResult.success(this.message) : success = true;
  ReminderResult.error(this.message) : success = false;
}

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'study_notes.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE custom_notes (
        id TEXT PRIMARY KEY,
        isShared INTEGER NOT NULL,
        creator TEXT NOT NULL,
        content TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE fetched_notes (
        id TEXT PRIMARY KEY,
        isShared INTEGER NOT NULL,
        creator TEXT NOT NULL,
        content TEXT NOT NULL,
        isFavourite INTEGER NOT NULL
      )
    ''');
  }

  Future<String> insertCustomNote(
      {required Note note,
      required int isShared,
      required String creator}) async {
    final db = await database;
    final id = note.id;
    debugPrint(note.imageUrl);

    // Check if note already exists
    final existingNote =
        await db.query('custom_notes', where: 'id = ?', whereArgs: [id]);

    final noteContent = {
      'image': note.imageUrl,
      'title': note.title,
      'module': note.module,
      'flash_cards': note.flashCards.map((fc) => fc.toJson()).toList(),
      'quizzes': note.quizzes.map((quiz) => quiz.toJson()).toList(),
    };

    if (existingNote.isNotEmpty) {
      // Note exists, update it
      await db.update(
          'custom_notes',
          {
            'isShared': isShared,
            'creator': creator,
            'content': json.encode(noteContent)
          },
          where: 'id = ?',
          whereArgs: [id]);
    } else {
      // Note doesn't exist, insert it
      await db.insert('custom_notes', {
        'id': id,
        'isShared': isShared,
        'creator': creator,
        'content': json.encode(noteContent)
      });
    }

    return id;
  }

  Future<String> insertFetchedNote(
      {required Note note,
      required bool isShared,
      required String creator,
      int isFavourite = 0}) async {
    final db = await database;
    final id = note.id;

    // Check if note already exists
    final existingNote =
        await db.query('fetched_notes', where: 'id = ?', whereArgs: [id]);

    final noteContent = {
      'image_url': note.imageUrl,
      'title': note.title,
      'module': note.module,
      'flash_cards': note.flashCards.map((fc) => fc.toJson()).toList(),
      'quizzes': note.quizzes.map((quiz) => quiz.toJson()).toList(),
    };

    if (existingNote.isNotEmpty) {
      // Note exists, update it
      await db.update(
          'fetched_notes',
          {
            'isShared': isShared,
            'creator': creator,
            'content': json.encode(noteContent),
            'isFavourite': isFavourite
          },
          where: 'id = ?',
          whereArgs: [id]);
    } else {
      // Note doesn't exist, insert it
      await db.insert('fetched_notes', {
        'id': id,
        'isShared': isShared,
        'creator': creator,
        'content': json.encode(noteContent),
        'isFavourite': isFavourite
      });
    }

    return id;
  }

  Future<List<Note>> fetchCustomNotes() async {
    final db = await database;
    final notes = await db.query('custom_notes');

    return notes.map((noteMap) {
      final content = json.decode(noteMap['content'] as String);
      return Note.fromJson(content, noteMap['id'] as String);
    }).toList();
  }

  Future<List<Note>> getSharedCustomNotes() async {
    final db = await database;
    final notes = await db.query(
      'custom_notes',
      where: 'isShared = ?',
      whereArgs: [1],
    );

    return notes.map((noteMap) {
      final content = json.decode(noteMap['content'] as String);
      return Note.fromJson(content, noteMap['id'] as String);
    }).toList();
  }

  Future<void> updateCustomNote(
      {required Note note, int? isShared, String? creator}) async {
    final db = await database;
    debugPrint(note.imageUrl);
    final updateData = <String, dynamic>{
      'content': json.encode({
        'image_url': note.imageUrl,
        'title': note.title,
        'module': note.module,
        'flash_cards': note.flashCards.map((fc) => fc.toJson()).toList(),
        'quizzes': note.quizzes.map((quiz) => quiz.toJson()).toList(),
      })
    };

    if (isShared != null) updateData['isShared'] = isShared;
    if (creator != null) updateData['creator'] = creator;

    await db.update('custom_notes', updateData,
        where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteCustomNote(String id) async {
    final db = await database;
    await db.delete('custom_notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Note>> fetchFetchedNotes() async {
    final db = await database;
    final notes = await db.query('fetched_notes');

    return notes.map((noteMap) {
      final content = json.decode(noteMap['content'] as String);
      final note = Note.fromJson(content, noteMap['id'] as String);
      return note.copyWith(
        id: noteMap['id'] as String,
      );
    }).toList();
  }

  Future<void> updateFetchedNote(
      {required Note note,
      bool? isShared,
      String? creator,
      bool? isFavourite}) async {
    final db = await database;

    final updateData = <String, dynamic>{
      'content': json.encode({
        'image_url': note.imageUrl,
        'title': note.title,
        'module': note.module,
        'flash_cards': note.flashCards.map((fc) => fc.toJson()).toList(),
        'quizzes': note.quizzes.map((quiz) => quiz.toJson()).toList(),
      })
    };

    if (isShared != null) updateData['isShared'] = isShared;
    if (creator != null) updateData['creator'] = creator;
    if (isFavourite != null) updateData['isFavourite'] = isFavourite;

    await db.update('fetched_notes', updateData,
        where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteFetchedNote(String id) async {
    final db = await database;
    await db.delete('fetched_notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
