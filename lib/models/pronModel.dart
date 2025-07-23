class PronModel {
  final bool success;
  final ResponseData data;

  PronModel({required this.success, required this.data});

  factory PronModel.fromJson(Map<String, dynamic> json) {
    return PronModel(
      success: json['success'] as bool,
      data: ResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.toJson()};
  }
}

class ResponseData {
  final List<String> levels;
  final List<Category> categories;
  final List<dynamic>
  lessons; // Empty array in your example, replace with proper type if needed
  final dynamic currentLevel; // Type not specified in your example
  final dynamic currentFilter; // Type not specified in your example

  ResponseData({
    required this.levels,
    required this.categories,
    required this.lessons,
    required this.currentLevel,
    required this.currentFilter,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      levels: List<String>.from(json['levels'] as List),
      categories: (json['categories'] as List)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      lessons: json['lessons'] as List<dynamic>,
      currentLevel: json['currentLevel'],
      currentFilter: json['currentFilter'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levels': levels,
      'categories': categories.map((e) => e.toJson()).toList(),
      'lessons': lessons,
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
