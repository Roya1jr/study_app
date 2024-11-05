import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_app/assets/quiz.dart';
import 'package:study_app/components/navbar.dart';
import 'package:study_app/models/models.dart';

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

  final List<Course> _customCourses = [];
  List<Course> get customCourses => _customCourses;

  final List<Course> _courses = dbCourses;
  List<Course> get courses => _courses;

  final List<Course> _favorites = [];
  List<Course> get favorites => _favorites;

  void toggleFavorite(Course mycourse) {
    if (_favorites.contains(mycourse)) {
      _favorites.remove(mycourse);
    } else {
      _favorites.add(mycourse);
    }
    notifyListeners();
  }

  void addCourse(Course newCourse) {
    final existingCourseIndex = _customCourses.indexWhere(
      (course) => course.title == newCourse.title,
    );

    if (existingCourseIndex != -1) {
      _customCourses[existingCourseIndex] = newCourse;
      print("Updating existing course");
    } else {
      _customCourses.add(newCourse);
      print("Adding new course");
    }
    notifyListeners();
  }

  void removeCourse(Course mycourse) {
    _customCourses.remove(mycourse);
    notifyListeners();
  }

  void shareCourse(Course course) {
    if (!_courses.contains(course)) {
      _courses.add(course);
      print("Shared course: ${course.title}");
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
