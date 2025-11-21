import 'dart:developer';
import 'package:edutainment/models/excLessonsStepsModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/api_helper.dart';
import '../models/excersisesModel.dart';

class ExercisesController extends GetxController {
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

  var excersiseList = <ExcersisesModel>[].obs;

  void getExcerF(
    BuildContext context, {
    bool isLoading = true,
    bool showLoading = true,
    String loadingFor = '',
    bool isRefresh = false,
  }) async {
    try {
      if (!isRefresh && excersiseList.isNotEmpty) return;
      setLoadingF(loadingFor);
      var data = await baseApi.get('/lessons/exercises', context);
      log('👉 getExcerF excersiseList: $data');
      if (data['success'].toString() == 'true') {
        excersiseList.clear();
        excersiseList.add(ExcersisesModel.fromJson(data['data']));
      }
    } catch (e, st) {
      log('💥 try catch when: getExcerF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  final Rx<ExerciseLessonsStepModel?> _excercisesCatgLessonsSteps =
      Rx<ExerciseLessonsStepModel?>(null);
  ExerciseLessonsStepModel? get excercisesCatgLessonsSteps =>
      _excercisesCatgLessonsSteps.value;

  String catgRefTemp = "";

  void getExcercisesCatgLessonsStepsF(
    BuildContext context, {
    String loadingFor = '',
    String catgRef = '',
    bool isRefresh = false,
  }) async {
    try {
      setLoadingF(loadingFor);
      catgRefTemp = catgRef;

      var data = await baseApi.get(
        '/lessons/exercises/category/$catgRef',
        context,
      );

      debugPrint('👉 getExcercisesCatgLessonsStepsF: $data');
      if (data['success'].toString() == 'true') {
        if (data['data'] != null) {
          _excercisesCatgLessonsSteps.value = ExerciseLessonsStepModel.fromJson(
            data,
          );
        }
      }
    } catch (e, st) {
      log('💥 try catch when: getExcerByCatgRef Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  void submitExcercisesAnswerF(
    BuildContext context, {
    String loadingFor = '',
    String answerId = '',
  }) async {
    try {
      if (excercisesCatgLessonsSteps != null) {
        return; // Logic copied from VM, might need review
      }
      setLoadingF(loadingFor);
      var data = await baseApi.post('/lessons/exercises/$answerId', {
        "answers": [answerId],
      }, context);

      debugPrint('👉 submitExcercisesAnswerF: $data');
      if (data['success'].toString() == 'true') {
        getExcercisesCatgLessonsStepsF(
          context,
          catgRef: catgRefTemp,
          isRefresh: true,
        );
      }
    } catch (e, st) {
      log('💥 try catch when: submitExcercisesAnswerF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }
}
