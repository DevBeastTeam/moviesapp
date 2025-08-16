import 'package:edutainment/helpers/forstrings.dart';

class FlashCardsModel {
  final bool success;
  final List<FlashCardsMovie> movies;
  final List<Subject> subjects;

  FlashCardsModel({
    required this.success,
    required this.movies,
    required this.subjects,
  });

  factory FlashCardsModel.fromJson(Map<String, dynamic> json) {
    return FlashCardsModel(
      success: json['success'] ?? false,
      movies:
          (json['movies'] as List<dynamic>?)
              ?.map((e) => FlashCardsMovie.fromJson(e))
              .toList() ??
          [],
      subjects:
          (json['subjects'] as List<dynamic>?)
              ?.map((e) => Subject.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'movies': movies.map((e) => e.toJson()).toList(),
      'subjects': subjects.map((e) => e.toJson()).toList(),
    };
  }
}

class FlashCardsMovie {
  final String reference;
  final String label;
  final List<String> tags;
  final String subject;
  final String picture;

  FlashCardsMovie({
    required this.reference,
    required this.label,
    required this.tags,
    required this.subject,
    required this.picture,
  });

  factory FlashCardsMovie.fromJson(Map<String, dynamic> json) {
    return FlashCardsMovie(
      reference: json['reference'].toString().toNullString(),
      label: json['label'].toString().toNullString(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      subject: json['Subject'].toString().toNullString(), // Note the capital 'S' to match your JSON
      picture: json['picture'].toString().toNullString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'label': label,
      'tags': tags,
      'Subject': subject, // Note the capital 'S' to match your JSON
      'picture': picture,
    };
  }
}

class Subject {
  final String id;
  final String reference;
  final String label;
  final String description;
  final bool enabled;
  final DateTime createdOn;
  final DateTime updatedOn;
  final int v;

  Subject({
    required this.id,
    required this.reference,
    required this.label,
    required this.description,
    required this.enabled,
    required this.createdOn,
    required this.updatedOn,
    required this.v,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['_id'].toString().toNullString(),
      reference: json['reference'].toString().toNullString(),
      label: json['label'].toString().toNullString(),
      description: json['description'].toString().toNullString(),
      enabled: json['enabled'] ?? false,
      createdOn: DateTime.parse(
        json['created_on'] ?? DateTime.now().toIso8601String(),
      ),
      updatedOn: DateTime.parse(
        json['updated_on'] ?? DateTime.now().toIso8601String(),
      ),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reference': reference,
      'label': label,
      'description': description,
      'enabled': enabled,
      'created_on': createdOn.toIso8601String(),
      'updated_on': updatedOn.toIso8601String(),
      '__v': v,
    };
  }
}


