class Movie {
  final String id;
  final String title;
  final String? description;
  final String? picture;
  final String? video; // URL or path
  final MovieSubject? subject;
  final List<String>? tags; // List of tag references or IDs
  final int? duration; // in seconds
  final int? progress; // for paused movies
  final bool? isWatched;

  Movie({
    required this.id,
    required this.title,
    this.description,
    this.picture,
    this.video,
    this.subject,
    this.tags,
    this.duration,
    this.progress,
    this.isWatched,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['label']?.toString() ?? '',
      description: json['description']?.toString(),
      picture: json['picture']?.toString(),
      video: json['video']?.toString(),
      subject: json['Subject'] != null
          ? MovieSubject.fromJson(json['Subject'])
          : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      duration: int.tryParse(json['duration']?.toString() ?? ''),
      progress: int.tryParse(json['progress']?.toString() ?? ''),
      isWatched: json['isWatched'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'picture': picture,
      'video': video,
      'Subject': subject?.toJson(),
      'tags': tags,
      'duration': duration,
      'progress': progress,
      'isWatched': isWatched,
    };
  }
}

class MovieSubject {
  final String id;
  final String label;
  final String reference;

  MovieSubject({
    required this.id,
    required this.label,
    required this.reference,
  });

  factory MovieSubject.fromJson(Map<String, dynamic> json) {
    return MovieSubject(
      id: json['_id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'label': label, 'reference': reference};
  }
}

class MovieTag {
  final String id;
  final String label;
  final String reference;
  final bool? enabled;

  MovieTag({
    required this.id,
    required this.label,
    required this.reference,
    this.enabled,
  });

  factory MovieTag.fromJson(Map<String, dynamic> json) {
    return MovieTag(
      id: json['_id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      enabled: json['enabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'label': label,
      'reference': reference,
      'enabled': enabled,
    };
  }
}
