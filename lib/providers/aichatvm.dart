// FlashCardsListPage

import 'dart:developer';
import 'package:edutainment/models/aichatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_helper.dart';


var chatWithAiVm = ChangeNotifierProvider<ChatWithAiVm>(
  (ref) => ChatWithAiVm(),
);

class ChatWithAiVm extends ChangeNotifier {
  String _loadingFor = "";
  String get loadingFor => _loadingFor;
  void setLoadingF([String name = ""]) {
    _loadingFor = name;
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

  List<AiChatModel> getedchatAiList = [
    // ChatAiModel(msg: '', isSender: false),
  ];

  Future getChatWithAiF(
    context, {
    String loadingFor = '',
    ScrollController? scrollController,
  }) async {
    try {
      setLoadingF(loadingFor);
      var data = await baseApi.get('/chat', context);
      log('👉 ai chat getChatWithAiF : $data');
      // scrollController!.jumpTo(scrollController.position.maxScrollExtent);
      getedchatAiList.add(AiChatModel.fromJson(data));

      setLoadingF();
    } catch (e, st) {
      log('💥 try catch when: getChatWithAiF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  Future chatWithAiF(
    context, {
    String loadingFor = '',
    required String query,
    ScrollController? scrollController,
  }) async {
    try {
      print("query: $query");
      setLoadingF(loadingFor);
      chatAiList.add(ChatAiModel(isSender: true, msg: query.toString()));

      var data = await baseApi.post('/chat/create', {'chat': query}, context);
      debugPrint('👉 chatWithAiF response : $data');
      // scrollController!.jumpTo(scrollController.position.maxScrollExtent);

      setLoadingF();
    } catch (e, st) {
      log('💥 try catch when: chatWithAiF Error: $e, st:$st');
    } finally {
      setLoadingF();
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
    return {'isSender': isSender};
  }
}
