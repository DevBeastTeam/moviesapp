class GrammerModel {
  final Map<String, List<Lesson>> groupLessons;
  final List<AllowedCategory> allowedLessonCategory;
  final List<Tag> tags;

  GrammerModel({
    required this.groupLessons,
    required this.allowedLessonCategory,
    required this.tags,
  });

  factory GrammerModel.fromJson(Map<String, dynamic> json) {
    final groupLessonsMap = <String, List<Lesson>>{};
    (json['groupLessons'] as Map<String, dynamic>).forEach((key, value) {
      groupLessonsMap[key] = (value as List)
          .map((e) => Lesson.fromJson(e))
          .toList();
    });

    return GrammerModel(
      groupLessons: groupLessonsMap,
      allowedLessonCategory: (json['allowedLessonCategory'] as List)
          .map((e) => AllowedCategory.fromJson(e))
          .toList(),
      tags: (json['tags'] as List).map((e) => Tag.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'groupLessons': {
      for (var entry in groupLessons.entries)
        entry.key: entry.value.map((e) => e.toJson()).toList(),
    },
    'allowedLessonCategory': allowedLessonCategory
        .map((e) => e.toJson())
        .toList(),
    'tags': tags.map((e) => e.toJson()).toList(),
  };
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

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json['_id'] as String,
    reference: json['reference'] as String,
    label: json['label'] as String,
    tags: (json['tags'] as List).cast<String>(),
    isRead: json['isRead'] as bool,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'reference': reference,
    'label': label,
    'tags': tags,
    'isRead': isRead,
  };
}

class AllowedCategory {
  final String id;
  final String reference;
  final String label;
  final String? level;

  AllowedCategory({
    required this.id,
    required this.reference,
    required this.label,
    this.level,
  });

  factory AllowedCategory.fromJson(Map<String, dynamic> json) =>
      AllowedCategory(
        id: json['_id'] as String,
        reference: json['reference'] as String,
        label: json['label'] as String,
        level: json['level'] as String?,
      );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'reference': reference,
    'label': label,
    if (level != null) 'level': level,
  };
}

class Tag {
  final String id;
  final String reference;
  final String label;

  Tag({required this.id, required this.reference, required this.label});

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    id: json['_id'] as String,
    reference: json['reference'] as String,
    label: json['label'] as String,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'reference': reference,
    'label': label,
  };
}

// class GrammerModel {
//   final Map<String, List<Lesson>> groupLessons;
//   final List<AllowedLessonCategory> allowedLessonCategory;
//   final List<Tag> tags;

//   GrammerModel({
//     required this.groupLessons,
//     required this.allowedLessonCategory,
//     required this.tags,
//   });

//   factory GrammerModel.fromJson(Map<String, dynamic> json) {
//     var groupLessonsMap = json['groupLessons'] as Map<String, dynamic>;
//     var groupLessons = <String, List<Lesson>>{};
//     groupLessonsMap.forEach((key, value) {
//       groupLessons[key] = (value as List)
//           .map((i) => Lesson.fromJson(i))
//           .toList();
//     });

//     var allowedLessonCategoryList = json['allowedLessonCategory'] as List;
//     var allowedLessonCategory = allowedLessonCategoryList
//         .map((i) => AllowedLessonCategory.fromJson(i))
//         .toList();

//     var tagsList = json['tags'] as List;
//     var tags = tagsList.map((i) => Tag.fromJson(i)).toList();

//     return GrammerModel(
//       groupLessons: groupLessons,
//       allowedLessonCategory: allowedLessonCategory,
//       tags: tags,
//     );
//   }
// }

// class Lesson {
//   final String id;
//   final String reference;
//   final String label;
//   final List<String> tags;
//   final bool isRead;

//   Lesson({
//     required this.id,
//     required this.reference,
//     required this.label,
//     required this.tags,
//     required this.isRead,
//   });

//   factory Lesson.fromJson(Map<String, dynamic> json) {
//     return Lesson(
//       id: json['_id'],
//       reference: json['reference'],
//       label: json['label'],
//       tags: List<String>.from(json['tags']),
//       isRead: json['isRead'],
//     );
//   }
// }

// class AllowedLessonCategory {
//   final String id;
//   final String reference;
//   final String label;
//   final String? level;

//   AllowedLessonCategory({
//     required this.id,
//     required this.reference,
//     required this.label,
//     this.level,
//   });

//   factory AllowedLessonCategory.fromJson(Map<String, dynamic> json) {
//     return AllowedLessonCategory(
//       id: json['_id'],
//       reference: json['reference'],
//       label: json['label'],
//       level: json['level'],
//     );
//   }
// }

// class Tag {
//   final String id;
//   final String reference;
//   final String label;

//   Tag({required this.id, required this.reference, required this.label});

//   factory Tag.fromJson(Map<String, dynamic> json) {
//     return Tag(
//       id: json['_id'],
//       reference: json['reference'],
//       label: json['label'],
//     );
//   }
// }
