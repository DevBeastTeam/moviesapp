import 'package:edutainment/helpers/forstrings.dart';

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

  // Map<String, dynamic> toJson() => {
  //   'groupLessons': {
  //     for (var entry in groupLessons.entries)
  //       entry.key: entry.value.map((e) => e.toJson()).toList(),
  //   },
  //   'allowedLessonCategory': allowedLessonCategory
  //       .map((e) => e.toJson())
  //       .toList(),
  //   'tags': tags.map((e) => e.toJson()).toList(),
  // };
}

class Lesson {
  final String id;
  final String reference;
  final String label;
  final String contenten;
  final String contentfr;
  final LessonCategory? lessonCatg;
  final List<String> tags;
  final bool isRead;

  Lesson({
    this.id = "",
    this.reference = "",
    this.label = "",
    this.contenten = "",
    this.contentfr = "",
    this.tags = const [],
    required this.lessonCatg,
    this.isRead = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json['_id'] as String,
    reference: json['reference'] as String,
    label: json['label'] as String,
    contenten: json['contenten'] as String,
    contentfr: json['contentfr'] as String,
    lessonCatg: LessonCategory.fromJson(json['LessonCategory']),
    tags: (json['tags'] as List).cast<String>(),
    isRead: json['isRead'] as bool,
  );

  // Map<String, dynamic> toJson() => {
  //   '_id': id,
  //   'reference': reference,
  //   'label': label,
  //   'tags': tags,
  //   'isRead': isRead,
  // };
}

//  "LessonCategory":{
//                   "_id":63ee6f976f7067cc89e900d0,
//                   "reference":a1,
//                   "label":a1,
//                   "level":"a_wannabe_lion"
//                },
class LessonCategory {
  final String id;
  final String reference;
  final String label;
  final String? level;

  LessonCategory({
    this.id = "",
    this.reference = "",
    this.label = "",
    this.level,
  });
  factory LessonCategory.fromJson(Map<String, dynamic> json) => LessonCategory(
    id: json['_id'].toString().toNullString(),
    reference: json['reference'].toString().toNullString(),
    label: json['label'].toString().toNullString(),
    level: json['level'].toString().toNullString(),
  );
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
        id: json['_id'].toString().toNullString(),
        reference: json['reference'].toString().toNullString(),
        label: json['label'].toString().toNullString(),
        level: json['level'].toString().toNullString(),
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






// url : /lessons/grammar
// {
//    "success":true,
//    "data":{
//       "groupLessons":{
//          "expressing_simultaneity":[
//             {
//                "_id":652969624622968d66f2e84e,
//                "reference":lesson99,
//                "label":Expressing Simultaneity 2,
//                "tags":[
//                   "expressing_simultaneity"
//                ],
//                "isRead":true
//             }
//          ],
//          "bac":[
//             {
//                "_id":652969624622968d66f2e87b,
//                "reference":lesson144,
//                "label":Bac (Literature) 1994,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e887,
//                "reference":lesson156,
//                "label":Bac (literature) 2006,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e87d,
//                "reference":lesson146,
//                "label":Bac (Literature)1996,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e886,
//                "reference":lesson155,
//                "label":Bac (science) 2006,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e889,
//                "reference":lesson158,
//                "label":"Bac (science) Year Unknown",
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e88a,
//                "reference":lesson159,
//                "label":"Bac (Year Known)",
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e888,
//                "reference":lesson157,
//                "label":"Bac (Year unknown)",
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e87a,
//                "reference":lesson143,
//                "label":Bac 1993,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e87c,
//                "reference":lesson145,
//                "label":Bac 1995,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e87e,
//                "reference":lesson147,
//                "label":Bac 1997,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e87f,
//                "reference":lesson148,
//                "label":Bac 2000,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e880,
//                "reference":lesson149,
//                "label":Bac 2002,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e881,
//                "reference":lesson150,
//                "label":Bac 2003,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e882,
//                "reference":lesson151,
//                "label":Bac 2003,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e883,
//                "reference":lesson152,
//                "label":Bac 2004,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e884,
//                "reference":lesson153,
//                "label":Bac 2004,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e885,
//                "reference":lesson154,
//                "label":Bac 2004,
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e88b,
//                "reference":lesson160,
//                "label":"Practice Bac",
//                "tags":[
//                   "bac"
//                ],
//                "isRead":true
//             }
//          ],
//          "visits":[
//             {
//                "_id":652969624622968d66f2e88c,
//                "reference":lesson161,
//                "label":"Binta Visits New York",
//                "tags":[
//                   "visits"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e88d,
//                "reference":lesson162,
//                "label":"Mariam Visits a Village",
//                "tags":[
//                   "visits"
//                ],
//                "isRead":false
//             }
//          ],
//          "croesus_ans_solon":[
//             {
//                "_id":652969624622968d66f2e88e,
//                "reference":lesson163,
//                "label":"Croesus and Solon",
//                "tags":[
//                   "croesus_ans_solon"
//                ],
//                "isRead":true
//             }
//          ],
//          "city_mouse":[
//             {
//                "_id":652969624622968d66f2e88f,
//                "reference":lesson164,
//                "label":"City Mouse and Village Mouse",
//                "tags":[
//                   "city_mouse"
//                ],
//                "isRead":true
//             }
//          ],
//          "history":[
//             {
//                "_id":652969624622968d66f2e890,
//                "reference":lesson165,
//                "label":"The History of Flight",
//                "tags":[
//                   "history"
//                ],
//                "isRead":true
//             }
//          ],
//          "americans":[
//             {
//                "_id":652969624622968d66f2e891,
//                "reference":lesson166,
//                "label":"Famous Americans",
//                "tags":[
//                   "americans"
//                ],
//                "isRead":false
//             }
//          ],
//          "conjugation":[
//             {
//                "_id":652969624622968d66f2e894,
//                "reference":lesson169,
//                "label":"Infinitive         Simple           Past                French                Infinitive           Simple           Past            French",
//                "tags":[
//                   "conjugation"
//                ],
//                "isRead":true
//             },
//             {
//                "_id":652969624622968d66f2e893,
//                "reference":lesson168,
//                "label":"SIMPLE PAST",
//                "tags":[
//                   "conjugation"
//                ],
//                "isRead":false
//             },
//             {
//                "_id":652969624622968d66f2e892,
//                "reference":lesson167,
//                "label":"Verb Review Sheet",
//                "tags":[
//                   "conjugation"
//                ],
//                "isRead":false
//             }
//          ],
//          "passive voice":[
//             {
//                "_id":652969624622968d66f2e895,
//                "reference":lesson170,
//                "label":"Passive Voice",
//                "tags":[
//                   "passive voice"
//                ],
//                "isRead":true
//             }
//          ]
//       },
//       "allowedLessonCategory":[
//          {
//             "_id":63f0ba7fe75faea17ab6c556,
//             "reference":a1,
//             "label":a1,
//             "level":A1
//          },
//          {
//             "_id":63f0ba7fe75faea17ab6c557,
//             "reference":a2,
//             "label":a2
//          },
//          {
//             "_id":63f0ba7fe75faea17ab6c558,
//             "reference":b1,
//             "label":b1
//          },
//          {
//             "_id":63f0ba7fe75faea17ab6c55c,
//             "reference":b2,
//             "label":b2
//          },
//          {
//             "_id":63f0ba7fe75faea17ab6c55d,
//             "reference":c1,
//             "label":c1
//          },
//          {
//             "_id":63f0ba7fe75faea17ab6c55e,
//             "reference":c2,
//             "label":c2
//          }
//       ],
//       "tags":[
//          {
//             "_id":67443a18712218729f7b1a6d,
//             "reference":"agreement-and-consistency",
//             "label":"Agreement and Consistency"
//          },
//          {
//             "_id":67443a18712218729f7b1a6f,
//             "reference":"clauses-and-phrases",
//             "label":"Clauses and Phrases"
//          },
//          {
//             "_id":67443a18712218729f7b1a6e,
//             "reference":"modifiers",
//             "label":"Modifiers"
//          },
//          {
//             "_id":67443a18712218729f7b1a69,
//             "reference":"parts-of-speech",
//             "label":"Parts of Speech"
//          },
//          {
//             "_id":67443a18712218729f7b1a71,
//             "reference":"punctuation",
//             "label":"Punctuation"
//          },
//          {
//             "_id":67443a18712218729f7b1a6b,
//             "reference":"sentence-structure",
//             "label":"Sentence Structure"
//          },
//          {
//             "_id":67443a18712218729f7b1a70,
//             "reference":"special-topics",
//             "label":"Special Topics"
//          },
//          {
//             "_id":67443a18712218729f7b1a6a,
//             "reference":"tenses",
//             "label":"Tenses"
//          },
//          {
//             "_id":67443a18712218729f7b1a6c,
//             "reference":"verb-forms",
//             "label":"Verb Forms"
//          }
//       ]
//    }
// }