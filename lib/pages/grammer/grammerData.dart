import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_helper.dart';
import '../../models/grammerDetailModel.dart';
import '../../models/grammerModel.dart';

var grammerData = ChangeNotifierProvider<GrammerData>((ref) => GrammerData());

class GrammerData extends ChangeNotifier {
  String isLoadingFor = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoadingF([bool v = true, String? name]) {
    _isLoading = v;
    if (v == true) {
      isLoadingFor = name ?? '';
    } else {
      isLoadingFor = '';
    }
    notifyListeners();
  }

  int _expandedIndexIs = 0;
  int get expandedIndexIs => _expandedIndexIs;
  set setExpandedIndexIs(int value) {
    _expandedIndexIs = value;
    notifyListeners();
  }

  //////////////////////////
  var baseApi = ApiHelper();

  List<GrammerModel> grammersList = [];
  void getGrammersF(
    context, {
    bool isLoading = true,
    bool showLoading = true,
    String loadingFor = '',
  }) async {
    try {
      if (grammersList.isNotEmpty) return;
      if (showLoading) {
        setLoadingF(true, loadingFor);
      }
      var data = await baseApi.get('/lessons/grammar', context);
      // debugPrint('👉 grammersList: $data');
      log('👉 grammersList: $data');
      if (data['success'].toString() == 'true') {
        grammersList.clear();
        grammersList.add(GrammerModel.fromJson(data['data']));
      }
      setLoadingF(false);

      // toast(context, msg: 'grammers geted');
      notifyListeners();
    } catch (e, st) {
      log('💥 try catch when: getGrammersF Error: $e, st:$st');
    } finally {
      setLoadingF(false);
      notifyListeners();
    }
  }

  int _slectedLableIndexIs = 0;
  int get sletedLableIndexIs => _slectedLableIndexIs;
  set setSelctedLableIndexIs(int index) {
    if (index >= 0) {
      _slectedLableIndexIs = index;
      notifyListeners();
    }
  }

  int _slectedTabBtnIs = 0;
  int get slectedTabBtnIs => _slectedTabBtnIs;
  set setSlectedTabBtnIs(int index) {
    if (index >= 0) {
      _slectedTabBtnIs = index;
      notifyListeners();
    }
  }

  List<GrammerDetailModel> grammerSingleData = [];

  void getGrammerSingleByIdF(
    context, {
    required String id,
    bool showLoading = true,
    String loadingFor = '',
  }) async {
    try {
      if (showLoading) {
        setLoadingF(true, loadingFor);
      }

      log('👉 grammerSingleData id: $id');
      // /lessons/exercises/lessonId/questions --> 652969624622968d66f2e888
      var data = await baseApi.get('/lessons/grammar/$id', context);
      log('👉 grammerSingleData: $data');
      if (data['success'].toString() == 'true') {
        grammerSingleData.clear();
        grammerSingleData.add(GrammerDetailModel.fromJson(data['data']));
      }
      setLoadingF(false);

      // toast(context, msg: 'grammers geted');
      notifyListeners();
    } catch (e, st) {
      log('💥 try catch when: getGrammersSingleByIdF Error: $e, st:$st');
    } finally {
      setLoadingF(false);
      notifyListeners();
    }
  }
}







// https://play.e-dutainment.com/api/1.0/movies/list


// [log] 👉 grammersList: {success: true, data: {groupLessons: {
//
//expressing_simultaneity: [{_id: 652969624622968d66f2e84e, reference: lesson99, label: Expressing Simultaneity 2, tags: [expressing_simultaneity], isRead: false}],
//
//bac: [{_id: 652969624622968d66f2e87b, reference: lesson144, label: Bac (Literature) 1994, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e887, reference: lesson156, label: Bac (literature) 2006, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e87d, reference: lesson146, label: Bac (Literature)1996, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e886, reference: lesson155, label: Bac (science) 2006, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e889, reference: lesson158, label: Bac (science) Year Unknown, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e88a, reference: lesson159, label: Bac (Year Known), tags: [bac], isRead: false}, {_id: 652969624622968d66f2e888, reference: lesson157, label: Bac (Year unknown), tags: [bac], isRead: false}, {_id: 652969624622968d66f2e87a, reference: lesson143, label: Bac 1993, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e87c, reference: lesson145, label: Bac 1995, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e87e, reference: lesson147, label: Bac 1997, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e87f, reference: lesson148, label: Bac 2000, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e880, reference: lesson149, label: Bac 2002, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e881, reference: lesson150, label: Bac 2003, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e882, reference: lesson151, label: Bac 2003, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e883, reference: lesson152, label: Bac 2004, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e884, reference: lesson153, label: Bac 2004, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e885, reference: lesson154, label: Bac 2004, tags: [bac], isRead: false}, {_id: 652969624622968d66f2e88b, reference: lesson160, label: Practice Bac, tags: [bac], isRead: false}]
//
//, visits: [{_id: 652969624622968d66f2e88c, reference: lesson161, label: Binta Visits New York, tags: [visits], isRead: false}, {_id: 652969624622968d66f2e88d, reference: lesson162, label: Mariam Visits a Village, tags: [visits], isRead: false}],
//
//croesus_ans_solon: [{_id: 652969624622968d66f2e88e, reference: lesson163, label: Croesus and Solon, tags: [croesus_ans_solon], isRead: false}],
//
//city_mouse: [{_id: 652969624622968d66f2e88f, reference: lesson164, label: City Mouse and Village Mouse, tags: [city_mouse], isRead: false}],
//
//history: [{_id: 652969624622968d66f2e890, reference: lesson165, label: The History of Flight, tags: [history], isRead: true}]
//
//, americans: [{_id: 652969624622968d66f2e891, reference: lesson166, label: Famous Americans, tags: [americans], isRead: false}], conjugation: [{_id: 652969624622968d66f2e894, reference: lesson169, label: Infinitive         Simple           Past                French                Infinitive           Simple           Past            French, tags: [conjugation], isRead: false}, {_id: 652969624622968d66f2e893, reference: lesson168, label: SIMPLE PAST, tags: [conjugation], isRead: false}, {_id: 652969624622968d66f2e892, reference: lesson167, label: Verb Review Sheet, tags: [conjugation], isRead: false}],
//
// passive voice: [{_id: 652969624622968d66f2e895, reference: lesson170, label: Passive Voice, tags: [passive voice], isRead: false}]},
//
// allowedLessonCategory: [{_id: 63f0ba7fe75faea17ab6c556, reference: a1, label: a1, level: A1}, {_id: 63f0ba7fe75faea17ab6c557, reference: a2, label: a2}, {_id: 63f0ba7fe75faea17ab6c558, reference: b1, label: b1}, {_id: 63f0ba7fe75faea17ab6c55c, reference: b2, label: b2}, {_id: 63f0ba7fe75faea17ab6c55d, reference: c1, label: c1}, {_id: 63f0ba7fe75faea17ab6c55e, reference: c2, label: c2}], tags: [{_id: 67443a18712218729f7b1a6d, reference: agreement-and-consistency, label: Agreement and Consistency}, {_id: 67443a18712218729f7b1a6f, reference: clauses-and-phrases, label: Clauses and Phrases}, {_id: 67443a18712218729f7b1a6e, reference: modifiers, label: Modifiers}, {_id: 67443a18712218729f7b1a69, reference: parts-of-speech, label: Parts of Speech}, {_id: 67443a18712218729f7b1a71, reference: punctuation, label: Punctuation}, {_id: 67443a18712218729f7b1a6b, reference: sentence-structure, label: Sentence Structure}, {_id: 67443a18712218729f7b1a70, reference: special-topics, label: Special Topics}, {_id: 67443a18712218729f7b1a6a, reference: tenses, label: Tenses}, {_id: 67443a18712218729f7b1a6c, reference: verb-forms, label: Verb Forms}]}}



// {
//   success: true, data:
//   {
//    "groupLessons":{
//       "expressing_simultaneity":[
//          {
//             "_id":652969624622968d66f2e84e,
//             "reference":lesson99,
//             "label":Expressing Simultaneity 2,
//             "tags":[
//                "expressing_simultaneity"
//             ],
//             "isRead":false
//          }
//       ],
//       "bac":[
//          {
//             "_id":652969624622968d66f2e87b,
//             "reference":lesson144,
//             "label":Bac (Literature) 1994,
//             "tags":[
//                "bac"
//             ],
//             "isRead":false
//          },

//          {
//             "_id":652969624622968d66f2e88b,
//             "reference":lesson160,
//             "label":"Practice Bac",
//             "tags":[
//                "bac"
//             ],
//             "isRead":false
//          }
//       ],
//       "visits":[
//          {
//             "_id":652969624622968d66f2e88c,
//             "reference":lesson161,
//             "label":"Binta Visits New York",
//             "tags":[
//                "visits"
//             ],
//             "isRead":false
//          },
//          {
//             "_id":652969624622968d66f2e88d,
//             "reference":lesson162,
//             "label":"Mariam Visits a Village",
//             "tags":[
//                "visits"
//             ],
//             "isRead":false
//          }
//       ],
//       "croesus_ans_solon":[
//          {
//             "_id":652969624622968d66f2e88e,
//             "reference":lesson163,
//             "label":"Croesus and Solon",
//             "tags":[
//                "croesus_ans_solon"
//             ],
//             "isRead":false
//          }
//       ],
//       "city_mouse":[
//          {
//             "_id":652969624622968d66f2e88f,
//             "reference":lesson164,
//             "label":"City Mouse and Village Mouse",
//             "tags":[
//                "city_mouse"
//             ],
//             "isRead":false
//          }
//       ],
//       "history":[
//          {
//             "_id":652969624622968d66f2e890,
//             "reference":lesson165,
//             "label":"The History of Flight",
//             "tags":[
//                "history"
//             ],
//             "isRead":true
//          }
//       ],
//       "americans":[
//          {
//             "_id":652969624622968d66f2e891,
//             "reference":lesson166,
//             "label":"Famous Americans",
//             "tags":[
//                "americans"
//             ],
//             "isRead":false
//          }
//       ],
//       "conjugation":[
//          {
//             "_id":652969624622968d66f2e894,
//             "reference":lesson169,
//             "label":"Infinitive         Simple           Past                French                Infinitive           Simple           Past            French",
//             "tags":[
//                "conjugation"
//             ],
//             "isRead":false
//          },
//          {
//             "_id":652969624622968d66f2e893,
//             "reference":lesson168,
//             "label":"SIMPLE PAST",
//             "tags":[
//                "conjugation"
//             ],
//             "isRead":false
//          },
//          {
//             "_id":652969624622968d66f2e892,
//             "reference":lesson167,
//             "label":"Verb Review Sheet",
//             "tags":[
//                "conjugation"
//             ],
//             "isRead":false
//          }
//       ],
//       "passive voice":[
//          {
//             "_id":652969624622968d66f2e895,
//             "reference":lesson170,
//             "label":"Passive Voice",
//             "tags":[
//                "passive voice"
//             ],
//             "isRead":false
//          }
//       ]
//    },

//    "allowedLessonCategory":[
//    {
//       "_id":63f0ba7fe75faea17ab6c556,
//       "reference":a1,
//       "label":a1,
//       "level":A1
//    },
//    {
//       "_id":63f0ba7fe75faea17ab6c557,
//       "reference":a2,
//       "label":a2
//    },
//    {
//       "_id":63f0ba7fe75faea17ab6c558,
//       "reference":b1,
//       "label":b1
//    },
//    {
//       "_id":63f0ba7fe75faea17ab6c55c,
//       "reference":b2,
//       "label":b2
//    },
//    {
//       "_id":63f0ba7fe75faea17ab6c55d,
//       "reference":c1,
//       "label":c1
//    },
//    {
//       "_id":63f0ba7fe75faea17ab6c55e,
//       "reference":c2,
//       "label":c2
//    }
// ],
// "tags":[
//    {
//       "_id":67443a18712218729f7b1a6d,
//       "reference":"agreement-and-consistency",
//       "label":"Agreement and Consistency"
//    },
//    {
//       "_id":67443a18712218729f7b1a6f,
//       "reference":"clauses-and-phrases",
//       "label":"Clauses and Phrases"
//    },
//    {
//       "_id":67443a18712218729f7b1a6e,
//       "reference":"modifiers",
//       "label":"Modifiers"
//    },
//    {
//       "_id":67443a18712218729f7b1a69,
//       "reference":"parts-of-speech",
//       "label":"Parts of Speech"
//    },
//    {
//       "_id":67443a18712218729f7b1a71,
//       "reference":"punctuation",
//       "label":"Punctuation"
//    },
//    {
//       "_id":67443a18712218729f7b1a6b,
//       "reference":"sentence-structure",
//       "label":"Sentence Structure"
//    },
//    {
//       "_id":67443a18712218729f7b1a70,
//       "reference":"special-topics",
//       "label":"Special Topics"
//    },
//    {
//       "_id":67443a18712218729f7b1a6a,
//       "reference":"tenses",
//       "label":"Tenses"
//    },
//    {
//       "_id":67443a18712218729f7b1a6c,
//       "reference":"verb-forms",
//       "label":"Verb Forms"
//    }
//   ]
//  }
// }






// 👉 grammerSingleData
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