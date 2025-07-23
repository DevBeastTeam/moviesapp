class GrammerDetailModel {
  lessonDetail? lesson;

  GrammerDetailModel({this.lesson});

  factory GrammerDetailModel.fromJson(Map<String, dynamic> json) =>
      GrammerDetailModel(
        lesson: json['lesson'] == null
            ? null
            : lessonDetail.fromJson(json['lesson']),
      );

  Map<String, dynamic> toJson() => {
        'lesson': lesson?.toJson(),
      };
}

class lessonDetail {
  String? id;
  String? reference;
  String? content;
  String? createdAt;
  bool? enabled;
  String? label;
  List<String>? profiles;
  List<dynamic>? questions;
  List<String>? tags;
  String? type;
  String? updatedAt;

  lessonDetail({
    this.id,
    this.reference,
    this.content,
    this.createdAt,
    this.enabled,
    this.label,
    this.profiles,
    this.questions,
    this.tags,
    this.type,
    this.updatedAt,
  });

  factory lessonDetail.fromJson(Map<String, dynamic> json) => lessonDetail(
        id: json['_id'] as String?,
        reference: json['reference'] as String?,
        content: json['content'] as String?,
        createdAt: json['createdAt'] as String?,
        enabled: json['enabled'] as bool?,
        label: json['label'] as String?,
        profiles: json['profiles'] == null
            ? null
            : List<String>.from(json['profiles'] as List),
        questions: json['questions'] as List<dynamic>?,
        tags: json['tags'] == null
            ? null
            : List<String>.from(json['tags'] as List),
        type: json['type'] as String?,
        updatedAt: json['updatedAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'reference': reference,
        'content': content,
        'createdAt': createdAt,
        'enabled': enabled,
        'label': label,
        'profiles': profiles,
        'questions': questions,
        'tags': tags,
        'type': type,
        'updatedAt': updatedAt,
      };
}
