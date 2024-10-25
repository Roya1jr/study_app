import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_app/assets/quiz.dart';
import 'package:study_app/components/navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyAppState extends ChangeNotifier {
  var username = "";
  var password = "";
  var token = "";
  void verifyLogin(String uname, pass, tkn) {
    username = uname;
    password = pass;
    token = tkn;
    notifyListeners();
  }

  final List<Map<String, dynamic>> _courses = lCourses;
  List<Map<String, dynamic>> get courses => _courses;
  final List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> get favorites => _favorites;
  void toggleFavorite(Map<String, dynamic> mycourse) {
    if (_favorites.contains(mycourse)) {
      _favorites.remove(mycourse);
    } else {
      _favorites.add(mycourse);
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
                seedColor: const Color.fromARGB(255, 29, 24, 18))),
        home: const BottomNavBar(),
      ),
    );
  }
}
