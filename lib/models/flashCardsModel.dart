import 'package:edutainment/helpers/forstrings.dart';

class FlashCardsModel {
  final bool success;
  final List<FlashCardsMovie> movies;
  final List<Subject> subjects;

  FlashCardsModel({
    required this.success,
    required this.movies,
    required this.subjects,
  });

  factory FlashCardsModel.fromJson(Map<String, dynamic> json) {
    return FlashCardsModel(
      success: json['success'] ?? false,
      movies:
          (json['movies'] as List<dynamic>?)
              ?.map((e) => FlashCardsMovie.fromJson(e))
              .toList() ??
          [],
      subjects:
          (json['subjects'] as List<dynamic>?)
              ?.map((e) => Subject.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'movies': movies.map((e) => e.toJson()).toList(),
      'subjects': subjects.map((e) => e.toJson()).toList(),
    };
  }
}

class FlashCardsMovie {
  final String id;
  final String reference;
  final String label;
  final List<String> tags;
  final String subject;
  final String picture;

  FlashCardsMovie({
    this.id = "",
    required this.reference,
    required this.label,
    required this.tags,
    required this.subject,
    required this.picture,
  });

  factory FlashCardsMovie.fromJson(Map<String, dynamic> json) {
    return FlashCardsMovie(
      id: json['_id'].toString().toNullString(),
      reference: json['reference'].toString().toNullString(),
      label: json['label'].toString().toNullString(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      subject: json['Subject'].toString().toNullString(), // Note the capital 'S' to match your JSON
      picture: json['picture'].toString().toNullString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'label': label,
      'tags': tags,
      'Subject': subject, // Note the capital 'S' to match your JSON
      'picture': picture,
    };
  }
}

class Subject {
  final String id;
  final String reference;
  final String label;
  final String description;
  final bool enabled;
  final DateTime createdOn;
  final DateTime updatedOn;
  final int v;

  Subject({
    required this.id,
    required this.reference,
    required this.label,
    required this.description,
    required this.enabled,
    required this.createdOn,
    required this.updatedOn,
    required this.v,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['_id'].toString().toNullString(),
      reference: json['reference'].toString().toNullString(),
      label: json['label'].toString().toNullString(),
      description: json['description'].toString().toNullString(),
      enabled: json['enabled'] ?? false,
      createdOn: DateTime.parse(
        json['created_on'] ?? DateTime.now().toIso8601String(),
      ),
      updatedOn: DateTime.parse(
        json['updated_on'] ?? DateTime.now().toIso8601String(),
      ),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reference': reference,
      'label': label,
      'description': description,
      'enabled': enabled,
      'created_on': createdOn.toIso8601String(),
      'updated_on': updatedOn.toIso8601String(),
      '__v': v,
    };
  }
}








// {
//    "success":true,
//    "flashcards":[
      
//    ],
//    "levels":[
//       {
//          "_id":63f0ba6ce75faea17ab6c502,
//          "reference":"lion_cub",
//          "label":Lion Cub - A2,
//          "enabled":true
//       },
//       {
//          "_id":63f0ba6ce75faea17ab6c501,
//          "reference":"a_wannabe_lion",
//          "label":A Wannabe Lion - A1,
//          "enabled":true
//       },
//       {
//          "_id":63f0ba6ce75faea17ab6c503,
//          "reference":"feline",
//          "label":Feline - B1,
//          "enabled":true
//       },
//       {
//          "_id":63f0ba6ce75faea17ab6c507,
//          "reference":"predator",
//          "label":Predator - B2,
//          "enabled":true
//       },
//       {
//          "_id":63f0ba6ce75faea17ab6c508,
//          "reference":"king_of_the_jungle",
//          "label":King of The Jungle - C1,
//          "enabled":true
//       },
//       {
//          "_id":63f0ba6ce75faea17ab6c509,
//          "reference":"legend",
//          "label":Legend - C2,
//          "enabled":true
//       }
//    ],
//    "currentLevel":a4,
//    "movie":{
//       "_id":650b118f4622968d6654b8d9,
//       "reference":globetrotting12,
//       "Subject":63f0ba743c2816767892cf1e,
//       "createdAt":"2023-09-20T15":"36":47.375Z,
//       "description":"Hotspots – The Taj Mahal",
//       "The Ganges and New Delhi",
//       "duration":308,
//       "enabled":true,
//       "label":Globetrotting – Episode 12,
//       "m3u8_link":"https"://e-dutainment.s3.eu-west-1.amazonaws.com/bento/GLOBETROTTING/Globetrotting_12/stream.m3u8,
//       "mpd_link":"https"://e-dutainment.s3.eu-west-1.amazonaws.com/bento/GLOBETROTTING/Globetrotting_12/stream.mpd,
//       "picture":"https"://d2cj5ez5n4d4vx.cloudfront.net/pictures/Globe-Trotting_12.png,
//       "profiles":[
//          1ere_annee,
//          2eme_annee,
//          3eme_annee,
//          4eme_annee,
//          5eme_annee,
//          1ere_annee_toeic,
//          2eme_annee_toeic,
//          3eme_annee_toeic,
//          4eme_annee_toeic,
//          5eme_annee_toeic,
//          "demandeur_emploi",
//          "actif_voyage",
//          "actif_demenagement",
//          "actif_professionnel",
//          1ere_annee_finance,
//          2eme_annee_finance,
//          3eme_annee_finance,
//          4eme_annee_finance,
//          5eme_annee_finance,
//          1ere_annee_digital,
//          2eme_annee_digital,
//          3eme_annee_digital,
//          4eme_annee_digital,
//          5eme_annee_digital,
//          1ere_annee_business,
//          2eme_annee_business,
//          3eme_annee_business,
//          4eme_annee_business,
//          5eme_annee_business,
//          1ere_annee_production,
//          2eme_annee_production,
//          3eme_annee_production,
//          4eme_annee_production,
//          5eme_annee_production,
//          1ere_annee_luxe,
//          2eme_annee_luxe,
//          3eme_annee_luxe,
//          4eme_annee_luxe,
//          5eme_annee_luxe,
//          1ere_annee_luxe_business,
//          2eme_annee_luxe_business,
//          3eme_annee_luxe_business,
//          4eme_annee_luxe_business,
//          5eme_annee_luxe_business,
//          1ere_annee_management,
//          2eme_annee_management,
//          3eme_annee_management,
//          4eme_annee_management,
//          5eme_annee_management,
//          1ere_annee_finance_toeic,
//          2eme_annee_finance_toeic,
//          3eme_annee_finance_toeic,
//          4eme_annee_finance_toeic,
//          5eme_annee_finance_toeic,
//          1ere_annee_digital_toeic,
//          2eme_annee_digital_toeic,
//          3eme_annee_digital_toeic,
//          4eme_annee_digital_toeic,
//          5eme_annee_digital_toeic,
//          1ere_annee_business_toeic,
//          2eme_annee_business_toeic,
//          3eme_annee_business_toeic,
//          4eme_annee_business_toeic,
//          5eme_annee_business_toeic,
//          1ere_annee_production_toeic,
//          2eme_annee_production_toeic,
//          3eme_annee_production_toeic,
//          4eme_annee_production_toeic,
//          5eme_annee_production_toeic,
//          1ere_annee_luxe_toeic,
//          2eme_annee_luxe_toeic,
//          3eme_annee_luxe_toeic,
//          4eme_annee_luxe_toeic,
//          5eme_annee_luxe_toeic,
//          1ere_annee_luxe_business_toeic,
//          2eme_annee_luxe_business_toeic,
//          3eme_annee_luxe_business_toeic,
//          4eme_annee_luxe_business_toeic,
//          5eme_annee_luxe_business_toeic,
//          1ere_annee_management_toeic,
//          2eme_annee_management_toeic,
//          3eme_annee_management_toeic,
//          4eme_annee_management_toeic,
//          5eme_annee_management_toeic
//       ],
//       "tags":[
//          "travel",
//          "globetrotting"
//       ],
//       "updatedAt":"2024-03-06T10":"59":45.512Z
//    }
// }