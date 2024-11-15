import 'package:flutter/material.dart';
import 'package:study_app/components/quiz_question_dialog.dart';
import 'package:study_app/models/models.dart';

class QuizWidget extends StatelessWidget {
  final int quizIndex;
  final Quiz quiz;
  final Function(Question) onAddQuestion;
  final Function(Question, int, int) onEditQuestion;
  final Function(int) onDeleteQuestion;
  final VoidCallback onDelete;

  const QuizWidget({
    super.key,
    required this.quizIndex,
    required this.quiz,
    required this.onAddQuestion,
    required this.onEditQuestion,
    required this.onDelete,
    required this.onDeleteQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(quiz.title),
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
          if (quiz.questions.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quiz.questions.length,
              itemBuilder: (context, qIndex) {
                final question = quiz.questions[qIndex];
                return ListTile(
                  title: Text(question.question),
                  subtitle: Text('Answer: ${question.answer}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => QuizQuestionDialog(
                              initialQuestion: question,
                              onAdd: (editedQuestion) {
                                onEditQuestion(
                                    editedQuestion, quizIndex, qIndex);
                              },
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          onDeleteQuestion(qIndex);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          if (quiz.questions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No questions added yet.'),
            ),
        ],
      ),
    );
  }
}
