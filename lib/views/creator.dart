import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:study_app/main.dart';
import 'package:study_app/components/flashcard_widget.dart';
import 'package:study_app/components/quiz_widget.dart';
import 'package:study_app/components/flashcard_dialog.dart';
import 'package:study_app/components/quiz_dialog.dart';
import 'package:study_app/models/models.dart';

class CreatorPage extends StatefulWidget {
  final Course? course;

  const CreatorPage({super.key, this.course});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<FlashCard> flashCards = [];
  List<Quiz> quizzes = [];
  int currentQuizIndex = -1;

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      flashCards = widget.course!.flashCards;
      quizzes = widget.course!.quizzes;
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      final course = Course(
          imageUrl: formData['image'],
          title: formData['title'],
          faculty: formData['faculty'],
          flashCards: flashCards,
          quizzes: quizzes);

      final appState = Provider.of<MyAppState>(context, listen: false);
      appState.addCourse(course);
      Navigator.pop(context);
    }
  }

  void _addFlashCard(FlashCard flashCard) {
    setState(() {
      flashCards.add(flashCard);
    });
  }

  void _addQuiz(Quiz quiz) {
    setState(() {
      quizzes.add(quiz);
      currentQuizIndex = quizzes.length - 1;
    });
  }

  void _addQuizQuestion(Question question) {
    if (currentQuizIndex != -1) {
      setState(() {
        quizzes[currentQuizIndex].questions.add(question);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create or Edit Course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          initialValue: widget.course != null ? widget.course!.toJson() : {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCourseInfo(),
              const SizedBox(height: 20),
              _buildFlashCardsSection(),
              const SizedBox(height: 20),
              _buildQuizzesSection(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save Course'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Column(
      children: [
        FormBuilderTextField(
          name: 'image',
          decoration: const InputDecoration(labelText: 'Image URL'),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.url(),
          ]),
        ),
        FormBuilderTextField(
          name: 'title',
          decoration: const InputDecoration(labelText: 'Course Title'),
          validator: FormBuilderValidators.required(),
        ),
        FormBuilderTextField(
          name: 'faculty',
          decoration: const InputDecoration(labelText: 'Faculty'),
          validator: FormBuilderValidators.required(),
        ),
      ],
    );
  }

  Widget _buildFlashCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Flash Cards',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => FlashCardDialog(onAdd: _addFlashCard),
              ),
              child: const Text('Add Flash Card'),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: flashCards.length,
          itemBuilder: (context, index) {
            return FlashCardWidget(
              flashCard: flashCards[index],
              onDelete: () => setState(() => flashCards.removeAt(index)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuizzesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Quizzes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => QuizDialog(onAdd: _addQuiz),
              ),
              child: const Text('Add Quiz'),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: quizzes.length,
          itemBuilder: (context, index) {
            return QuizWidget(
              quiz: quizzes[index],
              onAddQuestion: _addQuizQuestion,
              onDelete: () => setState(() => quizzes.removeAt(index)),
              onDeleteQuestion: (lindex) =>
                  setState(() => quizzes[index].questions.removeAt(lindex)),
            );
          },
        ),
      ],
    );
  }
}
