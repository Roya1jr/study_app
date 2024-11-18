import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_app/components/navbar.dart';
import 'package:study_app/utils/tools.dart';
import 'package:study_app/models/models.dart';
import 'package:study_app/views/custom_notes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.initialize();
  runApp(const MyApp());
}

class MyAppState extends ChangeNotifier {
  final List<Note> _createdNotes = [];
  List<Note> get customNotes => _createdNotes;

  List<Note> _fetchedNotes = [];
  List<Note> get notes => _fetchedNotes;

  final List<Note> _favorites = [];
  List<Note> get favorites => _favorites;

  bool _loginstatus = false;
  bool get loginstatus => _loginstatus;

  void toggleFavorite(Note mynote) {
    if (_favorites.contains(mynote)) {
      _favorites.remove(mynote);
    } else {
      _favorites.add(mynote);
    }
    notifyListeners();
  }

  void toggleLoginStatus() {
    _loginstatus = !_loginstatus;
    notifyListeners();
  }

  Future<void> fetchNotes() async {
    _fetchedNotes = await DatabaseHelper.instance.fetchNotes();
    notifyListeners();
  }

  void addNote(Note newNote) async {
    await DatabaseHelper.instance.insertNote(newNote);
    _fetchedNotes = await DatabaseHelper.instance.fetchNotes();
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

  void removeNote(Note mynote) async {
    await DatabaseHelper.instance.removeNote(mynote.id);
    _fetchedNotes = await DatabaseHelper.instance.fetchNotes();
    toggleFavorite(mynote);
    notifyListeners();
  }

  void login() {
    _loginstatus = true;
    notifyListeners();
  }

  void logout() {
    _loginstatus = false;
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
      child: Consumer<MyAppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: "Study App",
            theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color.fromARGB(255, 14, 45, 94))),
            home: appState.loginstatus
                ? const BottomNavBar()
                : const Center(
                    child: NoteListPage(),
                  ),
          );
        },
      ),
    );
  }
}
