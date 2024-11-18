import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:study_app/models/models.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:path/path.dart';

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
    final times = [8, 14, 18];
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
    final path = join(dbPath, 'study_materials.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      imageUrl TEXT,
      title TEXT,
      module TEXT
    )''');

    await db.execute('''CREATE TABLE flashcards(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      noteId INTEGER,
      question TEXT,
      answer TEXT,
      FOREIGN KEY(noteId) REFERENCES notes(id)
    )''');

    await db.execute('''CREATE TABLE quizzes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      noteId INTEGER,
      title TEXT,
      FOREIGN KEY(noteId) REFERENCES notes(id)
    )''');

    await db.execute('''CREATE TABLE questions(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      quizId INTEGER,
      question TEXT,
      options TEXT,
      answer TEXT,
      FOREIGN KEY(quizId) REFERENCES quizzes(id)
    )''');
  }

  Future<void> insertNote(Note note) async {
    final db = await database;

    final noteId = await db.insert('notes', note.toJson());

    for (var flashCard in note.flashCards) {
      await db.insert('flashcards', {
        'noteId': noteId,
        'question': flashCard.question,
        'answer': flashCard.answer,
      });
    }

    for (var quiz in note.quizzes) {
      final quizId = await db.insert('quizzes', {
        'noteId': noteId,
        'title': quiz.title,
      });

      for (var question in quiz.questions) {
        await db.insert('questions', {
          'quizId': quizId,
          'question': question.question,
          'options': question.options.join(','),
          'answer': question.answer,
        });
      }
    }
  }

  Future<List<Note>> fetchNotes() async {
    final db = await database;
    final noteResults = await db.query('notes');
    List<Note> notes = [];

    for (var noteData in noteResults) {
      final note = Note.fromJson(noteData);

      final flashCardsResult = await db.query('flashcards',
          where: 'noteId = ?', whereArgs: [noteData['id']]);
      final flashCards =
          flashCardsResult.map((card) => FlashCard.fromJson(card)).toList();

      final quizzesResult = await db
          .query('quizzes', where: 'noteId = ?', whereArgs: [noteData['id']]);
      final List<Quiz> quizzes = [];

      for (var quizData in quizzesResult) {
        final quiz = Quiz.fromJson(quizData);

        final questionsResult = await db.query('questions',
            where: 'quizId = ?', whereArgs: [quizData['id']]);
        final questions =
            questionsResult.map((q) => Question.fromJson(q)).toList();
        quizzes.add(quiz.copyWith(questions: questions));
      }

      notes.add(note.copyWith(flashCards: flashCards, quizzes: quizzes));
    }

    return notes;
  }

  Future<void> removeNote(int noteId) async {
    final db = await database;
    await db.delete('flashcards', where: 'noteId = ?', whereArgs: [noteId]);
    await db.delete('quizzes', where: 'noteId = ?', whereArgs: [noteId]);
    await db.delete('questions',
        where: 'quizId IN (SELECT id FROM quizzes WHERE noteId = ?)',
        whereArgs: [noteId]);
    await db.delete('notes', where: 'id = ?', whereArgs: [noteId]);
  }
}
