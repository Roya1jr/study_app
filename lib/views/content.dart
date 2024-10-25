import 'package:flutter/material.dart';

class CourseContentPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseContentPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course['title']),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Flashcards",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: course['flash_cards'].length,
              itemBuilder: (context, index) {
                final flashCard = course['flash_cards'][index];
                return Card(
                  child: ListTile(
                    title: Text(flashCard['question']),
                    subtitle: Text(flashCard['answer']),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Quizzes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: course['quizzes'].length,
              itemBuilder: (context, index) {
                final quiz = course['quizzes'][index];
                return Card(
                  child: ListTile(
                    title: Text(quiz['title']),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
