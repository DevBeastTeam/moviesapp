import 'package:edutainment/helpers/safe_converters.dart';

import 'excLessonsStepsModel.dart'; // Import the Lesson model from the previous response

class PLevelCatgModel {
  final bool success;
  final Data data;

  PLevelCatgModel({required this.success, required this.data});

  factory PLevelCatgModel.fromJson(Map<String, dynamic> json) {
    return PLevelCatgModel(
      success: json['success'] as bool,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.toJson()};
  }
}

class Data {
  final List<String> levels;
  final List<Category> categories;
  final List<Lesson> lessons;
  final String currentLevel;
  final String currentFilter;

  Data({
    required this.levels,
    required this.categories,
    required this.lessons,
    required this.currentLevel,
    required this.currentFilter,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      levels: (json['levels'] as List<dynamic>).cast<String>(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentLevel: json['currentLevel'].toString().toSafeString(),
      currentFilter: json['currentFilter'].toString().toSafeString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levels': levels,
      'categories': categories.map((e) => e.toJson()).toList(),
      'lessons': lessons.map((e) => e.toJson()).toList(),
      'currentLevel': currentLevel,
      'currentFilter': currentFilter,
    };
  }
}

class Category {
  final String id;
  final String label;
  final String icon;

  Category({required this.id, required this.label, required this.icon});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'label': label, 'icon': icon};
  }
}
