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
  final int? totalAttempts;
  final double? lastTotalScore;
  final double? bestTotalScore;
  final bool? entryQuiz;

  Quiz({
    required this.id,
    required this.title,
    this.description,
    this.category,
    this.type,
    this.questions,
    this.duration,
    this.totalAttempts,
    this.lastTotalScore,
    this.bestTotalScore,
    this.entryQuiz,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['label']?.toString() ?? '',
      description: json['description']?.toString(),
      category: json['category']?.toString(),
      type: json['type']?.toString(),
      duration: int.tryParse(json['duration']?.toString() ?? ''),
      totalAttempts: int.tryParse(json['totalAttempts']?.toString() ?? ''),
      lastTotalScore: double.tryParse(json['lastTotalScore']?.toString() ?? ''),
      bestTotalScore: double.tryParse(json['bestTotalScore']?.toString() ?? ''),
      entryQuiz: json['entry_quiz'],
      questions: json['questions'] != null
          ? (json['questions'] as List)
                .map((i) => Question.fromJson(i))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'category': category,
      'type': type,
      'duration': duration,
      'totalAttempts': totalAttempts,
      'lastTotalScore': lastTotalScore,
      'bestTotalScore': bestTotalScore,
      'entry_quiz': entryQuiz,
      'questions': questions?.map((e) => e.toJson()).toList(),
    };
  }
}

class Question {
  final String id;
  final String text;
  final List<AnswerOption> answers; // Renamed from options to match UI usage
  final String? type;
  final String? audio;
  final String? image;
  final int? start; // For video start time
  final int? end; // For video end time
  final String? movie; // For movie URL
  final Map<String, dynamic>? quizSessionAnswer;

  Question({
    required this.id,
    required this.text,
    required this.answers,
    this.type,
    this.audio,
    this.image,
    this.start,
    this.end,
    this.movie,
    this.quizSessionAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final data = json['Question'] ?? json;
    return Question(
      id: data['_id']?.toString() ?? '',
      text: data['label']?.toString() ?? data['text']?.toString() ?? '',
      type: data['type']?.toString(),
      audio: data['audio']?.toString(),
      image: data['picture']?.toString() ?? data['image']?.toString(),
      start: int.tryParse(data['start']?.toString() ?? ''),
      end: int.tryParse(data['end']?.toString() ?? ''),
      movie: data['Movie']?.toString(),
      quizSessionAnswer: data['quizSessionAnswer'],
      answers: (data['answers'] != null)
          ? (data['answers'] as List)
                .map((i) => AnswerOption.fromJson(i))
                .toList()
          : (data['options'] != null)
          ? (data['options'] as List)
                .map((i) => AnswerOption.fromJson(i))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'label': text, // UI uses label
      'text': text,
      'type': type,
      'audio': audio,
      'picture': image, // UI uses picture
      'start': start,
      'end': end,
      'Movie': movie,
      'quizSessionAnswer': quizSessionAnswer,
      'answers': answers.map((e) => e.toJson()).toList(),
    };
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
      text: json['text']?.toString() ?? json['label']?.toString() ?? '',
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'text': text, 'label': text, 'isCorrect': isCorrect};
  }
}

class QuizResult {
  final dynamic quizSession;
  final int? totalCorrectAnswer;
  final Quiz? quiz;

  QuizResult({this.quizSession, this.totalCorrectAnswer, this.quiz});

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizSession: json['quizSession'],
      totalCorrectAnswer: int.tryParse(
        json['totalCorrectAnswer']?.toString() ?? '',
      ),
      quiz: json['quiz'] != null ? Quiz.fromJson(json['quiz']) : null,
    );
  }
}
