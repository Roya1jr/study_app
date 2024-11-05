import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_app/main.dart';
import 'package:study_app/views/creator.dart';

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = context.watch<MyAppState>().customCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('My Courses')),
      ),
      body: courses.isEmpty
          ? const Center(child: Text('No courses created.'))
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(course.title),
                    subtitle: Text(course.faculty),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatorPage(course: course),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatorPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
