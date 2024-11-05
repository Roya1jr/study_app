import 'package:flutter/material.dart';
import 'package:study_app/models/models.dart';

class QuizQuestionDialog extends StatefulWidget {
  final Function(Question) onAdd;

  const QuizQuestionDialog({super.key, required this.onAdd});

  @override
  QuizQuestionDialogState createState() => QuizQuestionDialogState();
}

class QuizQuestionDialogState extends State<QuizQuestionDialog> {
  final questionController = TextEditingController();
  final optionsControllers = List.generate(4, (_) => TextEditingController());
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Quiz Question'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            for (int i = 0; i < optionsControllers.length; i++)
              TextField(
                controller: optionsControllers[i],
                decoration: InputDecoration(labelText: 'Option ${i + 1}'),
                onChanged: (value) {
                  setState(() {
                    if (selectedAnswer == optionsControllers[i].text) {
                      selectedAnswer = value;
                    }
                  });
                },
              ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedAnswer,
              hint: const Text('Select Correct Answer'),
              items: _generateDropdownItems(),
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Correct Answer',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (questionController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a question')),
              );
              return;
            }

            final options = optionsControllers
                .where((controller) => controller.text.isNotEmpty)
                .map((controller) => controller.text)
                .toList();

            if (options.length < 2) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please enter at least 2 options')),
              );
              return;
            }

            if (selectedAnswer == null || selectedAnswer!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please select the correct answer')),
              );
              return;
            }
            final question = Question(
                question: questionController.text,
                options: options,
                answer: selectedAnswer!);

            widget.onAdd(question);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _generateDropdownItems() {
    return optionsControllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => DropdownMenuItem<String>(
              value: controller.text,
              child: Text(controller.text),
            ))
        .toList();
  }
}
