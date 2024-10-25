import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_app/main.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final courses = appState.courses;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Courses"),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCard(
              course: course,
              onRemove: () {
                Provider.of<MyAppState>(context, listen: false)
                    .toggleCourses(course);
              });
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, String> course;
  final Function() onRemove;

  const CourseCard({required this.course, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(course['image']!),
        title: Text(course['title']!),
        subtitle: Text(course['faculty']!),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
