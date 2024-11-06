import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:study_app/components/cards.dart';
import 'package:study_app/main.dart';
import 'package:study_app/components/quiz_widget.dart';
import 'package:study_app/components/flashcard_dialog.dart';
import 'package:study_app/components/quiz_dialog.dart';
import 'package:study_app/models/models.dart';

class CreatorPage extends StatefulWidget {
  final Note? note;

  const CreatorPage({super.key, this.note});

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
    if (widget.note != null) {
      flashCards = widget.note!.flashCards;
      quizzes = widget.note!.quizzes;
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      final note = Note(
          imageUrl: formData['image'],
          title: formData['title'],
          faculty: formData['faculty'],
          flashCards: flashCards,
          quizzes: quizzes);

      final appState = Provider.of<MyAppState>(context, listen: false);
      appState.addNote(note);
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
      appBar: AppBar(
        title: const Text('Editor'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          initialValue: widget.note != null ? widget.note!.toJson() : {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNoteInfo(),
              const SizedBox(height: 20),
              _buildFlashCardsSection(),
              const SizedBox(height: 20),
              _buildQuizzesSection(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save Note'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteInfo() {
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
          decoration: const InputDecoration(labelText: 'Note Title'),
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
            return ListFlashCard(
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
