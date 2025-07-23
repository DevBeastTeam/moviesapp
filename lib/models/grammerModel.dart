class GrammerModel {
  final Map<String, List<Lesson>> groupLessons;
  final List<AllowedLessonCategory> allowedLessonCategory;
  final List<Tag> tags;

  GrammerModel({
    required this.groupLessons,
    required this.allowedLessonCategory,
    required this.tags,
  });

  factory GrammerModel.fromJson(Map<String, dynamic> json) {
    var groupLessonsMap = json['groupLessons'] as Map<String, dynamic>;
    var groupLessons = <String, List<Lesson>>{};
    groupLessonsMap.forEach((key, value) {
      groupLessons[key] = (value as List)
          .map((i) => Lesson.fromJson(i))
          .toList();
    });

    var allowedLessonCategoryList = json['allowedLessonCategory'] as List;
    var allowedLessonCategory = allowedLessonCategoryList
        .map((i) => AllowedLessonCategory.fromJson(i))
        .toList();

    var tagsList = json['tags'] as List;
    var tags = tagsList.map((i) => Tag.fromJson(i)).toList();

    return GrammerModel(
      groupLessons: groupLessons,
      allowedLessonCategory: allowedLessonCategory,
      tags: tags,
    );
  }
}

class Lesson {
  final String id;
  final String reference;
  final String label;
  final List<String> tags;
  final bool isRead;

  Lesson({
    required this.id,
    required this.reference,
    required this.label,
    required this.tags,
    required this.isRead,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['_id'],
      reference: json['reference'],
      label: json['label'],
      tags: List<String>.from(json['tags']),
      isRead: json['isRead'],
    );
  }
}

class AllowedLessonCategory {
  final String id;
  final String reference;
  final String label;
  final String? level;

  AllowedLessonCategory({
    required this.id,
    required this.reference,
    required this.label,
    this.level,
  });

  factory AllowedLessonCategory.fromJson(Map<String, dynamic> json) {
    return AllowedLessonCategory(
      id: json['_id'],
      reference: json['reference'],
      label: json['label'],
      level: json['level'],
    );
  }
}

class Tag {
  final String id;
  final String reference;
  final String label;

  Tag({required this.id, required this.reference, required this.label});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['_id'],
      reference: json['reference'],
      label: json['label'],
    );
  }
}
