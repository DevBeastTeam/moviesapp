import 'dart:developer';
import 'package:edutainment/models/flashcardDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/api_helper.dart';
import '../models/flashCardsModel.dart';
import '../models/grammerDetailModel.dart';
import '../models/grammerModel.dart';

class FlashCardsController extends GetxController {
  var baseApi = ApiHelper();

  final _loadingFor = "".obs;
  String get loadingFor => _loadingFor.value;
  void setLoadingF([String name = ""]) {
    _loadingFor.value = name;
  }

  final _selectedSubjectIs = "".obs;
  String get selectedSubject => _selectedSubjectIs.value;
  void setSelectSubject(String value) {
    _selectedSubjectIs.value = value;
  }

  final _expandedIndexIs = 0.obs;
  int get expandedIndexIs => _expandedIndexIs.value;
  set setExpandedIndexIs(int value) {
    _expandedIndexIs.value = value;
  }

  var flashCardsList = <FlashCardsModel>[].obs;

  void getFlashCards(BuildContext context, {String loadingFor = '', bool refresh = false}) async {
    try {
      if (refresh == false && flashCardsList.isNotEmpty) return;
      setLoadingF(loadingFor);

      var data = await baseApi.get('/flashcard/', context);
      log('👉 flashCardsList: $data');
      if (data['success'].toString() == 'true') {
        flashCardsList.clear();
        var model = FlashCardsModel.fromJson(data);
        flashCardsList.add(model);
        log('👉🏻 Added flashcards data: ${model.subjects.length} subjects, ${model.movies.length} movies');

        if (selectedSubject.isEmpty && flashCardsList[0].subjects.isNotEmpty) {
          setSelectSubject(flashCardsList[0].subjects[0].id);
          log('👉🏻 Auto-selected first subject: ${flashCardsList[0].subjects[0].id}');
        }
      } else {
        log('👉🏻 getFlashCards failed: $data');
      }
    } catch (e, st) {
      log('💥 try catch when: getFlashCardsF Error: $e, st:$st');
    } finally {
      setLoadingF();
      update();
    }
  }

  void getFlashCardMoviesListBySubjectId(
    BuildContext context, {
    String loadingFor = '',
    String subjectId = "1",
  }) async {
    try {
      setLoadingF(loadingFor);

      var data = await baseApi.get('/flashcard/$subjectId', context);
      log('👉 getFlashCardMoviesListBySubjectId: $data');

      if (data['success'].toString() == 'true') {
        flashCardsList.clear();
        var model = FlashCardsModel.fromJson(data);
        flashCardsList.add(model);
        log('🔥 Updated flashcards for subject $subjectId: ${model.subjects.length} subjects, ${model.movies.length} movies');
      } else {
        log('🔥 Movies API call failed: ${data['success']}');
      }
    } catch (e, st) {
      log(
        '💥 try catch when: getFlashCardMoviesListBySubjectId Error: $e, st:$st',
      );
    } finally {
      setLoadingF();
      update();
    }
  }

  final _selectedLevelIs = "".obs;
  String get selectedLevel => _selectedLevelIs.value;
  void setSelectLevel(String value) {
    _selectedLevelIs.value = value;
  }

  var flashCardsDetailsList = <FlashCardDetaiilModel>[].obs;

  void getFlashCardDetailsByIds(
    BuildContext context, {
    String loadingFor = '',
    String movieId = "1",
    String levelId = "",
  }) async {
    try {
      setSelectLevel(levelId);
      setLoadingF(loadingFor);

      var data = await baseApi.get(
        '/flashcard/view/$movieId/$levelId',
        context,
      );

      if (data['success'].toString() == 'true') {
        flashCardsDetailsList.clear();
        flashCardsDetailsList.add(FlashCardDetaiilModel.fromJson(data));
      }
    } catch (e, st) {
      log('💥 try catch when: getFlashCardDetailsByIds Error: $e, st:$st');
    } finally {
      setLoadingF();
      update();
    }
  }

  var pronounciationList = <GrammerModel>[].obs;

  void getPronounciationF(
    BuildContext context, {
    String loadingFor = '',
  }) async {
    try {
      if (pronounciationList.isNotEmpty) return;
      setLoadingF(loadingFor);
      var data = await baseApi.get('/lessons/pronunciation', context);
      log('👉 pronounciationList: $data');
      if (data['success'].toString() == 'true') {
        pronounciationList.clear();
      }
    } catch (e, st) {
      log('💥 try catch when: getPronounciationF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  final _slectedLableIndexIs = 0.obs;
  int get sletedLableIndexIs => _slectedLableIndexIs.value;
  set setSelctedLableIndexIs(int index) {
    if (index >= 0) {
      _slectedLableIndexIs.value = index;
    }
  }

  final _slectedTabBtnIs = 0.obs;
  int get slectedTabBtnIs => _slectedTabBtnIs.value;
  set setSlectedTabBtnIs(int index) {
    if (index >= 0) {
      _slectedTabBtnIs.value = index;
    }
  }

  var grammerSingleData = <GrammerDetailModel>[].obs;

  void getPronounciationFSingleByIdF(
    BuildContext context, {
    required String id,
    String loadingFor = '',
  }) async {
    try {
      setLoadingF(loadingFor);

      log('👉 grammerSingleData id: $id');
      var data = await baseApi.get('/lessons/pronunciation/travel', context);
      log('👉 grammerSingleData: $data');
      if (data['success'].toString() == 'true') {
        grammerSingleData.clear();
        grammerSingleData.add(GrammerDetailModel.fromJson(data['data']));
      }
    } catch (e, st) {
      log('💥 try catch when: getGrammersSingleByIdF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }
}
