import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/api_helper.dart';
import '../models/excersisesModel.dart';

class MoviesController extends GetxController {
  var baseApi = ApiHelper();

  final _loadingFor = "".obs;
  String get loadingFor => _loadingFor.value;
  void setLoadingF([String name = ""]) {
    _loadingFor.value = name;
  }

  var movieById = <dynamic>[].obs;

  void getMovieByIdF(
    BuildContext context, {
    String movieId = '',
    String loadingFor = '',
    bool isRefresh = false,
  }) async {
    try {
      setLoadingF(loadingFor);
      var data = await baseApi.get('/movies/$movieId/subjects', context);
      log('👉 movieById: $data');
      if (data['success'].toString() == 'true') {
        movieById.clear();
        movieById.add(ExcersisesModel.fromJson(data['data']));
      }
    } catch (e, st) {
      log('💥 try catch when: getMovieByIdF Error: $e, st:$st');
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
      setLoadingF();
    } catch (e, st) {
      log('💥 try catch when: submitExcercisesAnswerF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }
}
