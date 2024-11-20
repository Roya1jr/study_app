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
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'study_materials.db');
      return openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
    } catch (e) {
      throw DatabaseException('Failed to initialize database: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute('''
       CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          image_url TEXT,
          title TEXT NOT NULL,
          module TEXT NOT NULL,
          created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      await txn.execute('''
        CREATE UNIQUE INDEX idx_notes_id ON notes(id)
      ''');

      await txn.execute('''
        CREATE TABLE flashcards(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          noteId INTEGER NOT NULL,
          question TEXT NOT NULL,
          answer TEXT NOT NULL,
          FOREIGN KEY(noteId) REFERENCES notes(id) ON DELETE CASCADE
        )
      ''');

      await txn.execute('''
        CREATE TABLE quizzes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          noteId INTEGER NOT NULL,
          title TEXT NOT NULL,
          FOREIGN KEY(noteId) REFERENCES notes(id) ON DELETE CASCADE
        )
      ''');

      await txn.execute('''
        CREATE TABLE questions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          quizId INTEGER NOT NULL,
          question TEXT NOT NULL,
          options TEXT NOT NULL,
          answer TEXT NOT NULL,
          FOREIGN KEY(quizId) REFERENCES quizzes(id) ON DELETE CASCADE
        )
      ''');
    });
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  Future<bool> isIdUnique(String id) async {
    try {
      final db = await database;
      final result = await db.query(
        'notes',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return result.isEmpty;
    } catch (e) {
      throw DatabaseException('Failed to check id uniqueness: $e');
    }
  }

  Future<int> insertNote(Note note) async {
    try {
      final db = await database;
      int noteId = 0;

      if (!await isIdUnique(note.id!)) {
        throw DatabaseException('Note with ID ${note.id} already exists');
      }

      await db.transaction((txn) async {
        if (note.title.isEmpty || note.module.isEmpty) {
          throw DatabaseException('Note title and module cannot be empty');
        }

        noteId = await txn.insert(
          'notes',
          {
            ...note.toJson(),
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.abort,
        );

        for (var flashCard in note.flashCards) {
          await txn.insert('flashcards', {
            'noteId': noteId,
            'question': flashCard.question,
            'answer': flashCard.answer,
          });
        }

        for (var quiz in note.quizzes) {
          final quizId = await txn.insert('quizzes', {
            'noteId': noteId,
            'title': quiz.title,
          });

          for (var question in quiz.questions) {
            await txn.insert('questions', {
              'quizId': quizId,
              'question': question.question,
              'options': question.options.join(','),
              'answer': question.answer,
            });
          }
        }
      });

      return noteId;
    } catch (e) {
      throw DatabaseException('Failed to insert note: $e');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      final db = await database;

      await db.transaction((txn) async {
        if (note.title.isEmpty || note.module.isEmpty) {
          throw DatabaseException('Note title and module cannot be empty');
        }

        await txn.update(
          'notes',
          {
            ...note.toJson(),
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [note.id],
          conflictAlgorithm: ConflictAlgorithm.abort,
        );

        // Delete existing related records
        await txn
            .delete('flashcards', where: 'noteId = ?', whereArgs: [note.id]);
        await txn.delete('quizzes', where: 'noteId = ?', whereArgs: [note.id]);

        // Reinsert flashcards
        for (var flashCard in note.flashCards) {
          await txn.insert('flashcards', {
            'noteId': note.id,
            'question': flashCard.question,
            'answer': flashCard.answer,
          });
        }

        // Reinsert quizzes and their questions
        for (var quiz in note.quizzes) {
          final quizId = await txn.insert('quizzes', {
            'noteId': note.id,
            'title': quiz.title,
          });

          for (var question in quiz.questions) {
            await txn.insert('questions', {
              'quizId': quizId,
              'question': question.question,
              'options': question.options.join(','),
              'answer': question.answer,
            });
          }
        }
      });
    } catch (e) {
      throw DatabaseException('Failed to update note: $e');
    }
  }

  Future<List<Note>> fetchNotes() async {
    try {
      final db = await database;

      // Fetch all data in a single query using JOINs
      final results = await db.rawQuery('''
        SELECT 
          n.id as note_id, 
          n.image_url, 
          n.title as note_title, 
          n.module,
          f.id as flashcard_id, 
          f.question as flashcard_question, 
          f.answer as flashcard_answer,
          q.id as quiz_id, 
          q.title as quiz_title,
          qs.id as question_id,
          qs.question as quiz_question,
          qs.options as quiz_options,
          qs.answer as quiz_answer
        FROM notes n
        LEFT JOIN flashcards f ON f.noteId = n.id
        LEFT JOIN quizzes q ON q.noteId = n.id
        LEFT JOIN questions qs ON qs.quizId = q.id
        ORDER BY n.id
      ''');

      // Process results into Note objects
      final Map<String, Note> notesMap = {};
      final Map<int, Quiz> quizzesMap = {};

      for (final row in results) {
        final noteId = row['note_id'] as String;

        final note = notesMap.putIfAbsent(
          noteId,
          () => Note(
            id: noteId,
            imageUrl: row['image_url'] as String,
            title: row['note_title'] as String,
            module: row['module'] as String,
            flashCards: [],
            quizzes: [],
          ),
        );

        if (row['flashcard_id'] != null) {
          final flashcard = FlashCard(
            question: row['flashcard_question'] as String,
            answer: row['flashcard_answer'] as String,
          );
          if (!note.flashCards.contains(flashcard)) {
            note.flashCards.add(flashcard);
          }
        }

        if (row['quiz_id'] != null) {
          final quizId = row['quiz_id'] as int;
          final quiz = quizzesMap.putIfAbsent(
            quizId,
            () {
              final newQuiz = Quiz(
                title: row['quiz_title'] as String,
                questions: [],
              );
              note.quizzes.add(newQuiz);
              return newQuiz;
            },
          );

          if (row['question_id'] != null) {
            final question = Question(
              question: row['quiz_question'] as String,
              options: (row['quiz_options'] as String).split(','),
              answer: row['quiz_answer'] as String,
            );
            if (!quiz.questions.contains(question)) {
              quiz.questions.add(question);
            }
          }
        }
      }

      return notesMap.values.toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch notes: $e');
    }
  }

  Future<void> removeNote(String id) async {
    try {
      final db = await database;
      final result = await db.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result == 0) {
        throw DatabaseException('Note not found with id: $id');
      }
    } catch (e) {
      throw DatabaseException('Failed to remove note: $e');
    }
  }
}
