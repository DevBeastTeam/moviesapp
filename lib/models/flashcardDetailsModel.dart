class FlashCardDetaiilModel {
  final bool success;
  final List<dynamic>
  flashcards; // Replace dynamic with specific type if flashcards have structure
  final List<Level> levels;
  final String currentLevel;
  final Movie movie;

  FlashCardDetaiilModel({
    required this.success,
    required this.flashcards,
    required this.levels,
    required this.currentLevel,
    required this.movie,
  });

  factory FlashCardDetaiilModel.fromJson(Map<String, dynamic> json) {
    return FlashCardDetaiilModel(
      success: json['success'] ?? false,
      flashcards: json['flashcards'] ?? [],
      levels: (json['levels'] as List).map((e) => Level.fromJson(e)).toList(),
      currentLevel: json['currentLevel'] ?? '',
      movie: Movie.fromJson(json['movie']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'flashcards': flashcards,
      'levels': levels.map((e) => e.toJson()).toList(),
      'currentLevel': currentLevel,
      'movie': movie.toJson(),
    };
  }
}

class Level {
  final String id;
  final String reference;
  final String label;
  final bool enabled;

  Level({
    required this.id,
    required this.reference,
    required this.label,
    required this.enabled,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['_id'] ?? '',
      reference: json['reference'] ?? '',
      label: json['label'] ?? '',
      enabled: json['enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reference': reference,
      'label': label,
      'enabled': enabled,
    };
  }
}

class Movie {
  final String id;
  final String reference;
  final String subject;
  final DateTime createdAt;
  final String description;
  final int duration;
  final bool enabled;
  final String label;
  final String m3u8Link;
  final String mpdLink;
  final String picture;
  final List<String> profiles;
  final List<String> tags;
  final DateTime updatedAt;

  Movie({
    required this.id,
    required this.reference,
    required this.subject,
    required this.createdAt,
    required this.description,
    required this.duration,
    required this.enabled,
    required this.label,
    required this.m3u8Link,
    required this.mpdLink,
    required this.picture,
    required this.profiles,
    required this.tags,
    required this.updatedAt,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id'] ?? '',
      reference: json['reference'] ?? '',
      subject: json['Subject'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      enabled: json['enabled'] ?? false,
      label: json['label'] ?? '',
      m3u8Link: json['m3u8_link'] ?? '',
      mpdLink: json['mpd_link'] ?? '',
      picture: json['picture'] ?? '',
      profiles: (json['profiles'] as List).map((e) => e.toString()).toList(),
      tags: (json['tags'] as List).map((e) => e.toString()).toList(),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reference': reference,
      'Subject': subject,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'duration': duration,
      'enabled': enabled,
      'label': label,
      'm3u8_link': m3u8Link,
      'mpd_link': mpdLink,
      'picture': picture,
      'profiles': profiles,
      'tags': tags,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
