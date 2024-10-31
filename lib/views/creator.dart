import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:study_app/main.dart';

class CreatorPage extends StatefulWidget {
  final Map<String, dynamic>? course;

  const CreatorPage({super.key, this.course});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<Map<String, dynamic>> flashCards = [];
  List<Map<String, dynamic>> quizzes = [];
  int currentQuizIndex = -1;

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      flashCards =
          List<Map<String, dynamic>>.from(widget.course!['flash_cards'] ?? []);
      quizzes =
          List<Map<String, dynamic>>.from(widget.course!['quizzes'] ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create or Edit Course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          initialValue: widget.course != null
              ? {
                  'image': widget.course!['image'],
                  'title': widget.course!['title'],
                  'faculty': widget.course!['faculty'],
                }
              : {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Flash Cards',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: _addFlashCard,
                    child: const Text('Add Flash Card'),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: flashCards.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(flashCards[index]['question']),
                      subtitle: Text(flashCards[index]['answer']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            flashCards.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Quizzes',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: _addQuiz,
                    child: const Text('Add Quiz'),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(quizzes[index]['title']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    currentQuizIndex = index;
                                  });
                                  _addQuizQuestion();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    quizzes.removeAt(index);
                                    if (currentQuizIndex == index) {
                                      currentQuizIndex = -1;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        if (quizzes[index]['questions'] != null)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: quizzes[index]['questions'].length,
                            itemBuilder: (context, qIndex) {
                              return ListTile(
                                title: Text(quizzes[index]['questions'][qIndex]
                                    ['question']),
                                subtitle: Text(
                                    'Answer: ${quizzes[index]['questions'][qIndex]['answer']}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      quizzes[index]['questions']
                                          .removeAt(qIndex);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),
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

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      final courseData = {
        'image': formData['image'],
        'title': formData['title'],
        'faculty': formData['faculty'],
        'flash_cards': flashCards,
        'quizzes': quizzes,
      };

      final appState = Provider.of<MyAppState>(context, listen: false);
      appState.addCourse(courseData);

      Navigator.pop(context);
    }
  }

  void _addFlashCard() {
    showDialog(
      context: context,
      builder: (context) {
        final questionController = TextEditingController();
        final answerController = TextEditingController();

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
                setState(() {
                  flashCards.add({
                    'question': questionController.text,
                    'answer': answerController.text,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addQuiz() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Quiz'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Quiz Title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  quizzes.add({
                    'title': titleController.text,
                    'questions': [],
                  });
                  currentQuizIndex = quizzes.length - 1;
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addQuizQuestion() {
    if (currentQuizIndex == -1) return;

    showDialog(
      context: context,
      builder: (context) {
        final questionController = TextEditingController();
        final option1Controller = TextEditingController();
        final option2Controller = TextEditingController();
        final option3Controller = TextEditingController();
        final option4Controller = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            List<DropdownMenuItem<String>> generateDropdownItems() {
              return [
                option1Controller,
                option2Controller,
                option3Controller,
                option4Controller,
              ]
                  .map((controller) {
                    final text = controller.text.trim();
                    return DropdownMenuItem<String>(
                      value: text,
                      child: Text(text.isEmpty ? 'Option not filled' : text),
                    );
                  })
                  .where((item) => item.value!.isNotEmpty)
                  .toList();
            }

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
                    TextField(
                      controller: option1Controller,
                      decoration: const InputDecoration(labelText: 'Option 1'),
                      onChanged: (value) => setState(() {}),
                    ),
                    TextField(
                      controller: option2Controller,
                      decoration: const InputDecoration(labelText: 'Option 2'),
                      onChanged: (value) => setState(() {}),
                    ),
                    TextField(
                      controller: option3Controller,
                      decoration: const InputDecoration(labelText: 'Option 3'),
                      onChanged: (value) => setState(() {}),
                    ),
                    TextField(
                      controller: option4Controller,
                      decoration: const InputDecoration(labelText: 'Option 4'),
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: option1Controller,
                      builder: (context, _, __) =>
                          ValueListenableBuilder<TextEditingValue>(
                        valueListenable: option2Controller,
                        builder: (context, _, __) =>
                            ValueListenableBuilder<TextEditingValue>(
                          valueListenable: option3Controller,
                          builder: (context, _, __) =>
                              ValueListenableBuilder<TextEditingValue>(
                            valueListenable: option4Controller,
                            builder: (context, _, __) {
                              final items = generateDropdownItems();
                              return DropdownButtonFormField<String>(
                                value: null,
                                hint: const Text('Select Correct Answer'),
                                items: items,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Correct Answer',
                                  border: OutlineInputBorder(),
                                ),
                              );
                            },
                          ),
                        ),
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
                        const SnackBar(
                            content: Text('Please enter a question')),
                      );
                      return;
                    }

                    final options = [
                      option1Controller.text.trim(),
                      option2Controller.text.trim(),
                      option3Controller.text.trim(),
                      option4Controller.text.trim(),
                    ].where((option) => option.isNotEmpty).toList();

                    if (options.length < 2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter at least 2 options')),
                      );
                      return;
                    }

                    final selectedAnswer = generateDropdownItems()
                        .firstWhere((item) => item.value!.isNotEmpty,
                            orElse: () => generateDropdownItems().first)
                        .value;

                    setState(() {
                      quizzes[currentQuizIndex]['questions'].add({
                        'question': questionController.text,
                        'options': options,
                        'answer': selectedAnswer,
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
