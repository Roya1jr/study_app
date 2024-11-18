class Note {
  final int id;
  final String imageUrl;
  final String title;
  final String module;
  final List<FlashCard> flashCards;
  final List<Quiz> quizzes;

  Note({
    this.id = 0,
    required this.imageUrl,
    required this.title,
    required this.module,
    required this.flashCards,
    required this.quizzes,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      imageUrl: json['image'],
      title: json['title'],
      module: json['module'],
      flashCards: (json['flash_cards'] as List)
          .map((card) => FlashCard.fromJson(card))
          .toList(),
      quizzes:
          (json['quizzes'] as List).map((quiz) => Quiz.fromJson(quiz)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': imageUrl,
      'title': title,
      'module': module,
      'flash_cards': flashCards.map((card) => card.toJson()).toList(),
      'quizzes': quizzes.map((quiz) => quiz.toJson()).toList(),
    };
  }

  Note copyWith({
    int? id,
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
      question: json['question'],
      answer: json['answer'],
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
  final int id;
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
      title: json['title'],
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
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
      question: json['question'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
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
