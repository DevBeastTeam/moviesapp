// FlashCardsListPage

import 'dart:developer';
import 'package:edutainment/models/aichatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_helper.dart';
import '../models/aiallChatHistoryConversionsTitleModel.dart';
// import '../models/AiChatHistoryConversionsTitleModel.dart';

var aiChatVm = ChangeNotifierProvider<AiChatVm>((ref) => AiChatVm());

class AiChatVm extends ChangeNotifier {
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

  AiChatModel? lastAIConversationChats;

  clearChatsList() {
    lastAIConversationChats = null;
    notifyListeners();
  }

  Future createNewChatWithAiF(
    context, {
    String loadingFor = '',
    // required String msg,
    ScrollController? scrollController,
  }) async {
    try {
      // debugPrint("createChatWithAiF msg: $msg");
      setLoadingF(loadingFor);

      var data = await baseApi.post(
        '/chat/create',
        //  {'chat': msg},
        {},
        context,
      );
      debugPrint('👉 createChatWithAiF response : $data');
      lastAIConversationChats = AiChatModel.fromJson(data);
      // scrollController!.jumpTo(scrollController.position.maxScrollExtent);
      setLoadingF();
    } catch (e, st) {
      debugPrint('💥 try catch when: createChatWithAiF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  Future doConversationChatByIdWithAiF(
    context, {
    String loadingFor = '',
    required String msg,
    // required String conversationId,
    ScrollController? scrollController,
  }) async {
    try {
      String conversationId = lastAIConversationChats!.id;
      debugPrint(
        "doConversationChatByIdWithAiF conversationId: $conversationId",
      );
      setLoadingF(loadingFor);
      // body : {
      //       userMessage : string,
      //       botMessage: string,
      //   }

      var data = await baseApi.post('/chat/messages/new/$conversationId', {
        'userMessage': msg,
      }, context);
      debugPrint('👉 doConversationChatByIdWithAiF response : $data');
      getAiChatByIdF(context, chatId: conversationId);
      // scrollController!.jumpTo(scrollController.position.maxScrollExtent);
      setLoadingF();
    } catch (e, st) {
      debugPrint(
        '💥 try catch when: doConversationChatByIdWithAiF Error: $e, st:$st',
      );
    } finally {
      setLoadingF();
    }
  }

  AiChatHistoryConversionsTitleModel? allAiChatHistoryConversionsTitlesData;
  Future getAllAiChatsF(
    context, {
    String loadingFor = '',
    ScrollController? scrollController,
    bool isSetInToLastAlso = false,
  }) async {
    try {
      setLoadingF(loadingFor);
      var data = await baseApi.get('/chat', context);
      log('👉 getAllAiChatsF : $data');
      allAiChatHistoryConversionsTitlesData =
          AiChatHistoryConversionsTitleModel.fromJson(data);
      if (isSetInToLastAlso) {
        if (allAiChatHistoryConversionsTitlesData!.chats.isEmpty) {
          lastAIConversationChats = null;
        } else {
          var data = allAiChatHistoryConversionsTitlesData!.chats.first;
          lastAIConversationChats = AiChatModel(
            id: data.id,
            user: data.user,
            messages: data.messages
                .map((e) => Msgs.fromJson(e.toJson()))
                .toList(),
            title: data.title,
            isPinned: data.isPinned,
            createdAt: data.createdAt,
            updatedAt: data.updatedAt,
            version: data.version,
          );
        }
      }
      setLoadingF();
    } catch (e, st) {
      debugPrint('💥 try catch when: getAllAiChatsF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  /////
  Future getAiChatByIdF(
    context, {
    required String chatId,
    String loadingFor = '',
    ScrollController? scrollController,
  }) async {
    try {
      setLoadingF(loadingFor);
      debugPrint('👉 getAiChatByIdF chatId: $chatId');
      var data = await baseApi.get('/chat/$chatId', context);
      log('👉 getAiChatByIdF : $data');
      lastAIConversationChats = AiChatModel.fromJson(data);
      setLoadingF();
    } catch (e, st) {
      debugPrint('💥 try catch when: getAiChatByIdF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  /////
  Future updateConversationChatsTitleByIdF(
    context, {
    required String conversationId,
    required String newTitle,
    String loadingFor = '',
    ScrollController? scrollController,
  }) async {
    try {
      if (newTitle.isEmpty) return;
      setLoadingF(loadingFor);
      debugPrint(
        '👉 updateConversationChatsTitleByIdF conversationId: $conversationId',
      );
      var data = await baseApi.post('/chat/$conversationId/title', {
        "title": newTitle,
      }, context);
      debugPrint('👉 updateConversationChatsTitleByIdF : $data');
      EasyLoading.showSuccess("Success!");
      getAllAiChatsF(context, loadingFor: "refresh");
      setLoadingF();
    } catch (e, st) {
      debugPrint(
        '💥 try catch when: updateConversationChatsTitleByIdF Error: $e, st:$st',
      );
    } finally {
      setLoadingF();
    }
  }

  /////
  Future toggleConversationChatsPinByIdF(
    context, {
    required String conversationId,
    String loadingFor = '',
    ScrollController? scrollController,
  }) async {
    try {
      setLoadingF(loadingFor);
      debugPrint(
        '👉 toggleConversationChatsPinByIdF conversationId: $conversationId',
      );
      var data = await baseApi.post(
        '/chat/toggle-pin/$conversationId',
        {},
        context,
      );
      debugPrint('👉 toggleConversationChatsPinByIdF : $data');
      EasyLoading.showSuccess("Success!");
      getAllAiChatsF(context, loadingFor: "refresh");
      setLoadingF();
    } catch (e, st) {
      debugPrint(
        '💥 try catch when: toggleConversationChatsPinByIdF Error: $e, st:$st',
      );
    } finally {
      setLoadingF();
    }
  }

  /////
  Future deleteConversationChatsByIdF(
    context, {
    required String conversationId,
    String loadingFor = '',
    ScrollController? scrollController,
  }) async {
    try {
      setLoadingF(loadingFor);
      debugPrint(
        '👉 deleteConversationChatsByIdF conversationId: $conversationId',
      );
      var data = await baseApi.delete('/chat/delete/$conversationId', context);
      debugPrint('👉 deleteConversationChatsByIdF : $data');
      EasyLoading.showSuccess("Deleted!");
      getAllAiChatsF(context, loadingFor: "refresh");
      setLoadingF();
    } catch (e, st) {
      debugPrint(
        '💥 try catch when: deleteConversationChatsByIdF Error: $e, st:$st',
      );
    } finally {
      setLoadingF();
    }
  }
}
