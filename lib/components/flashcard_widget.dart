import 'package:flutter/material.dart';
import 'package:study_app/models/models.dart';

class FlashCardWidget extends StatelessWidget {
  final FlashCard flashCard;
  final VoidCallback onDelete;

  const FlashCardWidget(
      {super.key, required this.flashCard, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(flashCard.question),
        subtitle: Text(flashCard.answer),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
