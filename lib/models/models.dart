class Course {
  final String imageUrl;
  final String title;
  final String faculty;
  final List<FlashCard> flashCards;
  final List<Quiz> quizzes;

  Course({
    required this.imageUrl,
    required this.title,
    required this.faculty,
    required this.flashCards,
    required this.quizzes,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      imageUrl: json['image'],
      title: json['title'],
      faculty: json['faculty'],
      flashCards: (json['flash_cards'] as List)
          .map((card) => FlashCard.fromJson(card))
          .toList(),
      quizzes:
          (json['quizzes'] as List).map((quiz) => Quiz.fromJson(quiz)).toList(),
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
}

class Quiz {
  final String title;
  final List<Question> questions;

  Quiz({
    required this.title,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      title: json['title'],
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
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
}
