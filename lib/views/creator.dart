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
  int currentQuizIndex = 0;
  String? _selectedImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _selectedImageUrl = widget.note!.imageUrl;
      flashCards = widget.note!.flashCards;
      quizzes = widget.note!.quizzes;
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      final selectedImageUrl = _selectedImageUrl ??
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg';

      final note = Note(
        imageUrl: selectedImageUrl,
        title: formData['title'],
        module: formData['module'],
        flashCards: flashCards,
        quizzes: quizzes,
      );

      final appState = Provider.of<MyAppState>(context, listen: false);
      appState.addNote(note);
      Navigator.pop(context);
    } else {}
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
    setState(() {
      quizzes[currentQuizIndex].questions.add(question);
    });
  }

  void _editQuizQuestion(Question question, int quizIndex, int questionIndex) {
    setState(() {
      quizzes[quizIndex].questions[questionIndex] = question;
    });
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select an Image:', style: TextStyle(fontSize: 16)),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._imageOptions.map((imageUrl) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImageUrl = imageUrl;
                      _formKey.currentState?.fields['image']
                          ?.didChange(imageUrl);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedImageUrl == imageUrl
                            ? const Color.fromARGB(255, 129, 188, 218)
                            : Colors.grey,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: _selectedImageUrl == imageUrl
                          ? [
                              BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  blurRadius: 4)
                            ]
                          : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        FormBuilderTextField(
          name: 'title',
          decoration: const InputDecoration(labelText: 'Note Title'),
          validator: FormBuilderValidators.required(),
        ),
        FormBuilderTextField(
          name: 'module',
          decoration: const InputDecoration(labelText: 'Module'),
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
          itemBuilder: (context, quizIndex) {
            return QuizWidget(
              quizIndex: quizIndex, // Pass the quiz index here
              quiz: quizzes[quizIndex],
              onAddQuestion: _addQuizQuestion,
              onDelete: () => setState(() => quizzes.removeAt(quizIndex)),
              onDeleteQuestion: (qIndex) =>
                  setState(() => quizzes[quizIndex].questions.removeAt(qIndex)),
              onEditQuestion: _editQuizQuestion,
            );
          },
        ),
      ],
    );
  }

  final List<String> _imageOptions = [
    'https://images.pexels.com/photos/256381/pexels-photo-256381.jpeg',
    'https://images.pexels.com/photos/159862/art-school-of-athens-raphael-italian-painter-fresco-159862.jpeg',
    'https://images.pexels.com/photos/8850742/pexels-photo-8850742.jpeg',
    'https://images.pexels.com/photos/95916/pexels-photo-95916.jpeg',
    'https://images.pexels.com/photos/40568/medical-appointment-doctor-healthcare-40568.jpeg',
    'https://images.pexels.com/photos/974314/pexels-photo-974314.jpeg',
    'https://images.pexels.com/photos/249798/pexels-photo-249798.png'
  ];
}
