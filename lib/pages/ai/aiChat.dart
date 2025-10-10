import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/pages/home/writings/moviesug.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/header_bar/custom_header_bar.dart';
import '../../providers/aichatvm.dart';
import '../../theme/colors.dart';

class AIMenuPage extends ConsumerStatefulWidget {
  const AIMenuPage({super.key});

  @override
  ConsumerState<AIMenuPage> createState() => _AIMenuPage();
}

class _AIMenuPage extends ConsumerState<AIMenuPage> {
  @override
  void dispose() {
    super.dispose();
    chatsScrollController.dispose();
    msgController.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ref
          .watch(chatWithAiVm)
          .getChatWithAiF(
            context,
            scrollController: chatsScrollController,
            loadingFor: "getAllChats",
          );
    });
    super.initState();
  }

  List<DateTime> messageDates = [];
  TextEditingController msgController = TextEditingController();
  ScrollController chatsScrollController = ScrollController();

  int flashcardsLeft =
      7; // Example number. You can dynamically load this later.

  List menuList = [
    {
      'img': AppImages.movieblue,
      'title': 'Movies Suggestions',
      "query": "Suggested Films",
    },
    {
      'img': AppImages.flashcardsblue,
      'title': 'Track My Progress',
      "query": "Flashcards",
    },
    {
      'img': AppImages.track,
      'title': 'Progress Charts',
      "query": "Track My Progress",
    },
    {
      'img': AppImages.query,
      'title': 'Request Explanation',
      "query": "Requested an Explanation",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(chatWithAiVm);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return DefaultScaffold(
      isShowDrawer: true,

      currentPage: '/home/AIMenuPage',
      floatingBtn: Transform.translate(
        offset: Offset(16, 0),
        child: Container(
          width: w * 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
              colors: ColorsPallet.bdb,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SizedBox(
                width: 400,
                height: 53,
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
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: const Icon(Icons.close_rounded, color: Colors.black),
              title: const Text(
                'Previous Conversations',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 2, color: Colors.grey.shade700),
            ListTile(
              leading: const Icon(Icons.push_pin_outlined, color: Colors.black),
              title: const Text(
                'Pinned Conversations',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 2, color: Colors.grey.shade700),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.black),
              trailing: const Icon(
                Icons.delete_outline_outlined,
                color: Colors.black,
              ),
              title: const Text(
                'Can Your Recommended',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 2, color: Colors.grey.shade700),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.black),
              title: const Text(
                'My Recent Grammar',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 2, color: Colors.grey.shade700),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                ref.watch(chatWithAiVm).clearChatsList();
              },
              label: const Text(
                'New Chat',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          CustomHeaderBar(
            onBack: () async {
              if (context.mounted) {
                context.pop();
              }
            },
            centerTitle: false,
            title: 'Back',
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(color: Colors.blueGrey.shade50),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.78,
            child: Column(
              children: [
                CupertinoListTile(
                  leading: Builder(
                    builder: (context) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(50),
                        child: const Icon(
                          Icons.sort_outlined,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  ),
                  title: Text("pinned"),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.push_pin_outlined,
                      color: Colors.blue,
                    ),
                  ),
                ),
                p.chatAiList.isEmpty
                    ? Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.robo,
                              width: MediaQuery.of(context).size.width * 0.2,
                            ),
                            const Text(
                              'COPILOT',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                const SizedBox(height: 10),
                // Flashcard Button with number (red background)
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 20,
                //     vertical: 8,
                //   ),
                //   decoration: BoxDecoration(
                //     color: Colors.redAccent,
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: Text(
                //     '$flashcardsLeft Flashcards to Watch',
                //     style: const TextStyle(color: Colors.white, fontSize: 16),
                //   ),
                // ),
                // const SizedBox(height: 16),
                p.chatAiList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: GridView.builder(
                          shrinkWrap: true,
                          controller: ScrollController(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                          itemCount: menuList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = menuList[index];
                            return Padding(
                              padding: const EdgeInsets.all(14),
                              child: InkWell(
                                onTap: () {
                                  p.chatWithAiF(context, query: data['query']);
                                  // if (index == 0) {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         const MovieSuggetinosPage(),
                                  //   ),
                                  // );
                                  // }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(data['img'], width: w * 0.15),
                                      const Divider(),
                                      Text(
                                        '${data['title']}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Expanded(
                        // child: Text("bn"),
                        child: ListView.builder(
                          controller: chatsScrollController,
                          itemCount: p.chatAiList.length,
                          itemBuilder: (context, index) {
                            var chat = p.chatAiList[index];
                            return GestureDetector(
                              onTap: () {
                                Get.bottomSheet(
                                  Container(
                                    height: h * 0.5,
                                    decoration: BoxDecoration(
                                      color: ColorsPallet.blue,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.abc_outlined),
                                          SizedBox(height: 12),
                                          Text(
                                            chat.msg,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: BubbleSpecialOne(
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
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
