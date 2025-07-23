// FlashCardsListPage

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_helper.dart';
import 'package:http/http.dart' as http;

import '../utils/boxes.dart';

var chatWithAiVm =
    ChangeNotifierProvider<ChatWithAiVm>((ref) => ChatWithAiVm());

class ChatWithAiVm extends ChangeNotifier {
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

  // int _expandedIndexIs = 0;
  // int get expandedIndexIs => _expandedIndexIs;
  // set setExpandedIndexIs(int value) {
  //   _expandedIndexIs = value;
  //   notifyListeners();
  // }

  //////////////////////////
  var baseApi = ApiHelper();

  List<ChatAiModel> chatAiList = [
    // ChatAiModel(msg: '', isSender: false),
  ];
  Future chatWithAiF(context,
      {bool isLoading = true,
      bool showLoading = true,
      String loadingFor = '',
      required String query,
      ScrollController? scrollController}) async {
    try {
      if (showLoading) {
        setLoadingF(true, loadingFor);
      }
      chatAiList.add(ChatAiModel(isSender: true, msg: query.toString()));
      var token = await userBox.get('token');
      var resp = await http.post(
          Uri.parse('https://pronounciation.e-dutainment.com/answer'),
          headers: {
            HttpHeaders.authorizationHeader: 'JWT $token',
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: jsonEncode({'message': query}));

      // debugPrint('👉 ai chat response : ${resp.body}');

      // var respD = jsonDecode(resp.body);
      // if (resp.statusCode == 200 || resp.statusCode == 201) {
      chatAiList.add(ChatAiModel(isSender: false, msg: resp.body.toString()));
      // }

      setLoadingF(false);
      // scrollController!.jumpTo(scrollController.position.maxScrollExtent);

      notifyListeners();
    } catch (e, st) {
      log('💥 try catch when: chatWithAiF Error: $e, st:$st');
    } finally {
      setLoadingF(false);
      notifyListeners();
    }
  }
}

class ChatAiModel {
  final bool isSender;
  final String msg;

  ChatAiModel({required this.isSender, required this.msg});

  factory ChatAiModel.fromJson(Map<String, dynamic> json) {
    return ChatAiModel(isSender: json['isSender'], msg: json['msg']);
  }

  Map<String, dynamic> toJson() {
    return {
      'isSender': isSender,
    };
  }
}
