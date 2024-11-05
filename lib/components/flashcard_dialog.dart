import 'package:flutter/material.dart';

class FlashCardDialog extends StatelessWidget {
  final Function(Map<String, dynamic>) onAdd;

  FlashCardDialog({super.key, required this.onAdd});

  final questionController = TextEditingController();
  final answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Flash Card'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question')),
          TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Answer')),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            onAdd({
              'question': questionController.text,
              'answer': answerController.text,
            });
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
