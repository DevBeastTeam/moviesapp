// FlashCardsListPage

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_helper.dart';
import '../models/grammerDetailModel.dart';
import '../models/grammerModel.dart';

var flashCardsVM =
    ChangeNotifierProvider<FlashCardsVM>((ref) => FlashCardsVM());

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

  //////////////////////////
  var baseApi = ApiHelper();

  List<GrammerModel> pronounciationList = [];
  void getPronounciationF(context,
      {bool isLoading = true,
      bool showLoading = true,
      String loadingFor = ''}) async {
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

  void getPronounciationFSingleByIdF(context,
      {required String id,
      bool showLoading = true,
      String loadingFor = ''}) async {
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
