class QuizCategory {
  final String id;
  final String label;
  final String? icon;
  final String? description;

  QuizCategory({
    required this.id,
    required this.label,
    this.icon,
    this.description,
  });

  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    return QuizCategory(
      id: json['_id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      icon: json['icon']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'label': label,
      'icon': icon,
      'description': description,
    };
  }
}

class Quiz {
  final String id;
  final String title;
  final String? description;
  final String? category;
  final String? type;
  final List<Question>? questions;
  final int? duration; // in seconds

  Quiz({
    required this.id,
    required this.title,
    this.description,
    this.category,
    this.type,
    this.questions,
    this.duration,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      category: json['category']?.toString(),
      type: json['type']?.toString(),
      duration: int.tryParse(json['duration']?.toString() ?? ''),
      questions: json['questions'] != null
          ? (json['questions'] as List)
                .map((i) => Question.fromJson(i))
                .toList()
          : null,
    );
  }
}

class Question {
  final String id;
  final String text;
  final List<AnswerOption> options;
  final String? type; // multiple_choice, true_false, etc.
  final String? audio;
  final String? image;

  Question({
    required this.id,
    required this.text,
    required this.options,
    this.type,
    this.audio,
    this.image,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      type: json['type']?.toString(),
      audio: json['audio']?.toString(),
      image: json['image']?.toString(),
      options: json['options'] != null
          ? (json['options'] as List)
                .map((i) => AnswerOption.fromJson(i))
                .toList()
          : [],
    );
  }
}

class AnswerOption {
  final String id;
  final String text;
  final bool? isCorrect;

  AnswerOption({required this.id, required this.text, this.isCorrect});

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      id: json['_id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      isCorrect: json['isCorrect'],
    );
  }
}

class QuizResult {
  final String? sessionId;
  final double? score;
  final int? totalQuestions;
  final int? correctAnswers;
  final String? status;

  QuizResult({
    this.sessionId,
    this.score,
    this.totalQuestions,
    this.correctAnswers,
    this.status,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      sessionId: json['session_id']?.toString(),
      score: double.tryParse(json['score']?.toString() ?? ''),
      totalQuestions: int.tryParse(json['total_questions']?.toString() ?? ''),
      correctAnswers: int.tryParse(json['correct_answers']?.toString() ?? ''),
      status: json['status']?.toString(),
    );
  }
}
