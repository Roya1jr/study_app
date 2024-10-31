import 'package:flutter/material.dart';

class QuizDialog extends StatelessWidget {
  final Function(Map<String, dynamic>) onAdd;

  QuizDialog({required this.onAdd});

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
            onAdd({
              'title': titleController.text,
              'questions': [],
            });
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
