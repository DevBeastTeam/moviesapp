class FlashCardsModel {
  final bool success;
  final List<Movie> movies;
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
              ?.map((e) => Movie.fromJson(e))
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

class Movie {
  final String reference;
  final String label;
  final List<String> tags;
  final String subject;
  final String picture;

  Movie({
    required this.reference,
    required this.label,
    required this.tags,
    required this.subject,
    required this.picture,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      reference: json['reference'] ?? '',
      label: json['label'] ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      subject: json['Subject'] ?? '', // Note the capital 'S' to match your JSON
      picture: json['picture'] ?? '',
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
      id: json['_id'] ?? '',
      reference: json['reference'] ?? '',
      label: json['label'] ?? '',
      description: json['description'] ?? '',
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
