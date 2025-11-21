import 'dart:developer';
import 'package:edutainment/models/pLevelCatgModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/api_helper.dart';
import '../models/grammerDetailModel.dart';

class PronounciationController extends GetxController {
  var baseApi = ApiHelper();

  final _loadingFor = "".obs;
  String get loadingFor => _loadingFor.value;
  void setLoadingF([String name = ""]) {
    _loadingFor.value = name;
  }

  final _expandedIndexIs = 0.obs;
  int get expandedIndexIs => _expandedIndexIs.value;
  set setExpandedIndexIs(int value) {
    _expandedIndexIs.value = value;
  }

  final Rx<PLevelCatgModel?> _pLevelCatgModelData = Rx<PLevelCatgModel?>(null);
  PLevelCatgModel? get pLevelCatgModelData => _pLevelCatgModelData.value;

  void getPronounciationF(
    BuildContext context, {
    bool isLoading = true,
    String loadingFor = '',
    bool isRefresh = false,
  }) async {
    try {
      if (!isRefresh && pLevelCatgModelData != null) return;
      setLoadingF(loadingFor);
      var data = await baseApi.get('/pronunciations', context);
      debugPrint('👉 pronounciationList: $data');
      if (data['success'].toString() == 'true') {
        _pLevelCatgModelData.value = PLevelCatgModel.fromJson(data);
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

  var pronSelectedCatgOptions = <GrammerDetailModel>[].obs;
  bool called = false;

  void getPronBySelectedCatgOptionsByIdF(
    BuildContext context, {
    required String id,
    String loadingFor = '',
    bool isRefresh = false,
  }) async {
    try {
      called = true;
      setLoadingF(loadingFor);
      debugPrint('👉 getPronounciationFSingleByIdF id: $id');
      var data = await baseApi.get('/lessons/pronunciation/$id', context);
      log('👉 getPronounciationFSingleByIdF: $data');
      if (data['success'].toString() == 'true') {
        // Logic from VM was commented out, keeping it consistent or implementing if needed
        // pronSelectedCatgOptions.clear();
        // pronSelectedCatgOptions.add(GrammerDetailModel.fromJson(data['data']));
      }
    } catch (e, st) {
      log('💥 try catch when: getPronounciationFSingleByIdF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  // ========== Navigation State Management ==========

  final _selectedLevel = ''.obs;
  String get selectedLevel => _selectedLevel.value;

  final _allLevels = <String>[].obs;
  List<String> get allLevels => _allLevels;

  final _categories = <Category>[].obs;
  List<Category> get categories => _categories;

  final Rx<Category?> _selectedCategory = Rx<Category?>(null);
  Category? get selectedCategory => _selectedCategory.value;

  final _selectedLesson = <String, dynamic>{}.obs;
  Map<String, dynamic> get selectedLesson => _selectedLesson;

  final _selectedLessonId = ''.obs;
  String get selectedLessonId => _selectedLessonId.value;

  final _selectedLessonIndex = 0.obs;
  int get selectedLessonIndex => _selectedLessonIndex.value;

  void setSelectedLevel({
    required String level,
    required List<String> allLevels,
    required List<Category> categories,
  }) {
    _selectedLevel.value = level;
    _allLevels.assignAll(allLevels);
    _categories.assignAll(categories);
  }

  void setSelectedCategory(Category category) {
    _selectedCategory.value = category;
  }

  void setSelectedLesson({
    required Map<String, dynamic> lesson,
    required String lessonId,
    required int lessonIndex,
  }) {
    _selectedLesson.assignAll(lesson);
    _selectedLessonId.value = lessonId;
    _selectedLessonIndex.value = lessonIndex;
  }

  void resetNavigationState() {
    _selectedLevel.value = '';
    _allLevels.clear();
    _categories.clear();
    _selectedCategory.value = null;
    _selectedLesson.clear();
    _selectedLessonId.value = '';
    _selectedLessonIndex.value = 0;
  }
}
