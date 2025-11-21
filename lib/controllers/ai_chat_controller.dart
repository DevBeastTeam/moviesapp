import 'dart:developer';
import 'package:edutainment/models/aichatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../core/api_helper.dart';
import '../models/aiallChatHistoryConversionsTitleModel.dart';

class AiChatController extends GetxController {
  var baseApi = ApiHelper();

  final _loadingFor = "".obs;
  String get loadingFor => _loadingFor.value;
  void setLoadingF([String name = ""]) {
    _loadingFor.value = name;
  }

  final Rx<AiChatModel?> _lastAIConversationChats = Rx<AiChatModel?>(null);
  AiChatModel? get lastAIConversationChats => _lastAIConversationChats.value;

  void clearChatsList() {
    _lastAIConversationChats.value = null;
  }

  Future createNewChatWithAiF(
    BuildContext context, {
    String loadingFor = '',
    ScrollController? scrollController,
  }) async {
    try {
      setLoadingF(loadingFor);

      var data = await baseApi.post('/chat/create', {}, context);
      debugPrint('👉 createChatWithAiF response : $data');
      _lastAIConversationChats.value = AiChatModel.fromJson(data);
    } catch (e, st) {
      debugPrint('💥 try catch when: createChatWithAiF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  Future doConversationChatByIdWithAiF(
    BuildContext context, {
    String loadingFor = '',
    required String msg,
    ScrollController? scrollController,
  }) async {
    try {
      if (lastAIConversationChats == null) return;
      String conversationId = lastAIConversationChats!.id;
      debugPrint(
        "doConversationChatByIdWithAiF conversationId: $conversationId",
      );
      setLoadingF(loadingFor);

      var data = await baseApi.post('/chat/messages/new/$conversationId', {
        'userMessage': msg,
      }, context);
      debugPrint('👉 doConversationChatByIdWithAiF response : $data');
      getAiChatByIdF(context, chatId: conversationId);
    } catch (e, st) {
      debugPrint(
        '💥 try catch when: doConversationChatByIdWithAiF Error: $e, st:$st',
      );
    } finally {
      setLoadingF();
    }
  }

  final Rx<AiChatHistoryConversionsTitleModel?>
  _allAiChatHistoryConversionsTitlesData =
      Rx<AiChatHistoryConversionsTitleModel?>(null);
  AiChatHistoryConversionsTitleModel?
  get allAiChatHistoryConversionsTitlesData =>
      _allAiChatHistoryConversionsTitlesData.value;

  Future getAllAiChatsF(
    BuildContext context, {
    String loadingFor = '',
    ScrollController? scrollController,
    bool isSetInToLastAlso = false,
  }) async {
    try {
      setLoadingF(loadingFor);
      var data = await baseApi.get('/chat', context);
      log('👉 getAllAiChatsF : $data');
      _allAiChatHistoryConversionsTitlesData.value =
          AiChatHistoryConversionsTitleModel.fromJson(data);
      if (isSetInToLastAlso) {
        if (_allAiChatHistoryConversionsTitlesData.value!.chats.isEmpty) {
          _lastAIConversationChats.value = null;
        } else {
          var data = _allAiChatHistoryConversionsTitlesData.value!.chats.first;
          _lastAIConversationChats.value = AiChatModel(
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
    } catch (e, st) {
      debugPrint('💥 try catch when: getAllAiChatsF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  Future getAiChatByIdF(
    BuildContext context, {
    required String chatId,
    String loadingFor = '',
    ScrollController? scrollController,
  }) async {
    try {
      setLoadingF(loadingFor);
      debugPrint('👉 getAiChatByIdF chatId: $chatId');
      var data = await baseApi.get('/chat/$chatId', context);
      log('👉 getAiChatByIdF : $data');
      _lastAIConversationChats.value = AiChatModel.fromJson(data);
    } catch (e, st) {
      debugPrint('💥 try catch when: getAiChatByIdF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }

  Future updateConversationChatsTitleByIdF(
    BuildContext context, {
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
    } catch (e, st) {
      debugPrint(
        '💥 try catch when: updateConversationChatsTitleByIdF Error: $e, st:$st',
      );
    } finally {
      setLoadingF();
    }
  }

  Future toggleConversationChatsPinByIdF(
    BuildContext context, {
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
    } catch (e, st) {
      debugPrint(
        '💥 try catch when: toggleConversationChatsPinByIdF Error: $e, st:$st',
      );
    } finally {
      setLoadingF();
    }
  }

  Future deleteConversationChatsByIdF(
    BuildContext context, {
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
    } catch (e, st) {
      debugPrint(
        '💥 try catch when: deleteConversationChatsByIdF Error: $e, st:$st',
      );
    } finally {
      setLoadingF();
    }
  }
}
