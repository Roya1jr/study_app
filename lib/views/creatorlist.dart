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
        title: const Text('My Courses'),
        centerTitle: true,
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
                    trailing: PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreatorPage(course: course),
                            ),
                          );
                        } else if (value == 'share') {
                          context.read<MyAppState>().shareCourse(course);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${course.title} shared!')),
                          );
                        } else if (value == 'delete') {
                          context.read<MyAppState>().removeCourse(course);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${course.title} deleted!')),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'share',
                            child: Text('Share'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ];
                      },
                    ),
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
