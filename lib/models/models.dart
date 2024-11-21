import 'package:uuid/uuid.dart';

class Note {
  final String id;
  final String title;
  final String imageUrl;
  final String module;
  final List<FlashCard> flashCards;
  final List<Quiz> quizzes;

  Note({
    String? id,
    required this.title,
    required this.imageUrl,
    required this.module,
    this.flashCards = const [],
    this.quizzes = const [],
  }) : id = id ?? const Uuid().v4();

  factory Note.fromJson(Map json, String? id) {
    return Note(
      id: id ?? const Uuid().v4(),
      imageUrl: json['image'] ?? '',
      title: json['title'] ?? '',
      module: json['module'] ?? '',
      flashCards: (json['flash_cards'] as List?)
              ?.map((card) => FlashCard.fromJson(card))
              .toList() ??
          [],
      quizzes: (json['quizzes'] as List?)
              ?.map((quiz) => Quiz.fromJson(quiz))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'title': title,
      'module': module,
      'flash_cards': flashCards.map((card) => card.toJson()).toList(),
      'quizzes': quizzes.map((quiz) => quiz.toJson()).toList(),
    };
  }

  // New method for API format
  Map<String, dynamic> toApiFormat() {
    return {
      'flash_cards': flashCards
          .map((card) => {
                'question': card.question,
                'answer': card.answer,
              })
          .toList(),
      'image': imageUrl,
      'module': module,
      'quizzes': quizzes
          .map((quiz) => {
                'title': quiz.title,
                'questions': quiz.questions
                    .map((question) => {
                          'question': question.question,
                          'options': question.options,
                          'answer': question.answer,
                        })
                    .toList(),
              })
          .toList(),
      'title': title,
    };
  }

  // New factory constructor for API format
  factory Note.fromApiFormat(Map<String, dynamic> json, {String? id}) {
    return Note(
      id: id,
      imageUrl: json['image'] ?? '',
      title: json['title'] ?? '',
      module: json['module'] ?? '',
      flashCards: (json['flash_cards'] as List?)
              ?.map((card) => FlashCard(
                    question: card['question'] ?? '',
                    answer: card['answer'] ?? '',
                  ))
              .toList() ??
          [],
      quizzes: (json['quizzes'] as List?)
              ?.map((quiz) => Quiz(
                    title: quiz['title'] ?? '',
                    questions: (quiz['questions'] as List?)
                            ?.map((q) => Question(
                                  question: q['question'] ?? '',
                                  options:
                                      List<String>.from(q['options'] ?? []),
                                  answer: q['answer'] ?? '',
                                ))
                            .toList() ??
                        [],
                  ))
              .toList() ??
          [],
    );
  }

  Note copyWith({
    String? id,
    String? imageUrl,
    String? title,
    String? module,
    List<FlashCard>? flashCards,
    List<Quiz>? quizzes,
  }) {
    return Note(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      module: module ?? this.module,
      flashCards: flashCards ?? this.flashCards,
      quizzes: quizzes ?? this.quizzes,
    );
  }
}

class FlashCard {
  final String question;
  final String answer;

  FlashCard({
    required this.question,
    required this.answer,
  });

  factory FlashCard.fromJson(Map<String, dynamic> json) {
    return FlashCard(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

class Quiz {
  final int? id;
  final String title;
  final List<Question> questions;

  Quiz({
    this.id = 0,
    required this.title,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'] ?? '',
      questions: (json['questions'] as List?)
              ?.map((q) => Question.fromJson(q))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  Quiz copyWith({
    int? id,
    String? title,
    List<Question>? questions,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      questions: questions ?? this.questions,
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final String answer;

  Question({
    required this.question,
    required this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'answer': answer,
    };
  }
}
