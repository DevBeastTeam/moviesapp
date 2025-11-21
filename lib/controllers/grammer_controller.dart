import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/api_helper.dart';
import '../models/grammerDetailModel.dart';
import '../models/grammerModel.dart';

class GrammerController extends GetxController {
  var baseApi = ApiHelper();

  var grammerSingleData = <GrammerDetailModel>[].obs;
  var grammersList = <GrammerModel>[].obs;

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

  final _selctedLableChIs = "a1".obs;
  String get selctedLableChIs => _selctedLableChIs.value;
  void setSelectedLabelCH(v) {
    _selctedLableChIs.value = v;
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

  void getGrammersF(BuildContext context, {String loadingFor = ''}) async {
    try {
      if (grammersList.isNotEmpty) return;
      setLoadingF(loadingFor);

      var data = await baseApi.get('/lessons/grammar', context);
      log('👉 grammersList: $data');
      if (data['success'].toString() == 'true') {
        grammersList.clear();
        grammersList.add(GrammerModel.fromJson(data['data']));
      }
    } catch (e, st) {
      log('💥 try catch when: getGrammersF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  void getGrammerSingleByIdF(
    BuildContext context, {
    required String id,
    String loadingFor = '',
  }) async {
    try {
      setLoadingF(loadingFor);

      log('👉 getGrammerSingleByIdF id: $id');
      var data = await baseApi.get('/lessons/grammar/$id', context);

      log('👉 getGrammerSingleByIdF data: $data');

      if (data['success'].toString() == 'true') {
        grammerSingleData.clear();
        grammerSingleData.add(GrammerDetailModel.fromJson(data['data']));
      }
    } catch (e, st) {
      log('💥 try catch when: getGrammerSingleByIdF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  // Timer Logic
  Timer? _timer;
  final _remainingSeconds = 10.obs;
  int get remainingSeconds => _remainingSeconds.value;

  final _isTimerStart = false.obs;
  bool get isTimerStart => _isTimerStart.value;

  String lessonReadedId = "";

  void stopTimer() {
    _timer?.cancel();
    _isTimerStart.value = false;
    _remainingSeconds.value = 10;
  }

  void playTimer(
    BuildContext context, {
    String lessonReadingId = "",
    List lessonsForLoop = const [],
  }) {
    if (isTimerStart) return;

    _isTimerStart.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 1) {
        _remainingSeconds.value = 10;
        lessonReadedId = lessonReadingId;
        stopTimer();
      } else {
        _remainingSeconds.value--;
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
