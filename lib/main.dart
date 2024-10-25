import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  final List<Map<String, String>> _courses = [
    {
      'image':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'title': 'Introduction to Computer Science',
      'faculty': 'Faculty of Computer Science',
    },
    {
      'image':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'title': 'Data Structures & Algorithms',
      'faculty': 'Faculty of Computer Science',
    },
    {
      'image':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'title': 'Linear Algebra',
      'faculty': 'Faculty of Mathematics',
    },
    {
      'image':
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      'title': 'Marketing 101',
      'faculty': 'Faculty of Business',
    },
  ];
  List<Map<String, String>> get courses => _courses;
  void toggleCourses(Map<String, String> courseTitle) {
    if (_courses.contains(courseTitle)) {
      _courses.remove(courseTitle);
    } else {
      _courses.add(courseTitle);
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
