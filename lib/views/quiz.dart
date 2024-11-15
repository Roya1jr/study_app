import 'package:flutter/material.dart';
import 'package:study_app/models/models.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen({super.key, required this.quiz});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  List<int> correctAnswers = [];

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = widget.quiz.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Q${currentQuestionIndex + 1}: ${currentQuestion.question}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ...currentQuestion.options.map((option) {
                return ListTile(
                  title: Text(option),
                  leading: Radio<String>(
                    value: option,
                    groupValue: selectedAnswer,
                    onChanged: (String? value) {
                      setState(() {
                        selectedAnswer = value;
                      });
                    },
                  ),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedAnswer == null
                    ? null
                    : () {
                        if (selectedAnswer == currentQuestion.answer) {
                          correctAnswers.add(currentQuestionIndex);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Correct!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Incorrect.')),
                          );
                        }
                        setState(() {
                          if (currentQuestionIndex <
                              widget.quiz.questions.length - 1) {
                            currentQuestionIndex++;
                            selectedAnswer = null;
                          } else {
                            _showResultsDialog();
                          }
                        });
                      },
                child: Text(
                    currentQuestionIndex < widget.quiz.questions.length - 1
                        ? 'Next Question'
                        : 'Finish'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResultsDialog() {
    int totalQuestions = widget.quiz.questions.length;
    int correctCount = correctAnswers.length;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quiz Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'You answered $correctCount out of $totalQuestions correctly!'),
              const SizedBox(height: 20),
              if (correctAnswers.isNotEmpty)
                Text(
                  'Correct Answers for Questions: ${correctAnswers.map((index) => index + 1).join(', ')}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
