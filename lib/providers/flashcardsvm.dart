// FlashCardsListPage

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_helper.dart';
import '../models/flashCardsModel.dart';
import '../models/grammerDetailModel.dart';
import '../models/grammerModel.dart';

var flashCardsVM = ChangeNotifierProvider<FlashCardsVM>(
  (ref) => FlashCardsVM(),
);

class FlashCardsVM extends ChangeNotifier {
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

  var baseApi = ApiHelper();
  //////////////////////////

  List<FlashCardsModel> flashCardsList = [];

  getFlashCards(
    context, {
    bool isLoading = true,
    bool showLoading = true,
    String loadingFor = '',
  }) async {
    try {
      if (flashCardsList.isNotEmpty) return;
      if (showLoading) {
        setLoadingF(true, loadingFor);
      }
      var data = await baseApi.get('/flashcard/', context);
      // debugPrint('👉 flashCardsList: $data');
      log('👉 flashCardsList: $data');
      if (data['success'].toString() == 'true') {
        flashCardsList.clear();
        flashCardsList.add(FlashCardsModel.fromJson(data));
      }
      setLoadingF(false);
      notifyListeners();
    } catch (e, st) {
      log('💥 try catch when: getFlashCardsF Error: $e, st:$st');
    } finally {
      setLoadingF(false);
      notifyListeners();
    }
  }

  List flashCardsMoviesList = [];
  getFlashCardMoviesList(
    context, {
    bool isLoading = true,
    bool showLoading = true,
    String loadingFor = '',
    String id = "1",
  }) async {
    try {
      if (flashCardsList.isNotEmpty) return;
      if (showLoading) {
        setLoadingF(true, loadingFor);
      }
      // /flashcard/view/:movieId/:level
      var data = await baseApi.get('/flashcard/view/$id/1', context);
      // debugPrint('👉 getFlashCardMoviesList: $data');
      log('👉 getFlashCardMoviesList: $data');
      if (data['success'].toString() == 'true') {
        flashCardsMoviesList.clear();
        // flashCardsMoviesList.add(FlashCardsModel.fromJson(data));
      }
      setLoadingF(false);
      notifyListeners();
    } catch (e, st) {
      log('💥 try catch when: getFlashCardMoviesList Error: $e, st:$st');
    } finally {
      setLoadingF(false);
      notifyListeners();
    }
  }

  //////////////////////////
  List<GrammerModel> pronounciationList = [];
  void getPronounciationF(
    context, {
    bool isLoading = true,
    bool showLoading = true,
    String loadingFor = '',
  }) async {
    try {
      if (pronounciationList.isNotEmpty) return;
      if (showLoading) {
        setLoadingF(true, loadingFor);
      }
      var data = await baseApi.get('/lessons/pronunciation', context);
      debugPrint('👉 pronounciationList: $data');
      log('👉 pronounciationList: $data');
      if (data['success'].toString() == 'true') {
        pronounciationList.clear();
        // pronounciationList.add(GrammerModel.fromJson(data['data']));
      }
      setLoadingF(false);
      notifyListeners();
    } catch (e, st) {
      log('💥 try catch when: getPronounciationF Error: $e, st:$st');
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

  void getPronounciationFSingleByIdF(
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
      var data = await baseApi.get('/lessons/pronunciation/travel', context);
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

// flash cards list response ==> /flashcard/
// {
//    "success":true,
//    "movies":[
      
//    ],
//    "subjects":[
//       {
//          "_id":63f0ba743c2816767892cf1e,
//          "reference":"entertainment",
//          "label":"Entertainment",
//          "description":"Entertainment",
//          "enabled":true,
//          "created_on":"2023-02-18T11":"45":56.838Z,
//          "updated_on":"2023-02-18T11":"45":56.838Z,
//          "__v":0
//       },
//       {
//          "_id":63f0ba743c2816767892cf20,
//          "reference":"english_lessons",
//          "label":"English lessons",
//          "description":"english lessons",
//          "enabled":true,
//          "created_on":"2023-02-18T11":"45":56.839Z,
//          "updated_on":"2023-02-18T11":"45":56.839Z,
//          "__v":0
//       },
//       {
//          "_id":63f0ba743c2816767892cf21,
//          "reference":"pedagogical",
//          "label":"Pedagogical videos",
//          "description":"Professional videos",
//          "enabled":true,
//          "created_on":"2023-02-18T11":"45":56.839Z,
//          "updated_on":"2023-02-18T11":"45":56.839Z,
//          "__v":0
//       }
//    ]
// }