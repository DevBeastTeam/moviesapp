import 'dart:developer';
import 'package:edutainment/models/pLevelCatgModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_helper.dart';
import '../models/grammerDetailModel.dart';
import '../models/grammerModel.dart';

var pronounciationVm = ChangeNotifierProvider<PronounciationVm>(
  (ref) => PronounciationVm(),
);

class PronounciationVm extends ChangeNotifier {
  String isLoadingFor = '';

  String _loadingFor = "";
  String get loadingFor => _loadingFor;
  void setLoadingF([String name = ""]) {
    _loadingFor = name;
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

  // List<GrammerModel> pronounciationList = [];
  PLevelCatgModel? pLevelCatgModelData;
  void getPronounciationF(
    context, {
    bool isLoading = true,
    String loadingFor = '',
    bool isRefresh = false,
  }) async {
    try {
      if (!isRefresh && pLevelCatgModelData != null) return;
      setLoadingF(loadingFor);
      var data = await baseApi.get('/lessons/pronunciation', context);
      debugPrint('👉 pronounciationList: $data');
      // log('👉 pronounciationList: $data');
      if (data['success'].toString() == 'true') {
        pLevelCatgModelData = PLevelCatgModel.fromJson(data);
        // pronounciationList.clear();
        // pronounciationList.add(GrammerModel.fromJson(data['data']));
      }
      setLoadingF();
    } catch (e, st) {
      log('💥 try catch when: getPronounciationF Error: $e, st:$st');
    } finally {
      setLoadingF();
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

  List<GrammerDetailModel> pronSelectedCatgOptions = [];

  bool called = false;
  void getPronBySelectedCatgOptionsByIdF(
    context, {
    required String id,
    String loadingFor = '',
    bool isRefresh = false,
  }) async {
    try {
      // if (!isRefresh && pronSelectedCatgOptions != null) return;
      // if(called) return;
      called = true;
      setLoadingF(loadingFor);
      debugPrint('👉 getPronounciationFSingleByIdF id: $id');
      var data = await baseApi.get('/lessons/pronunciation/$id', context);
      log('👉 getPronounciationFSingleByIdF: $data');
      if (data['success'].toString() == 'true') {
        // pronSelectedCatgOptions.clear();
        // pronSelectedCatgOptions.add(GrammerDetailModel.fromJson(data['data']));
      }
      setLoadingF();
    } catch (e, st) {
      log('💥 try catch when: getPronounciationFSingleByIdF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }
}
