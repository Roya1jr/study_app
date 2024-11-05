import 'package:flutter/material.dart';
import 'package:study_app/models/models.dart';

class FlashCardDialog extends StatelessWidget {
  final Function(FlashCard) onAdd;

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
            decoration: const InputDecoration(labelText: 'Question'),
          ),
          TextField(
            controller: answerController,
            decoration: const InputDecoration(labelText: 'Answer'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Create a FlashCard instance and pass it to the onAdd callback
            final flashCard = FlashCard(
              question: questionController.text,
              answer: answerController.text,
            );
            onAdd(flashCard); // Pass the instance directly
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
