import 'package:edutainment/helpers/safe_converters.dart';

class GrammerDetailModel {
  lessonDetail? lesson;

  GrammerDetailModel({this.lesson});

  factory GrammerDetailModel.fromJson(Map<String, dynamic> json) =>
      GrammerDetailModel(
        lesson: json['lesson'] == null
            ? null
            : lessonDetail.fromJson(json['lesson']),
      );

  Map<String, dynamic> toJson() => {'lesson': lesson?.toJson()};
}

class lessonDetail {
  String? id;
  String? reference;
  String? content;
  String? contenten;
  String? contentfr;
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
    this.contenten = "",
    this.contentfr = "",
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
    id: json['_id'].toString().toSafeString(),
    reference: json['reference'].toString().toSafeString(),
    content: json['content'].toString().toSafeString(),
    contenten: json['contenten'].toString().toSafeString(),
    contentfr: json['contentfr'].toString().toSafeString(),
    createdAt: json['createdAt'].toString().toSafeString(),
    enabled: json['enabled'] as bool?,
    label: json['label'].toString().toSafeString(),
    profiles: json['profiles'] == null
        ? null
        : List<String>.from(json['profiles'] as List),
    questions: json['questions'] as List<dynamic>?,
    tags: json['tags'] == null ? null : List<String>.from(json['tags'] as List),
    type: json['type'].toString().toSafeString(),
    updatedAt: json['updatedAt'].toString().toSafeString(),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'reference': reference,
    'content': content,
    'contenten': contenten,
    'contentfr': contentfr,
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







// 👉 grammerSingleData
// type 1 data
// {
//    "success":true,
  //  "data":{
  //     "lesson":{
  //        "_id":652969624622968d66f2e87d,
  //        "reference":lesson146,
  //        "content":<h3 class="font-semibold text-xl">Communicating</h3>
  //     <br>
  //     <p>By inventing writing,
  //        "man thought to protect himself against the ravages of time":"he has locked up his thoughts in the book",
  //        "to which he accords an increasing confidence which nothing seems to be able to destroy And yet the book in no way deserves this excess of confidence for it is",
  //        "fundamentally",
  //        "the most indiscreet of friends":"tell it that you have just made a discovery and it forthwith sets about divulging it to the world",
  //        "as if the matter concerned the whole world. This system of having no secrets from anyone is in the end the best way of informing anyone",
  //        "since everybody knows very well that what is written is not intended for him",
  //        "personally.</p>
  //     <p>In our society",
  //        "we had preserved the ancestral custom of communicating things only to those we loved",
  //        "and with the certainty that they would make good use of our information. That is why the spoken word kept – and still keeps today – an importance that will not quickly be usurped by the newspaper and the book. The spoken word becomes even more powerful at the hour of death",
  //        "when words become sacred commands.</p>
  //     <br>
  //     <p>Excerpt from Bebey",
  //        "F. (1971). Agatha Moudio’s Son. London":"Heinemann Educational     Books.</p>",
  //        "createdAt":"2023-10-13T15":"59":30.199Z,
  //        "enabled":false,
  //        "label":Bac (Literature)1996,
  //        "profiles":[
  //           cm2,
  //        ],
  //        "questions":[
            
  //        ],
  //        "tags":[
  //           "bac"
  //        ],
  //        "type":"grammar",
  //        "updatedAt":"2023-12-18T10":"04":14.541Z
  //     }
  //  }
// }




// type 2 data
// {
//    "success":true,
//    "data":{
//       "lesson":{
//          "_id":652969624622968d66f2e888,
//          "reference":lesson157,
//          "content":"<p>We’re all involved in the oil business. Every time we start our cars",
//          "turn on our lights",
//          "cook a meal",
//          "or heat our homes",
//          "we’re relying on some form of fuel to make it happen.</p>
//       <p>Up to now",
//          "oil has inevitably been a fossil fuel",
//          "part of the carbon chain. And",
//          "just as inevitably",
//          "that will have to change. Long before we decide to stop using fossil fuels",
//          "costs will have already made the decision for us. These are not just the monetary cost",
//          "the cultural cost",
//          "and the environmental costs.  </p>
//       <p>We will",
//          "quite rightly",
//          "demand that our future energy is both sustainable and renewable.  We will expect a lot from the likes of solar power and hydrogen fuel cells. And",
//          it will take time.  Various estimates suggest that by the year 2050,
//          "nearly one third of the world’s energy needs could come from just such sources. Which leaves the other two thirds to come from conventional fuels",
//          "such as oil and gas. To make that happen",
//          "we have to strike a balance between the need to protect people’s way of life and their environment and the need to provide people with affordable energy.  </p>",
//          "createdAt":"2023-10-13T15":"59":30.199Z,
//          "enabled":false,
//          "label":"Bac (Year unknown)",
//          "profiles":[
//             cm2,
//             6eme,
//             5eme,
//             4eme,
//             3eme,
//             "seconde",
//             1ere,
//             "terminale",
//             1ere_annee,
//             2eme_annee,
//             3eme_annee,
//             4eme_annee,
//             5eme_annee,
//             1ere_annee_toeic,
//             2eme_annee_toeic,
//             3eme_annee_toeic,
//             4eme_annee_toeic,
//             5eme_annee_toeic,
//             "demandeur_emploi",
//             "actif_voyage",
//             "actif_demenagement",
//             "actif_professionnel",
//             1ere_annee_finance,
//             2eme_annee_finance,
//             3eme_annee_finance,
//             4eme_annee_finance,
//             5eme_annee_finance,
//             1ere_annee_digital,
//             2eme_annee_digital,
//             3eme_annee_digital,
//             4eme_annee_digital,
//             5eme_annee_digital,
//             1ere_annee_business,
//             2eme_annee_business,
//             3eme_annee_business,
//             4eme_annee_business,
//             5eme_annee_business,
//             1ere_annee_production,
//             2eme_annee_production,
//             3eme_annee_production,
//             4eme_annee_production,
//             5eme_annee_production,
//             1ere_annee_luxe,
//             2eme_annee_luxe,
//             3eme_annee_luxe,
//             4eme_annee_luxe,
//             5eme_annee_luxe,
//             1ere_annee_luxe_business,
//             2eme_annee_luxe_business,
//             3eme_annee_luxe_business,
//             4eme_annee_luxe_business,
//             5eme_annee_luxe_business,
//             1ere_annee_management,
//             2eme_annee_management,
//             3eme_annee_management,
//             4eme_annee_management,
//             5eme_annee_management,
//             1ere_annee_finance_toeic,
//             2eme_annee_finance_toeic,
//             3eme_annee_finance_toeic,
//             4eme_annee_finance_toeic,
//             5eme_annee_finance_toeic,
//             1ere_annee_digital_toeic,
//             2eme_annee_digital_toeic,
//             3eme_annee_digital_toeic,
//             4eme_annee_digital_toeic,
//             5eme_annee_digital_toeic,
//             1ere_annee_business_toeic,
//             2eme_annee_business_toeic,
//             3eme_annee_business_toeic,
//             4eme_annee_business_toeic,
//             5eme_annee_business_toeic,
//             1ere_annee_production_toeic,
//             2eme_annee_production_toeic,
//             3eme_annee_production_toeic,
//             4eme_annee_production_toeic,
//             5eme_annee_production_toeic,
//             1ere_annee_luxe_toeic,
//             2eme_annee_luxe_toeic,
//             3eme_annee_luxe_toeic,
//             4eme_annee_luxe_toeic,
//             5eme_annee_luxe_toeic,
//             1ere_annee_luxe_business_toeic,
//             2eme_annee_luxe_business_toeic,
//             3eme_annee_luxe_business_toeic,
//             4eme_annee_luxe_business_toeic,
//             5eme_annee_luxe_business_toeic,
//             1ere_annee_management_toeic,
//             2eme_annee_management_toeic,
//             3eme_annee_management_toeic,
//             4eme_annee_management_toeic,
//             5eme_annee_management_toeic
//          ],
//          "questions":[
            
//          ],
//          "tags":[
//             "bac"
//          ],
//          "type":"grammar",
//          "updatedAt":"2023-12-18T10":"04":14.541Z
//       }
//    }
// }