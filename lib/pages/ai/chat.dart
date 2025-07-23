import 'package:chat_bubbles/chat_bubbles.dart';

import 'package:edutainment/providers/aichatvm.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/header_bar/custom_header_bar.dart';
import '../../widgets/loaders/dotloader.dart';

class ChatAiPage extends ConsumerStatefulWidget {
  const ChatAiPage({super.key});

  @override
  ConsumerState<ChatAiPage> createState() => ChatAiPageState();
}

class ChatAiPageState extends ConsumerState<ChatAiPage> {
  @override
  void dispose() {
    super.dispose();
    chatsScrollController.dispose();
    msgController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  List<DateTime> messageDates = [];
  TextEditingController msgController = TextEditingController();
  ScrollController chatsScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(chatWithAiVm);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return DefaultScaffold(
      currentPage: '/home/ai/aichat',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: Column(
              children: [
                CustomHeaderBar(
                  onBack: () async {
                    if (context.mounted) {
                      context.pop();
                    }
                  },
                  centerTitle: false,
                  title: 'Chat With Ai'.toUpperCase(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          p.chatAiList.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: h * 0.35),
                  child: Center(
                    child: Text(
                      'Empty',
                      style: t.titleMedium!.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  flex: 1,
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller:
                        chatsScrollController, // Attach the controller here
                    itemCount: p.chatAiList.length,
                    itemBuilder: (context, index) {
                      var chat = p.chatAiList[index];
                      if (chat.isSender) {
                        return BubbleSpecialOne(
                          text: chat.msg,
                          isSender: true,
                          color: Colors.blue,
                          textStyle: const TextStyle(color: Colors.white),
                          tail: true,
                          sent: true,
                        );
                      } else {
                        return BubbleSpecialOne(
                          text: chat.msg,
                          isSender: false,
                          color: Colors.grey.shade400,
                          textStyle: const TextStyle(color: Colors.black),
                          tail: true,
                          sent: true,
                        );
                      }
                    },
                  ),
                ),
          p.isLoading
              ? const SizedBox(height: 20, child: Center(child: DotLoader()))
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: msgController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                fillColor: Colors.blueGrey.shade900,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: IconButton(
                  onPressed: () async {
                    if (msgController.text.isEmpty) {
                      await EasyLoading.showInfo('Write Something');
                    } else {
                      await p.chatWithAiF(context, query: msgController.text).then((
                        value,
                      ) {
                        msgController.clear();

                        // Check if the ScrollController is attached
                        if (chatsScrollController.hasClients) {
                          chatsScrollController.jumpTo(
                            chatsScrollController.position.maxScrollExtent,
                          );
                        } else {
                          debugPrint(
                            'ScrollController not attached to any scroll view.',
                          );
                        }
                      });
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
                border: InputBorder.none,
                hintText: 'Type Here',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
