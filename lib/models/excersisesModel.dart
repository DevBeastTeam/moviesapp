import 'package:edutainment/helpers/forstrings.dart';

class ExcersisesModel {
  Map<String, List<dynamic>> groupLessons;
  List<AllowedLessonCategory> allowedLessonCategory;
  List<Tag> tags;
  UserLevel userLevel;

  ExcersisesModel({
    required this.groupLessons,
    required this.allowedLessonCategory,
    required this.tags,
    required this.userLevel,
  });

  factory ExcersisesModel.fromJson(Map<String, dynamic> json) {
    return ExcersisesModel(
      groupLessons: Map<String, List<dynamic>>.from(json['groupLessons']),
      allowedLessonCategory: List<AllowedLessonCategory>.from(
        json['allowedLessonCategory'].map<AllowedLessonCategory>(
          (x) => AllowedLessonCategory.fromJson(x),
        ),
      ),
      tags: List<Tag>.from(json['tags'].map<Tag>((x) => Tag.fromJson(x))),
      userLevel: UserLevel.fromJson(json['userLevel']),
    );
  }
}

class AllowedLessonCategory {
  String id;
  String reference;
  String label;
  String level;

  AllowedLessonCategory({
    required this.id,
    required this.reference,
    required this.label,
    required this.level,
  });

  factory AllowedLessonCategory.fromJson(Map<String, dynamic> json) {
    return AllowedLessonCategory(
      id: json['_id'].toString().toNullString(),
      reference: json['reference'].toString().toNullString(),
      label: json['label'].toString().toNullString(),
      level: json['level'].toString().toNullString(),
    );
  }
}

class Tag {
  String id;
  String reference;
  String label;

  Tag({required this.id, required this.reference, required this.label});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['_id'],
      reference: json['reference'],
      label: json['label'],
    );
  }
}

class UserLevel {
  int index;

  UserLevel({required this.index});

  factory UserLevel.fromJson(Map<String, dynamic> json) {
    return UserLevel(index: json['index']);
  }
}
