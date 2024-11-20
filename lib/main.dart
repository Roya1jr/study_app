import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:study_app/components/navbar.dart';
import 'package:study_app/utils/tools.dart';
import 'package:study_app/models/models.dart';
import 'package:study_app/views/custom_notes.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://10.0.2.2:8090');

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServices() async {
  final notificationService = NotificationService();
  await notificationService.initialize();

  serviceLocator.registerSingleton<NotificationService>(notificationService);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServices();

  await DatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyAppState extends ChangeNotifier {
  MyAppState() {
    _initializeNotes();
  }
  String loginToken = "";
  List<Note> _createdNotes = [];
  List<Note> get customNotes => _createdNotes;

  List<Note> _fetchedNotes = [];
  List<Note> get notes => _fetchedNotes;

  final List<Note> _favorites = [];
  List<Note> get favorites => _favorites;

  bool _loginstatus = false;
  bool get loginstatus => _loginstatus;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> _initializeNotes() async {
    try {
      _isLoading = true;
      notifyListeners();

      await fetchCustomNotes();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error initializing notes: $e');
    }
  }

  Future<void> fetchNotes() async {
    try {
      final records = await pb.collection('notes').getFullList(
            sort: '-created',
          );

      _fetchedNotes = records.map((record) {
        return Note.fromJson(record.data["content"], record.id);
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

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

  Future<bool> userLogin(String email, password) async {
    try {
      final authData = await pb.collection('users').authWithPassword(
            email,
            password,
          );
      debugPrint(pb.authStore.isValid.toString());
      debugPrint(pb.authStore.token);
      debugPrint(pb.authStore.model.id);
      if (pb.authStore.isValid) {
        _loginstatus = pb.authStore.isValid;
        loginToken = authData.token;
        notifyListeners();
        return loginstatus;
      }
    } catch (e) {
      return loginstatus;
    }
    return loginstatus;
  }

  Future<void> fetchCustomNotes() async {
    try {
      _createdNotes = await DatabaseHelper.instance.fetchNotes();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching notes: $e');
    }
  }

  Future<void> addNote(Note newNote) async {
    try {
      await DatabaseHelper.instance.insertNote(newNote);
      await fetchCustomNotes();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding note: $e');
    }
  }

  void shareNote(Note newNote) async {
    try {
      final existingNoteIndex = _fetchedNotes.indexWhere(
        (note) => note.title == newNote.title,
      );

      if (existingNoteIndex != -1) {
        _fetchedNotes[existingNoteIndex] = newNote;
        debugPrint("Updating existing note");
      } else {
        await DatabaseHelper.instance.insertNote(newNote);
        await fetchCustomNotes();
        debugPrint("Adding new note");
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error sharing note: $e');
    }
  }

  Future<void> removeNote(Note mynote) async {
    try {
      await DatabaseHelper.instance.removeNote(mynote.id!);
      await fetchCustomNotes();

      if (_favorites.contains(mynote)) {
        toggleFavorite(mynote);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error removing note: $e');
    }
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
                seedColor: const Color.fromARGB(255, 14, 45, 94),
              ),
            ),
            home: appState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : appState.loginstatus
                    ? const BottomNavBar()
                    : const Center(child: NoteListPage()),
          );
        },
      ),
    );
  }
}
