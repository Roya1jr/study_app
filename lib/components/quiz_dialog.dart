import 'package:flutter/material.dart';
import 'package:study_app/models/models.dart';

class QuizDialog extends StatelessWidget {
  final Function(Quiz) onAdd;

  QuizDialog({super.key, required this.onAdd});

  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Quiz'),
      content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Quiz Title')),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            final quiz = Quiz(title: titleController.text, questions: []);
            onAdd(quiz);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
