import 'package:edutainment/helpers/safe_converters.dart';

class ExerciseLessonsStepModel {
  final bool success;
  final Data data;

  ExerciseLessonsStepModel({required this.success, required this.data});

  factory ExerciseLessonsStepModel.fromJson(Map<String, dynamic> json) {
    return ExerciseLessonsStepModel(
      success: json['success'].toString().toSafeString() == "true",
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.toJson()};
  }
}

class Data {
  final List<Lesson> lessons;
  final double progressPercentage;

  Data({required this.lessons, required this.progressPercentage});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
      progressPercentage:
          double.tryParse(
            json['progressPercentage'].toString().toSafeString(),
          ) ??
          0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessons': lessons.map((e) => e.toJson()).toList(),
      'progressPercentage': progressPercentage,
    };
  }
}

class Lesson {
  final String id;
  final String reference;
  final String label;
  final List<Question> questions;
  final String lessonNumber;
  final bool completed;
  final bool available;

  Lesson({
    required this.id,
    required this.reference,
    required this.label,
    required this.questions,
    this.lessonNumber = "",
    required this.completed,
    required this.available,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['_id'].toString().toSafeString(),
      reference: json['reference'].toString().toSafeString(),
      label: json['label'].toString().toSafeString(),
      questions:
          (json['questions'] as List<dynamic>?)
              ?.where((e) => e is Map<String, dynamic>)
              .map((e) => Question.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lessonNumber: json['lessonNumber'].toString().toSafeString(),
      completed: json['completed'].toString().toSafeString() == "true"
          ? true
          : false,
      available: json['available'].toString().toSafeString() == "true"
          ? true
          : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reference': reference,
      'label': label,
      'questions': questions.map((e) => e.toJson()).toList(),
      'lessonNumber': lessonNumber,
      'completed': completed,
      'available': available,
    };
  }
}

class Question {
  final String id;
  final String reference;
  final List<Answer> answers;
  final String category;
  final DateTime createdAt;
  final bool enabled;
  final bool examination;
  final String label;
  final String score;
  final bool showAnswers;
  final bool shuffleAnswers;
  final int time;
  final String type;
  final DateTime updatedAt;

  Question({
    required this.id,
    required this.reference,
    required this.answers,
    required this.category,
    required this.createdAt,
    required this.enabled,
    required this.examination,
    required this.label,
    required this.score,
    required this.showAnswers,
    required this.shuffleAnswers,
    required this.time,
    required this.type,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'].toString().toSafeString(),
      reference: json['reference'].toString().toSafeString(),
      answers: (json['answers'] as List<dynamic>)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      category: json['category'].toString().toSafeString(),
      createdAt: DateTime.parse(json['createdAt'].toString().toSafeString()),
      enabled: json['enabled'].toString().toSafeString() == "true",
      examination: json['examination'].toString().toSafeString() == "true",
      label: json['label'].toString().toSafeString(),
      score: json['score'].toString().toSafeString(),
      showAnswers: json['show_answers'].toString().toSafeString() == "true",
      shuffleAnswers:
          json['shuffle_answers'].toString().toSafeString() == "true",
      time: json['time'].toString().toSafeString().isEmpty
          ? 0
          : int.parse(json['time'].toString().toSafeString()),
      type: json['type'].toString().toSafeString(),
      updatedAt: DateTime.parse(json['updatedAt'].toString().toSafeString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reference': reference,
      'answers': answers.map((e) => e.toJson()).toList(),
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'enabled': enabled,
      'examination': examination,
      'label': label,
      'score': score,
      'show_answers': showAnswers,
      'shuffle_answers': shuffleAnswers,
      'time': time,
      'type': type,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Answer {
  final String reference;
  final String answer;
  final String label;
  final bool isAnswer;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  Answer({
    required this.reference,
    required this.answer,
    required this.label,
    required this.isAnswer,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      reference: json['reference'].toString().toSafeString(),
      answer: json['answer'].toString().toSafeString(),
      label: json['label'].toString().toSafeString(),
      isAnswer: json['is_answer'].toString().toSafeString() == "true",
      id: json['_id'].toString().toSafeString(),
      createdAt: DateTime.parse(json['createdAt'].toString().toSafeString()),
      updatedAt: DateTime.parse(json['updatedAt'].toString().toSafeString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'answer': answer,
      'label': label,
      'is_answer': isAnswer,
      '_id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
