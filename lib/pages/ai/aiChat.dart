import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/constants/screenssize.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../controllers/ai_chat_controller.dart';

import 'package:quick_widgets/widgets/tiktok.dart';
import '../../controllers/navigation_args_controller.dart';

import '../../../widgets/header_bar/custom_header_bar.dart';

import '../../theme/colors.dart';
import 'package:edutainment/widgets/card_3d.dart';
import 'aIAllChatHistoryPage.dart';

class AIMenuPage extends StatefulWidget {
  const AIMenuPage({super.key});

  @override
  State<AIMenuPage> createState() => _AIMenuPage();
}

class _AIMenuPage extends State<AIMenuPage> {
  @override
  void dispose() {
    super.dispose();
    chatsScrollController.dispose();
    msgController.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) async {
      final aiChatCtrl = Get.find<AiChatController>();
      if (aiChatCtrl.lastAIConversationChats == null) {
        await aiChatCtrl
            .getAllAiChatsF(
              context,
              scrollController: chatsScrollController,
              loadingFor: "getAllChats",
              isSetInToLastAlso: true,
            )
            .then((v) {
              aiChatCtrl.getAiChatByIdF(
                context,
                chatId: aiChatCtrl.lastAIConversationChats!.id,
                scrollController: chatsScrollController,
                loadingFor: "getAiChatByIdF",
              );
            });
      }
    });
    super.initState();
  }

  TextEditingController msgController = TextEditingController();
  ScrollController chatsScrollController = ScrollController();

  int flashcardsLeft =
      7; // Example number. You can dynamically load this later.

  bool showRecommendedChat = true; // Track visibility of recommended chat

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
    final p = Get.find<AiChatController>();
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return DefaultScaffold(
      isShowDrawer: true,

      currentPage: '/home/AIMenuPage',
      floatingBtn: Transform.translate(
        offset: Offset(16, -15),
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SizedBox(
                width: 400,
                height: 53,
                child: TextField(
                  controller: msgController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    // fillColor: Colors.blueGrey.shade900,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        if (msgController.text.isEmpty) {
                          await EasyLoading.showInfo('Write Something');
                        } else {
                          await p
                              .doConversationChatByIdWithAiF(
                                context,
                                msg: msgController.text,
                              )
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
        // backgroundColor: ColorsPallet.darkBlue,
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            ListTile(
              leading: const Icon(Icons.close_rounded, color: Colors.black),
              title: const Text(
                'Previous Conversations',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                final navCtrl = Get.find<NavigationArgsController>();
                navCtrl.aiChatIsPinnedOnly = false;
                Get.to(() => const AllAIChatHistoryPage(isPinnedOnly: false));
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
                final navCtrl = Get.find<NavigationArgsController>();
                navCtrl.aiChatIsPinnedOnly = true;
                Get.to(() => const AllAIChatHistoryPage(isPinnedOnly: true));
              },
            ),
            Divider(height: 2, color: Colors.grey.shade700),
            if (showRecommendedChat)
              ListTile(
                // leading: const Icon(Icons.chat, color: Colors.black),
                title: const Text(
                  'Can Your Recommended',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  p.doConversationChatByIdWithAiF(
                    context,
                    msg: "Can Your Recommended",
                  );
                  Navigator.pop(context);
                },
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      showRecommendedChat = false;
                    });
                  },
                ),
              ),
            if (showRecommendedChat)
              Divider(height: 2, color: Colors.grey.shade700),
            SizedBox(height: 30),
            CupertinoListTile(
              // padding: EdgeInsets.only(left: 20, bottom: 0),
              title: Text(
                "Last 7 days",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade700),
            ListTile(
              // contentPadding: EdgeInsets.only(left: 20, top: 0),

              // leading: const Icon(Icons.chat, color: Colors.black),
              title: const Text(
                'My Recent Grammar',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const AllAIChatHistoryPage(isPinnedOnly: false));
              },
            ),
            Divider(height: 2, color: Colors.grey.shade700),
            const Spacer(),
            // ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(40),
            //     ),
            //   ),
            //   icon: const Icon(Icons.edit, color: Colors.white),
            //   onPressed: () {
            //     Navigator.pop(context);
            //     p.clearChatsList();
            //     p.createNewChatWithAiF(context);
            //   },
            //   label: const Text(
            //     'New Chat',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            // gredient button with icon, text
            InkWell(
              onTap: () {
                Navigator.pop(context);
                p.clearChatsList();
                p.createNewChatWithAiF(context);
              },
              borderRadius: BorderRadius.circular(40),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blue.shade700],
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                    BoxShadow(
                      color: Colors.blue.shade700,
                      blurRadius: 1,
                      offset: const Offset(-2, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.edit, color: Colors.white),
                    const Text(
                      '    New Chat',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      child: Column(
        children: [
          CustomHeaderBar(
            onBack: () async {
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            centerTitle: false,
            title: 'Back',
          ),

          Obx(
            () => p.loadingFor == "refresh" || p.loadingFor == "getAiChatByIdF"
                ? QuickTikTokLoader()
                : SizedBox.shrink(),
          ),

          Container(
            decoration: BoxDecoration(color: Colors.blueGrey.shade50),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.78,
            child: SingleChildScrollView(
              controller: chatsScrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            child: Builder(
                              builder: (context) {
                                return InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Icon(
                                      Icons.sort_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                );
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final isPinnedOnly = p
                                  .allAiChatHistoryConversionsTitlesData!
                                  .chats
                                  .any((element) => element.isPinned == true);
                              Get.to(
                                () => AllAIChatHistoryPage(
                                  isPinnedOnly: isPinnedOnly,
                                ),
                              );
                            },
                            child: Obx(
                              () =>
                                  (p.allAiChatHistoryConversionsTitlesData !=
                                      null)
                                  ? p.allAiChatHistoryConversionsTitlesData!.chats
                                            .any(
                                              (element) =>
                                                  element.isPinned == true,
                                            )
                                        ? Text(
                                            p
                                                .allAiChatHistoryConversionsTitlesData!
                                                .chats
                                                .firstWhere(
                                                  (element) =>
                                                      element.isPinned == true,
                                                )
                                                .title,
                                          )
                                        : Text(
                                            "Pinned",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          )
                                  : Text(
                                      "Pinned",
                                      style: TextStyle(color: Colors.black),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(
                            () =>
                                const AllAIChatHistoryPage(isPinnedOnly: true),
                          );
                        },
                        icon: const Icon(
                          Icons.push_pin_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Screen.isLandscape(context) && Screen.isPhone(context)
                      ? SizedBox.shrink()
                      : Obx(
                          () =>
                              p.lastAIConversationChats == null ||
                                  p.lastAIConversationChats!.messages.isEmpty
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppImages.robo,
                                        width: (h < w)
                                            ? w * 0.05
                                            : w > 450
                                            ? w * 0.1
                                            : w * 0.2,
                                      ),
                                      Text(
                                        ' COPILOT',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600,
                                          fontSize: (h < w) ? 20 : 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                  SizedBox(height: 5),
                  // GradientText(
                  //   // text: "${ref.watch(userProvider)['name.given_name']}",
                  //   text:
                  //       'Hello ${getIn(ref.watch(userProvider), 'name.given_name', '')}',
                  //   // text: 'Hello Name',
                  //   colors: [
                  //     Color(0xFF60A5FA), // HexColor("#60A5FA")
                  //     Color(0xFFA855F7), // HexColor("#A855F7")
                  //     Color(0xFFF87171), // HexColor("#F87171")
                  //   ],
                  //   fontSize: 25,
                  //   fontWeight: FontWeight.bold,
                  // ),
                  // Text("kkkk"),
                  Obx(() {
                    if ((p.lastAIConversationChats == null ||
                            p.lastAIConversationChats!.messages.isEmpty) &&
                        w > 450 &&
                        !(h < w)) {
                      return SizedBox(height: h * 0.2);
                    } else if ((p.lastAIConversationChats == null ||
                            p.lastAIConversationChats!.messages.isEmpty) &&
                        w > 450 &&
                        (h < w))
                      return SizedBox(height: 0);
                    else
                      return SizedBox(height: h * 0.02);
                  }),
                  ((p.lastAIConversationChats == null ||
                              p.lastAIConversationChats!.messages.isEmpty) &&
                          Screen.isPhone(context) &&
                          Screen.isPortrait(context))
                      ? SizedBox(height: Screen.height(context) * 0.07)
                      : ((p.lastAIConversationChats == null ||
                                p.lastAIConversationChats!.messages.isEmpty) &&
                            Screen.isPhone(context) &&
                            Screen.isLandscape(context))
                      ? SizedBox(height: Screen.height(context) * 0)
                      : ((p.lastAIConversationChats == null ||
                                p.lastAIConversationChats!.messages.isEmpty) &&
                            Screen.isTablet(context) &&
                            Screen.isPortrait(context))
                      ? SizedBox(height: Screen.height(context) * 0.07)
                      : ((p.lastAIConversationChats == null ||
                                p.lastAIConversationChats!.messages.isEmpty) &&
                            Screen.isTablet(context) &&
                            Screen.isLandscape(context))
                      ? SizedBox(height: Screen.height(context) * 0.25)
                      : SizedBox(height: 0),

                  // Text("Hello Name"),
                  // GradientText(
                  //   'Hello Name',
                  //   gradient: LinearGradient(colors: [
                  //     HexColor("#60A5FA"),
                  //     HexColor("#A855F7"),
                  //     HexColor("#F87171"),
                  //   ]),
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  Obx(
                    () =>
                        p.lastAIConversationChats == null ||
                            p.lastAIConversationChats!.messages.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: GridView.builder(
                              shrinkWrap: true,
                              controller: ScrollController(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: w > 450 ? 4 : 2,
                                  ),
                              itemCount: menuList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var data = menuList[index];
                                return Padding(
                                  padding: EdgeInsets.all(w > 450 ? 20 : 14),
                                  child: InkWell(
                                    onTap: () {
                                      p.doConversationChatByIdWithAiF(
                                        context,
                                        msg: data['query'],
                                      );
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            data['img'],
                                            width: w > 450
                                                ? w * 0.08
                                                : w * 0.15,
                                          ),
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
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                p.lastAIConversationChats!.messages.length,
                            itemBuilder: (context, index) {
                              var chat =
                                  p.lastAIConversationChats!.messages[index];
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
                                              chat.content,
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
                                // child: BubbleSpecialOne(
                                //   text: chat.content,
                                //   isSender: chat.type != "user",
                                //   color: chat.type == "user"
                                //       ? Colors.blue
                                //       : Colors.grey.shade400,
                                //   textStyle: TextStyle(
                                //     color: chat.type == "user"
                                //         ? Colors.white
                                //         : Colors.black,
                                //   ),
                                //   tail: true,
                                //   sent: chat.type == "user" ? true : false,
                                // ),
                                child: Align(
                                  alignment: chat.type == "user"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          w * 0.8, // Max width 80% of screen
                                    ),
                                    child: Card3D(
                                      shadowOpacity: 0.1,
                                      shadowBlur: 10,
                                      shadowColor: Colors.blue.shade100,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      borderRadius: 7,
                                      // User = Blue, AI = White
                                      backgroundColor: chat.type == "user"
                                          // ? const Color(0xFF2196F3)
                                          ? Colors.blue
                                          : Colors.white,
                                      // Adjust shadow/highlight colors if needed for white/blue contrast
                                      // enhanced 3D effect parameters can be tweaked here
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              chat.type == "user"
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            // Optional: Show name if needed, similar to image "User's first name"
                                            // For now just the content as per previous code
                                            Text(
                                              chat.content,
                                              style: TextStyle(
                                                color: chat.type == "user"
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
