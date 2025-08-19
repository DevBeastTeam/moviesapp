import 'dart:async';
import 'dart:developer';
import 'package:edutainment/constants/toats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_helper.dart';
import '../models/grammerDetailModel.dart';
import '../models/grammerModel.dart';

var grammerData = ChangeNotifierProvider<GrammerData>((ref) => GrammerData());

class GrammerData extends ChangeNotifier {
  //////////////////////////
  var baseApi = ApiHelper();

  List<GrammerDetailModel> grammerSingleData = [];
  List<GrammerModel> grammersList = []; // data will be stored
  String isLoadingFor = '';

  int _expandedIndexIs = 0;
  int _slectedLableIndexIs = 0;
  int _slectedTabBtnIs = 0;



  String _loadingFor = "";
  String get loadingFor => _loadingFor;
  void setLoadingF([String name = ""]) {
    _loadingFor = name;
    notifyListeners();
  }

  int get expandedIndexIs => _expandedIndexIs;

  set setExpandedIndexIs(int value) {
    _expandedIndexIs = value;
    notifyListeners();
  }

  ////////
  void getGrammersF(
    context, {
    String loadingFor = '',
  }) async {
    try {
      if (grammersList.isNotEmpty) return;
        setLoadingF(loadingFor);
      
      var data = await baseApi.get('/lessons/grammar', context);
      // debugPrint('👉 grammersList: $data');
      log('👉 grammersList: $data');
      if (data['success'].toString() == 'true') {
        grammersList.clear();
        grammersList.add(GrammerModel.fromJson(data['data']));
      }
      setLoadingF();

      // toast(context, msg: 'grammers geted');
      notifyListeners();
    } catch (e, st) {
      log('💥 try catch when: getGrammersF Error: $e, st:$st');
    } finally {
      setLoadingF();
      notifyListeners();
    }
  }

   ////////
  //  List grammersCatgList = [] ;
  //  getGrammersByIdForCatgListF(
  //   context, {
  //   String levelId = '',
  //   String loadingFor = '',
  // }) async {
  //   try {
  //     // if (grammersList.isNotEmpty) return;
  //       setLoadingF(loadingFor);
      
  //     // debugPrint('👉 grammersList: $data');
  //     var data = await baseApi.get('/lessons/grammar/$levelId', context);

  //     log('👉 getGrammersByIdForCatgListF: $data');
  //     if (data['success'].toString() == 'true') {
  //       // grammersCatgList.clear();
  //       // grammersCatgList.add(GrammerModel.fromJson(data['data']));
  //     }

  //     setLoadingF();

  //     // toast(context, msg: 'grammers geted');
  //     notifyListeners();
  //   } catch (e, st) {
  //     log('💥 try catch when: getGrammersByIdForCatgListF Error: $e, st:$st');
  //   } finally {
  //     setLoadingF();
  //     notifyListeners();
  //   }
  // }



  int get sletedLableIndexIs => _slectedLableIndexIs;

  set setSelctedLableIndexIs(int index) {
    if (index >= 0) {
      _slectedLableIndexIs = index;
      notifyListeners();
    }
  }

  int get slectedTabBtnIs => _slectedTabBtnIs;

  set setSlectedTabBtnIs(int index) {
    if (index >= 0) {
      _slectedTabBtnIs = index;
      notifyListeners();
    }
  }

  void getGrammerSingleByIdF(
    context, {
    required String id,
    String loadingFor = '',
  }) async {
    try {
        setLoadingF(loadingFor);

      log('👉 grammerSingleData id: $id');
      // /lessons/exercises/lessonId/questions --> 652969624622968d66f2e888
      var data = await baseApi.get('/lessons/grammar/$id', context);
      
      log('👉 grammerSingleData: $data');

      if (data['success'].toString() == 'true') {
        grammerSingleData.clear();
        grammerSingleData.add(GrammerDetailModel.fromJson(data['data']));
      }
      setLoadingF();

      // toast(context, msg: 'grammers geted');
      notifyListeners();
    } catch (e, st) {
      log('💥 try catch when: getGrammersSingleByIdF Error: $e, st:$st');
    } finally {
      setLoadingF();
      notifyListeners();
    }
  }

////////////////////////

  Timer? _timer;
  int remainingSeconds = 10;
  bool isTimerStart = false;
  bool _disposed = false;

  void stopTimer() {
    _timer?.cancel();
    isTimerStart = false;
    remainingSeconds = 10;
    _safeNotify();
  }

  void playTimer(BuildContext context, {List labelsLessons = const []}) {
    if (isTimerStart || _disposed) return;

    isTimerStart = true;
    _safeNotify();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }

      if (remainingSeconds <= 1) {
        remainingSeconds = 10;
        
        if (sletedLableIndexIs < labelsLessons.length - 1) {
          setSelctedLableIndexIs = sletedLableIndexIs + 1;
          getGrammerSingleByIdF(
            context,
            loadingFor: 'next',
            id: labelsLessons[sletedLableIndexIs + 1].id,
          );
        } else {
          toast(context, msg: "Maximum Reached");
          stopTimer();
        }
      } else {
        remainingSeconds--;
      }
      
      _safeNotify();
    });
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }




////////////////////////
// Timer? timer;
//   int remainingSeconds = 4;
//   bool isTimerStart = false;

//   void stopTimer() {
//     timer?.cancel();
//     isTimerStart = false;
//     notifyListeners();
//   }

//   void playTimer(BuildContext context, {List labelsLessons = const []}) {
//     if (isTimerStart) return; // Prevent multiple timers
    
//     isTimerStart = true;
//     notifyListeners();

//     timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (remainingSeconds <= 1) {
//         remainingSeconds = 4;
        
//         // Check if we can move to next item
//         if (sletedLableIndexIs < labelsLessons.length - 1) {
//           setSelctedLableIndexIs = sletedLableIndexIs + 1;
//           getGrammerSingleByIdF(
//             context,
//             loadingFor: 'next',
//             id: labelsLessons[sletedLableIndexIs + 1].id,
//           );
//         } else {
//           toast(context, msg: "Maximum Reached");
//           stopTimer();
//         }
//       } else {
//         remainingSeconds--;
//       }
      
//       notifyListeners();
//     });
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

}