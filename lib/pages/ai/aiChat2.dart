// import 'package:chat_bubbles/chat_bubbles.dart';
// import 'package:edutainment/constants/appimages.dart';
// import 'package:edutainment/widgets/ui/default_scaffold.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:get/get.dart';
// import 'package:quick_widgets/widgets/tiktok.dart';

// import '../../../widgets/header_bar/custom_header_bar.dart';
// import '../../providers/aichatvm.dart';
// import '../../theme/colors.dart';

// class AIMenuPage extends ConsumerStatefulWidget {
//   const AIMenuPage({super.key});

//   @override
//   ConsumerState<AIMenuPage> createState() => _AIMenuPage();
// }

// class _AIMenuPage extends ConsumerState<AIMenuPage> {
//   @override
//   void dispose() {
//     super.dispose();
//     chatsScrollController.dispose();
//     msgController.dispose();
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((v) async {
//       if (ref.watch(aiChatVm).lastAIConversationChats == null) {
//         await ref
//             .watch(aiChatVm)
//             .getAllAiChatsF(
//               context,
//               scrollController: chatsScrollController,
//               loadingFor: "getAllChats",
//               isSetInToLastAlso: true,
//             )
//             .then((v) {
//               ref
//                   .watch(aiChatVm)
//                   .getAiChatByIdF(
//                     context,
//                     chatId: ref.watch(aiChatVm).lastAIConversationChats!.id,
//                     scrollController: chatsScrollController,
//                     loadingFor: "getAiChatByIdF",
//                   );
//             });
//       }
//     });
//     super.initState();
//   }

//   TextEditingController msgController = TextEditingController();
//   ScrollController chatsScrollController = ScrollController();

//   int flashcardsLeft =
//       7; // Example number. You can dynamically load this later.

//   List menuList = [
//     {
//       'img': AppImages.movieblue,
//       'title': 'Movies Suggestions',
//       "query": "Suggested Films",
//     },
//     {
//       'img': AppImages.flashcardsblue,
//       'title': 'Track My Progress',
//       "query": "Flashcards",
//     },
//     {
//       'img': AppImages.track,
//       'title': 'Progress Charts',
//       "query": "Track My Progress",
//     },
//     {
//       'img': AppImages.query,
//       'title': 'Request Explanation',
//       "query": "Requested an Explanation",
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     var p = ref.watch(aiChatVm);
//     var t = Theme.of(context).textTheme;
//     var h = MediaQuery.of(context).size.height;
//     var w = MediaQuery.of(context).size.width;
//     return DefaultScaffold(
//       isShowDrawer: true,

//       currentPage: '/home/AIMenuPage',
//       floatingBtn: Transform.translate(
//         offset: Offset(16, 0),
//         child: Container(
//           width: w * 1,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: FractionalOffset.bottomCenter,
//               end: FractionalOffset.topCenter,
//               colors: ColorsPallet.bdb,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 5),
//               child: SizedBox(
//                 width: 400,
//                 height: 53,
//                 child: TextField(
//                   controller: msgController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     fillColor: Colors.blueGrey.shade900,
//                     filled: true,
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     suffixIcon: IconButton(
//                       onPressed: () async {
//                         if (msgController.text.isEmpty) {
//                           await EasyLoading.showInfo('Write Something');
//                         } else {
//                           await p
//                               .doConversationChatByIdWithAiF(
//                                 context,
//                                 msg: msgController.text,
//                               )
//                               .then((value) {
//                                 msgController.clear();
//                                 if (chatsScrollController.hasClients) {
//                                   chatsScrollController.jumpTo(
//                                     chatsScrollController
//                                         .position
//                                         .maxScrollExtent,
//                                   );
//                                 }
//                               });
//                         }
//                       },
//                       icon: const Icon(Icons.send),
//                     ),
//                     border: InputBorder.none,
//                     hintText: 'Type Here',
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         backgroundColor: Colors.white,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 40),
//             ListTile(
//               leading: const Icon(Icons.close_rounded, color: Colors.black),
//               title: const Text(
//                 'Previous Conversations',
//                 style: TextStyle(color: Colors.black),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 context.go(
//                   '/home/AIMenuPage/AllAIChatHistoryPage',
//                   extra: {"isPinnedOnly": false},
//                 );
//               },
//             ),
//             Divider(height: 2, color: Colors.grey.shade700),
//             ListTile(
//               leading: const Icon(Icons.push_pin_outlined, color: Colors.black),
//               title: const Text(
//                 'Pinned Conversations',
//                 style: TextStyle(color: Colors.black),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 context.go(
//                   '/home/AIMenuPage/AllAIChatHistoryPage',
//                   extra: {"isPinnedOnly": true},
//                 );
//               },
//             ),
//             Divider(height: 2, color: Colors.grey.shade700),
//             ListTile(
//               leading: const Icon(Icons.chat, color: Colors.black),
//               trailing: const Icon(
//                 Icons.delete_outline_outlined,
//                 color: Colors.black,
//               ),
//               title: const Text(
//                 'Can Your Recommended',
//                 style: TextStyle(color: Colors.black),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 context.go(
//                   '/home/AIMenuPage/AllAIChatHistoryPage',
//                   extra: {"isPinnedOnly": false},
//                 );
//               },
//             ),
//             Divider(height: 2, color: Colors.grey.shade700),
//             CupertinoListTile(
//               title: Text("Last 7 days", style: TextStyle(color: Colors.grey)),
//             ),
//             ListTile(
//               leading: const Icon(Icons.chat, color: Colors.black),
//               title: const Text(
//                 'My Recent Grammar',
//                 style: TextStyle(color: Colors.black),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 context.go(
//                   '/home/AIMenuPage/AllAIChatHistoryPage',
//                   extra: {"isPinnedOnly": false},
//                 );
//               },
//             ),
//             Divider(height: 2, color: Colors.grey.shade700),
//             const Spacer(),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               icon: const Icon(Icons.edit, color: Colors.white),
//               onPressed: () {
//                 Navigator.pop(context);
//                 ref.watch(aiChatVm).clearChatsList();
//                 ref.watch(aiChatVm).createNewChatWithAiF(context);
//               },
//               label: const Text(
//                 'New Chat',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             SizedBox(height: 30),
//           ],
//         ),
//       ),
//       child: Column(
//         children: [
//           CustomHeaderBar(
//             onBack: () async {
//               if (context.mounted) {
//                 Navigator.pop(context);
//               }
//             },
//             centerTitle: false,
//             title: 'Back',
//           ),

//           ref.watch(aiChatVm).loadingFor == "refresh" ||
//                   ref.watch(aiChatVm).loadingFor == "getAiChatByIdF"
//               ? QuickTikTokLoader()
//               : SizedBox.shrink(),

//           Container(
//             decoration: BoxDecoration(color: Colors.blueGrey.shade50),
//             width: double.infinity,
//             height: MediaQuery.of(context).size.height * 0.78,
//             child: SingleChildScrollView(
//               controller: chatsScrollController,
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   CupertinoListTile(
//                     // onTap: (){
//                     //     context.go('/home/AIMenuPage/AllAIChatHistoryPage', extra: {
//                     //       "isPinnedOnly":true,
//                     //     });
//                     // },
//                     leading: Builder(
//                       builder: (context) {
//                         return InkWell(
//                           borderRadius: BorderRadius.circular(50),
//                           child: Padding(
//                             padding: const EdgeInsets.all(5),
//                             child: const Icon(
//                               Icons.sort_outlined,
//                               color: Colors.black,
//                             ),
//                           ),
//                           onTap: () {
//                             Scaffold.of(context).openDrawer();
//                           },
//                         );
//                       },
//                     ),
//                     title:
//                         (ref
//                                 .watch(aiChatVm)
//                                 .allAiChatHistoryConversionsTitlesData !=
//                             null)
//                         ? ref
//                                   .watch(aiChatVm)
//                                   .allAiChatHistoryConversionsTitlesData!
//                                   .chats
//                                   .any((element) => element.isPinned == true)
//                               ? Text(
//                                   ref
//                                       .watch(aiChatVm)
//                                       .allAiChatHistoryConversionsTitlesData!
//                                       .chats
//                                       .firstWhere(
//                                         (element) => element.isPinned == true,
//                                       )
//                                       .title,
//                                 )
//                               : Text("Pinned")
//                         : Text("Pinned"),
//                     trailing: IconButton(
//                       onPressed: () {
//                         context.go(
//                           '/home/AIMenuPage/AllAIChatHistoryPage',
//                           extra: {"isPinnedOnly": true},
//                         );
//                       },
//                       icon: const Icon(
//                         Icons.push_pin_outlined,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                   p.lastAIConversationChats == null ||
//                           p.lastAIConversationChats!.messages.isEmpty
//                       ? Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 AppImages.robo,
//                                 width:  (h<w)? w*0.05 : w > 450 ? w * 0.1 : w * 0.2,
//                               ),
//                                Text(
//                                 ' COPILOT',
//                                 style: TextStyle(
//                                   color: Colors.black54,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize:(h<w)? 20: 30,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : SizedBox.shrink(),
//               // Text("kkkk"),
//                   if ((p.lastAIConversationChats == null ||
//                           p.lastAIConversationChats!.messages.isEmpty) &&
//                       w > 450 && !(h<w))
//                     SizedBox(height: h * 0.2)
//                   else
//                    if ((p.lastAIConversationChats == null ||
//                           p.lastAIConversationChats!.messages.isEmpty) &&
//                       w > 450 && (h<w))
//                     SizedBox(height: 0)
//                   else
//                     SizedBox(height: h * 0.02),
//                   p.lastAIConversationChats == null ||
//                           p.lastAIConversationChats!.messages.isEmpty
//                       ? Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 14),
//                           child: GridView.builder(
//                             shrinkWrap: true,
//                             controller: ScrollController(),
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: w > 450 ? 4 : 2,
//                                 ),
//                             itemCount: menuList.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               var data = menuList[index];
//                               return Padding(
//                                 padding: EdgeInsets.all(w > 450 ? 20 : 14),
//                                 child: InkWell(
//                                   onTap: () {
//                                     p.doConversationChatByIdWithAiF(
//                                       context,
//                                       msg: data['query'],
//                                     );
//                                     // if (index == 0) {
//                                     // Navigator.push(
//                                     //   context,
//                                     //   MaterialPageRoute(
//                                     //     builder: (context) =>
//                                     //         const MovieSuggetinosPage(),
//                                     //   ),
//                                     // );
//                                     // }
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Image.asset(
//                                           data['img'],
//                                           width: w > 450 ? w * 0.08 : w * 0.15,
//                                         ),
//                                         const Divider(),
//                                         Text(
//                                           '${data['title']}',
//                                           textAlign: TextAlign.center,
//                                           style: const TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         )
//                       : Expanded(
//                           // child: Text("bn"),
//                           child: ListView.builder(
//                             controller: chatsScrollController,
//                             itemCount: p.lastAIConversationChats!.messages.length,
//                             itemBuilder: (context, index) {
//                               var chat =
//                                   p.lastAIConversationChats!.messages[index];
//                               return GestureDetector(
//                                 onTap: () {
//                                   Get.bottomSheet(
//                                     Container(
//                                       height: h * 0.5,
//                                       decoration: BoxDecoration(
//                                         color: ColorsPallet.blue,
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Icon(Icons.abc_outlined),
//                                             SizedBox(height: 12),
//                                             Text(
//                                               chat.content,
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             SizedBox(height: 7),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: BubbleSpecialOne(
//                                   text: chat.content,
//                                   isSender: chat.type == "user",
//                                   color: chat.type == "user"
//                                       ? Colors.blue
//                                       : Colors.grey.shade400,
//                                   textStyle: TextStyle(
//                                     color: chat.type == "user"
//                                         ? Colors.white
//                                         : Colors.black,
//                                   ),
//                                   tail: true,
//                                   sent: chat.type == "user" ? true : false,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
