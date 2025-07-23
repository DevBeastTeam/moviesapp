import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_helper.dart';
import '../models/excersisesModel.dart';

var excerVm = ChangeNotifierProvider<ExcerVm>((ref) => ExcerVm());

class ExcerVm extends ChangeNotifier {
  String isLoadingFor = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoadingF([bool v = true, String? name]) {
    _isLoading = v;
    if (v) {
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

  List<ExcersisesModel> excersiseList = [];
  void getExcerF(context,
      {bool isLoading = true,
      bool showLoading = true,
      String loadingFor = ''}) async {
    try {
      // if (excersiseList.isNotEmpty) return;
      if (showLoading) {
        setLoadingF(true, loadingFor);
      }
      var data = await baseApi.get('/lessons/exercises', context);
      // debugPrint('👉 excersiseList: $data');
      log('👉 excersiseList: $data');
      if (data['success'].toString() == 'true') {
        excersiseList.clear();
        excersiseList.add(ExcersisesModel.fromJson(data['data']));
      }
      setLoadingF(false);
      notifyListeners();
    } catch (e, st) {
      log('💥 try catch when: getExcerF Error: $e, st:$st');
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
  set setslectedTabBtnIs(int index) {
    if (index >= 0) {
      _slectedTabBtnIs = index;
      notifyListeners();
    }
  }

  // List<GrammerDetailModel> excersisesSingleData = [];

  void getExcerSingleByIdF(context,
      {required id, bool showLoading = true, String loadingFor = ''}) async {
    try {
      if (showLoading) {
        setLoadingF(true, loadingFor);
      }

      log('👉 excersisesSingleData id: $id');
      var data = await baseApi.get('/lessons/exercises/$id/questions', context);
      log('👉 excersisesSingleData: $data');
      if (data['success'].toString() == 'true') {
        // excersisesSingleData.clear();
        // excersisesSingleData.add(GrammerDetailModel.fromJson(data['data']));
      }
      setLoadingF(false);

      // toast(context, msg: 'grammers geted');
      notifyListeners();
    } catch (e, st) {
      log('💥 try catch when: getExcerSingleByIdF Error: $e, st:$st');
    } finally {
      setLoadingF(false);
      notifyListeners();
    }
  }
}




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




