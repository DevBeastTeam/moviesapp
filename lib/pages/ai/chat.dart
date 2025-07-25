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
      // resizeToAvoidBottomInset: true,
      child: Column(
        children: [
          Expanded(
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
                p.chatAiList.isEmpty
                    ? Expanded(
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
                        child: ListView.builder(
                          controller: chatsScrollController,
                          itemCount: p.chatAiList.length,
                          itemBuilder: (context, index) {
                            var chat = p.chatAiList[index];
                            return BubbleSpecialOne(
                              text: chat.msg,
                              isSender: chat.isSender,
                              color: chat.isSender
                                  ? Colors.blue
                                  : Colors.grey.shade400,
                              textStyle: TextStyle(
                                color: chat.isSender
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              tail: true,
                              sent: true,
                            );
                          },
                        ),
                      ),
                if (p.isLoading)
                  const SizedBox(height: 20, child: Center(child: DotLoader())),
              ],
            ),
          ),

          // Bottom Input Bar with SafeArea
          SafeArea(
            top: false,
            child: Padding(
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
                        await p
                            .chatWithAiF(context, query: msgController.text)
                            .then((value) {
                              msgController.clear();
                              if (chatsScrollController.hasClients) {
                                chatsScrollController.jumpTo(
                                  chatsScrollController
                                      .position
                                      .maxScrollExtent,
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
          ),
        ],
      ),
    );
  }
}
