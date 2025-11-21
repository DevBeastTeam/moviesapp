import 'dart:developer';
import 'package:edutainment/models/pLevelCatgModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/api_helper.dart';
import '../models/grammerDetailModel.dart';

class PronunciationController extends GetxController {
  final baseApi = ApiHelper();

  // Loading state
  String loadingFor = '';

  // Expanded index
  int expandedIndexIs = 0;

  // Pronunciation data
  PLevelCatgModel? pLevelCatgModelData;

  // Selected indices
  int selectedLabelIndex = 0;
  int selectedTabBtn = 0;

  // Selected category options
  List<GrammerDetailModel> pronSelectedCatgOptions = [];
  bool called = false;

  // Navigation state
  String selectedLevel = '';
  List<String> allLevels = [];
  List<Category> categories = [];
  Category? selectedCategory;
  Map<String, dynamic> selectedLesson = {};
  String selectedLessonId = '';
  int selectedLessonIndex = 0;

  // Methods
  void setLoadingFor([String name = '']) {
    loadingFor = name;
    update();
  }

  void setExpandedIndex(int value) {
    expandedIndexIs = value;
    update();
  }

  void setSelectedLabelIndex(int index) {
    if (index >= 0) {
      selectedLabelIndex = index;
      update();
    }
  }

  void setSelectedTabBtn(int index) {
    if (index >= 0) {
      selectedTabBtn = index;
      update();
    }
  }

  Future<void> getPronunciations(
    BuildContext context, {
    bool isLoading = true,
    String loadingFor = '',
    bool isRefresh = false,
  }) async {
    try {
      if (!isRefresh && pLevelCatgModelData != null) return;
      setLoadingFor(loadingFor);
      var data = await baseApi.get('/pronunciations', context);
      debugPrint('👉 pronunciationList: $data');
      if (data['success'].toString() == 'true') {
        pLevelCatgModelData = PLevelCatgModel.fromJson(data);
      }
      setLoadingFor();
    } catch (e, st) {
      log('💥 try catch when: getPronunciations Error: $e, st:$st');
    } finally {
      setLoadingFor();
      update();
    }
  }

  Future<void> getPronBySelectedCatgOptionsById(
    BuildContext context, {
    required String id,
    String loadingFor = '',
    bool isRefresh = false,
  }) async {
    try {
      called = true;
      setLoadingFor(loadingFor);
      debugPrint('👉 getPronBySelectedCatgOptionsById id: $id');
      var data = await baseApi.get('/lessons/pronunciation/$id', context);
      log('👉 getPronBySelectedCatgOptionsById: $data');
      if (data['success'].toString() == 'true') {
        // pronSelectedCatgOptions handling here
      }
      setLoadingFor();
    } catch (e, st) {
      log(
        '💥 try catch when: getPronBySelectedCatgOptionsById Error: $e, st:$st',
      );
    } finally {
      setLoadingFor();
    }
  }

  // Navigation state methods
  void setSelectedLevel({
    required String level,
    required List<String> allLevels,
    required List<Category> categories,
  }) {
    selectedLevel = level;
    this.allLevels = allLevels;
    this.categories = categories;
    update();
  }

  void setSelectedCategory(Category category) {
    selectedCategory = category;
    update();
  }

  void setSelectedLesson({
    required Map<String, dynamic> lesson,
    required String lessonId,
    required int lessonIndex,
  }) {
    selectedLesson = lesson;
    selectedLessonId = lessonId;
    selectedLessonIndex = lessonIndex;
    update();
  }

  void resetNavigationState() {
    selectedLevel = '';
    allLevels = [];
    categories = [];
    selectedCategory = null;
    selectedLesson = {};
    selectedLessonId = '';
    selectedLessonIndex = 0;
    update();
  }
}
