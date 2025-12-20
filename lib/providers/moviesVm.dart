import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../core/api_helper.dart';
import '../models/excersisesModel.dart';

var moviesVm = ChangeNotifierProvider<MoviesVm>((ref) => MoviesVm());

class MoviesVm extends ChangeNotifier {
  String _loadingFor = "";
  String get loadingFor => _loadingFor;
  void setLoadingF([String name = ""]) {
    _loadingFor = name;
    notifyListeners();
  }

  //////////////////////////
  var baseApi = ApiHelper();

  List<dynamic> movieById = [];
  void getMovieByIdF(
    context, {
    String movieId = '',
    String loadingFor = '',
    bool isRefresh = false,
  }) async {
    try {
      // if (!isRefresh && movieById.isNotEmpty) return;
      setLoadingF(loadingFor);
      // var data = await baseApi.get('/movies/$movieId/similar', context); /// working
      var data = await baseApi.get('/movies/$movieId/subjects', context);
      // var data = await baseApi.get('/movies/$movieId', context);
      // debugPrint('👉 movieById: $data');
      log('👉 movieById: $data');
      if (data['success'].toString() == 'true') {
        movieById.clear();
        movieById.add(ExcersisesModel.fromJson(data['data']));
      }
      setLoadingF();
    } catch (e, st) {
      log('💥 try catch when: getMovieByIdF Error: $e, st:$st');
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
      // if (excercisesCatgLessonsSteps != null) return;
      // setLoadingF(loadingFor);
      // var data = await baseApi.post('/lessons/exercises/$answerId', {
      //   "answers": [answerId],
      // }, context);

      // debugPrint('👉 submitExcercisesAnswerF: $data');
      // if (data['success'].toString() == 'true') {
      //   // relaod lessona
      //   getExcercisesCatgLessonsStepsF(
      //     context,
      //     catgRef: catgRefTemp,
      //     isRefresh: true,
      //   );
      // }
      setLoadingF();
    } catch (e, st) {
      log('💥 try catch when: submitExcercisesAnswerF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }
}
