import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_app/main.dart';
import 'package:study_app/views/content.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final courses = appState.favorites;

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
                appState.toggleFavorite(course);
              });
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final Function() onRemove;

  const CourseCard({super.key, required this.course, required this.onRemove});

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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseContentPage(course: course),
            ),
          );
        },
      ),
    );
  }
}
