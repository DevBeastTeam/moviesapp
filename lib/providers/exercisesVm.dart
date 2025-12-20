import 'dart:developer';
import 'package:edutainment/models/excLessonsStepsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../core/api_helper.dart';
import '../models/excersisesModel.dart';

var excerVm = ChangeNotifierProvider<ExcerVm>((ref) => ExcerVm());

class ExcerVm extends ChangeNotifier {
  String _loadingFor = "";
  String get loadingFor => _loadingFor;
  void setLoadingF([String name = ""]) {
    _loadingFor = name;
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

  List<ExcersisesModel> excersiseList = [];
  void getExcerF(
    context, {
    bool isLoading = true,
    bool showLoading = true,
    String loadingFor = '',
    bool isRefresh = false,
  }) async {
    try {
      if (!isRefresh && excersiseList.isNotEmpty) return;
      setLoadingF(loadingFor);
      var data = await baseApi.get('/lessons/exercises', context);
      // debugPrint('👉 excersiseList: $data');
      log('👉 getExcerF excersiseList: $data');
      if (data['success'].toString() == 'true') {
        excersiseList.clear();
        excersiseList.add(ExcersisesModel.fromJson(data['data']));
      }
      setLoadingF();
    } catch (e, st) {
      log('💥 try catch when: getExcerF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  ////////
  ExerciseLessonsStepModel? excercisesCatgLessonsSteps;
  String catgRefTemp = "";
  void getExcercisesCatgLessonsStepsF(
    context, {
    String loadingFor = '',
    String catgRef = '',
    bool isRefresh = false,
  }) async {
    try {
      // if (!isRefresh && excercisesCatgLessonsSteps != null) return;
      setLoadingF(loadingFor);
      catgRefTemp = catgRef;

      // var data = await baseApi.get('/lessons/exercises/path/$catgRef', context);
      var data = await baseApi.get(
        '/lessons/exercises/category/$catgRef',
        context,
      );

      debugPrint('👉 getExcercisesCatgLessonsStepsF: $data');
      // log('👉 getExcerByCatgRef: $data');
      if (data['success'].toString() == 'true') {
        if (data['data'] != null) {
          excercisesCatgLessonsSteps = ExerciseLessonsStepModel.fromJson(data);
        }
      }
      setLoadingF();
    } catch (e, st) {
      log('💥 try catch when: getExcerByCatgRef Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  //////// submit answer
  // /lessons/exercises/:id
  void submitExcercisesAnswerF(
    context, {
    String loadingFor = '',
    String answerId = '',
  }) async {
    try {
      if (excercisesCatgLessonsSteps != null) return;
      setLoadingF(loadingFor);
      var data = await baseApi.post('/lessons/exercises/$answerId', {
        "answers": [answerId],
      }, context);

      debugPrint('👉 submitExcercisesAnswerF: $data');
      if (data['success'].toString() == 'true') {
        // relaod lessona
        getExcercisesCatgLessonsStepsF(
          context,
          catgRef: catgRefTemp,
          isRefresh: true,
        );
      }
      setLoadingF();
    } catch (e, st) {
      log('💥 try catch when: submitExcercisesAnswerF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }
}
//   int _slectedLableIndexIs = 0;
//   int get sletedLableIndexIs => _slectedLableIndexIs;
//   set setSelctedLableIndexIs(int index) {
//     if (index >= 0) {
//       _slectedLableIndexIs = index;
//       notifyListeners();
//     }
//   }

//   int _slectedTabBtnIs = 0;
//   int get slectedTabBtnIs => _slectedTabBtnIs;
//   set setslectedTabBtnIs(int index) {
//     if (index >= 0) {
//       _slectedTabBtnIs = index;
//       notifyListeners();
//     }
//   }

//   // List<GrammerDetailModel> excersisesSingleData = [];

//   void getExcerSingleByIdF(
//     context, {
//     required id,
//     bool showLoading = true,
//     String loadingFor = '',
//   }) async {
//     try {
//       if (showLoading) {
//         setLoadingF(loadingFor);
//       }

//       log('👉 excersisesSingleData id: $id');
//       var data = await baseApi.get('/lessons/exercises/$id/questions', context);
//       log('👉 excersisesSingleData: $data');
//       if (data['success'].toString() == 'true') {
//         // excersisesSingleData.clear();
//         // excersisesSingleData.add(GrammerDetailModel.fromJson(data['data']));
//       }
//       setLoadingF();

//       // toast(context, msg: 'grammers geted');
//       notifyListeners();
//     } catch (e, st) {
//       log('💥 try catch when: getExcerSingleByIdF Error: $e, st:$st');
//     } finally {
//       setLoadingF();
//       notifyListeners();
//     }
//   }
// }




// [log] 👉 excersiseList:

//  {
//    "success":true,
//    "data":{
//       "groupLessons":{
//          "a1":[
            
//          ],
//          "a2":[
            
//          ],
//          "b1":[
            
//          ],
//          "b2":[
            
//          ],
//          "c1":[
            
//          ],
//          "c2":[
            
//          ]
//       },
//       "allowedLessonCategory":[
//          {
//             "_id":63f0ba7fe75faea17ab6c556,
//             "reference":a1,
//             "label":a1,
//             "level":A1
//          },
       
//       ],
//       "tags":[
//          {
//             "_id":650b12aca0220be99027bd4d,
//             "reference":"history",
//             "label":"history"
//          },
//       ],
//       "userLevel":{
//          "index":2
//       }
//    }
// }




