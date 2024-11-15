import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_app/assets/quiz.dart';
import 'package:study_app/components/navbar.dart';
import 'package:study_app/components/notifications.dart';
import 'package:study_app/models/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.initialize();
  runApp(const MyApp());
}

class MyAppState extends ChangeNotifier {
  final List<Note> _createdNotes = [];
  List<Note> get customNotes => _createdNotes;

  final List<Note> _fetchedNotes = dbNotes;
  List<Note> get notes => _fetchedNotes;

  final List<Note> _favorites = [];
  List<Note> get favorites => _favorites;

  void toggleFavorite(Note mynote) {
    if (_favorites.contains(mynote)) {
      _favorites.remove(mynote);
    } else {
      _favorites.add(mynote);
    }
    notifyListeners();
  }

  void addNote(Note newNote) {
    final existingNoteIndex = _createdNotes.indexWhere(
      (note) => note.title == newNote.title,
    );

    if (existingNoteIndex != -1) {
      _createdNotes[existingNoteIndex] = newNote;
      print("Updating existing note");
    } else {
      _createdNotes.add(newNote);
      print("Adding new note");
    }
    notifyListeners();
  }

  void removeNote(Note mynote) {
    toggleFavorite(mynote);
    _createdNotes.remove(mynote);
    _fetchedNotes.remove(mynote);
    notifyListeners();
  }

  void shareNote(Note newNote) {
    final existingNoteIndex = _fetchedNotes.indexWhere(
      (note) => note.title == newNote.title,
    );

    if (existingNoteIndex != -1) {
      _fetchedNotes[existingNoteIndex] = newNote;
      print("Updating existing note");
    } else {
      _fetchedNotes.add(newNote);
      print("Adding new note");
    }
    notifyListeners();
  }

  static const TextStyle appBarStyle =
      TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "Study App",
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 14, 45, 94))),
        home: const BottomNavBar(),
      ),
    );
  }
}
