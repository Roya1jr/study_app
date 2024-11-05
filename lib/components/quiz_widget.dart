import 'package:flutter/material.dart';
import 'package:study_app/components/quiz_question_dialog.dart';

class QuizWidget extends StatelessWidget {
  final Map<String, dynamic> quiz;
  final Function(Map<String, dynamic>) onAddQuestion;
  final VoidCallback onDelete;

  const QuizWidget(
      {super.key,
      required this.quiz,
      required this.onAddQuestion,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(quiz['title']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          QuizQuestionDialog(onAdd: onAddQuestion),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
          if (quiz['questions'] != null || quiz['questions'].isEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quiz['questions'].length,
              itemBuilder: (context, qIndex) {
                final question = quiz['questions'][qIndex];
                return ListTile(
                  title: Text(question['question']),
                  subtitle: Text('Answer: ${question['answer']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      quiz['questions'].removeAt(qIndex);
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
