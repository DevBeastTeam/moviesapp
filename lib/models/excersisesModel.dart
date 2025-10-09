



class ExcersisesModel {
  final List<AllowedLessonCategory> allowedLessonCategory;
  final UserLevel userLevel;

  ExcersisesModel({
    required this.allowedLessonCategory,
    required this.userLevel,
  });

  factory ExcersisesModel.fromJson(Map<String, dynamic> json) {
    return ExcersisesModel(
      allowedLessonCategory: json['allowedLessonCategory']!=null? (json['allowedLessonCategory'] as List)
          .map((e) => AllowedLessonCategory.fromJson(e))
          .toList(): [],
      userLevel: json['allowedLessonCategory']!=null? UserLevel.fromJson(json['userLevel']): UserLevel(index: 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowedLessonCategory': allowedLessonCategory.map((e) => e.toJson()).toList(),
      'userLevel': userLevel.toJson(),
    };
  }
}

class AllowedLessonCategory {
  final String id;
  final String reference;
  final String label;
  final String? level; // Made nullable since not all items have it

  AllowedLessonCategory({
    required this.id,
    required this.reference,
    required this.label,
    this.level,
  });

  factory AllowedLessonCategory.fromJson(Map<String, dynamic> json) {
    return AllowedLessonCategory(
      id: json['_id'] as String,
      reference: json['reference'] as String,
      label: json['label'] as String,
      level: json['level'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reference': reference,
      'label': label,
      if (level != null) 'level': level,
    };
  }
}

class UserLevel {
  final int index;

  UserLevel({
    required this.index,
  });

  factory UserLevel.fromJson(Map<String, dynamic> json) {
    return UserLevel(
      index: json['index'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
    };
  }
}


// import 'package:edutainment/helpers/forstrings.dart';

// class ExcersisesModel {
//   Map<String, List<dynamic>> groupLessons;
//   List<AllowedLessonCategory> allowedLessonCategory;
//   List<Tag> tags;
//   UserLevel userLevel;

//   ExcersisesModel({
//     required this.groupLessons,
//     required this.allowedLessonCategory,
//     required this.tags,
//     required this.userLevel,
//   });

//   factory ExcersisesModel.fromJson(Map<String, dynamic> json) {
//     return ExcersisesModel(
//       groupLessons:  json['groupLessons'] != null ? Map<String, List<dynamic>>.from(json['groupLessons']): {},
//       allowedLessonCategory: List<AllowedLessonCategory>.from(
//         json['allowedLessonCategory'].map<AllowedLessonCategory>(
//           (x) => AllowedLessonCategory.fromJson(x),
//         ),
//       ),
//       tags: List<Tag>.from(json['tags'].map<Tag>((x) => Tag.fromJson(x))),
//       userLevel: UserLevel.fromJson(json['userLevel']),
//     );
//   }
// }

// class AllowedLessonCategory {
//   String id;
//   String reference;
//   String label;
//   String level;

//   AllowedLessonCategory({
//     required this.id,
//     required this.reference,
//     required this.label,
//     required this.level,
//   });

//   factory AllowedLessonCategory.fromJson(Map<String, dynamic> json) {
//     return AllowedLessonCategory(
//       id: json['_id'].toString().toNullString(),
//       reference: json['reference'].toString().toNullString(),
//       label: json['label'].toString().toNullString(),
//       level: json['level'].toString().toNullString(),
//     );
//   }
// }

// class Tag {
//   String id;
//   String reference;
//   String label;

//   Tag({required this.id, required this.reference, required this.label});

//   factory Tag.fromJson(Map<String, dynamic> json) {
//     return Tag(
//       id: json['_id'],
//       reference: json['reference'],
//       label: json['label'],
//     );
//   }
// }

// class UserLevel {
//   int index;

//   UserLevel({required this.index});

//   factory UserLevel.fromJson(Map<String, dynamic> json) {
//     return UserLevel(index: json['index']);
//   }
// }
