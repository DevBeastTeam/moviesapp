// import 'package:chat_bubbles/chat_bubbles.dart';
// import 'package:edutainment/constants/appimages.dart';
// import 'package:edutainment/providers/aichatvm.dart';
// import 'package:edutainment/theme/colors.dart';
// import 'package:edutainment/widgets/ui/default_scaffold.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import '../../widgets/header_bar/custom_header_bar.dart';
// import '../../widgets/loaders/dotloader.dart';

// class AIChatPage extends ConsumerStatefulWidget {
//   const AIChatPage({super.key});

//   @override
//   ConsumerState<AIChatPage> createState() => AIChatPageState();
// }

// class AIChatPageState extends ConsumerState<AIChatPage> {
//   @override
//   void dispose() {
//     super.dispose();
//     chatsScrollController.dispose();
//     msgController.dispose();
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((v){
// ref.watch(chatWithAiVm).getChatWithAiF(context, scrollController: chatsScrollController, loadingFor: "getAllChats");
//     });
//     super.initState();
//   }

//   List<DateTime> messageDates = [];
//   TextEditingController msgController = TextEditingController();
//   ScrollController chatsScrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     var p = ref.watch(chatWithAiVm);
//     var t = Theme.of(context).textTheme;
//     var h = MediaQuery.of(context).size.height;
//     var w = MediaQuery.of(context).size.width;

//     return DefaultScaffold(
//       currentPage: '/home/ai/aichat',
//       floatingBtn: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 15),
//           child: TextField(
//             controller: msgController,
//             style: const TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               fillColor: Colors.blueGrey.shade900,
//               filled: true,
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               suffixIcon: IconButton(
//                 onPressed: () async {
//                   if (msgController.text.isEmpty) {
//                     await EasyLoading.showInfo('Write Something');
//                   } else {
//                     await p
//                         .chatWithAiF(context, query: msgController.text)
//                         .then((value) {
//                           msgController.clear();
//                           if (chatsScrollController.hasClients) {
//                             chatsScrollController.jumpTo(
//                               chatsScrollController.position.maxScrollExtent,
//                             );
//                           }
//                         });
//                   }
//                 },
//                 icon: const Icon(Icons.send),
//               ),
//               border: InputBorder.none,
//               hintText: 'Type Here',
//             ),
//           ),
//         ),
//       ),
//       // resizeToAvoidBottomInset: true,
//       child: Column(
//         children: [
//           Expanded(
//             child: Column(
//               children: [
//                 CustomHeaderBar(
//                   onBack: () async {
//                     if (context.mounted) {
//                       context.pop();
//                     }
//                   },
//                   centerTitle: false,
//                   title: 'Chat With Ai'.toUpperCase(),
//                 ),
//                 const SizedBox(height: 20),
//                 p.chatAiList.isEmpty
//                     ? Padding(
//                       padding: EdgeInsets.only(top: h*0.1, left:20, right: 20),
//                       child: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount:  w > 450 ? 4:  2,
//                           crossAxisSpacing: 20.0,
//                           mainAxisSpacing: 20.0,
//                         ),
//                         shrinkWrap: true,
//                         controller: ScrollController(),
//                           children: [
                      
//                       preChatBox( title: "Movie Suggetions", imgPath: AppImages.movieblue, onTap: (){
//                          p.chatWithAiF(context, query: "Suggested Films");
//                       }, height: h, width: w,),
//                       preChatBox( title: "Cards", imgPath: AppImages.flashcardsblue, onTap: (){
//                          p.chatWithAiF(context, query: "Flashcards");
//                       }, height: h, width: w,),
//                       preChatBox( title: "Track My Progress", imgPath: AppImages.track, onTap: (){
//                          p.chatWithAiF(context, query: "Track My Progress");
//                       }, height: h, width: w,),
//                       preChatBox( title: "Requested an Expactations", imgPath: AppImages.query, onTap: (){
//                          p.chatWithAiF(context, query: "Requested an Explanation");
//                       }, height: h, width: w,),
                      
                                         
//                           ],
//                         ),
//                     )
//                     // ? Expanded(
//                     //     child: Center(
//                     //       child: Text(
//                     //         'Empty',
//                     //         style: t.titleMedium!.copyWith(
//                     //           color: Colors.orange,
//                     //           fontWeight: FontWeight.bold,
//                     //           letterSpacing: 2,
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   )
//                     : Expanded(
//                       // child: Text("bn"),
//                         child: ListView.builder(
//                           controller: chatsScrollController,
//                           itemCount: p.chatAiList.length,
//                           itemBuilder: (context, index) {
//                             var chat = p.chatAiList[index];
//                             return GestureDetector(
//                               onTap: () {
//                                Get.bottomSheet(
//                                 Container(
//                                   height: h*0.5,
//                                   decoration: BoxDecoration(
//                                     color: ColorsPallet.blue,
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         Icon(Icons.abc_outlined),
//                                         SizedBox(height: 12),
//                                         Text(chat.msg, style: TextStyle(fontWeight: FontWeight.bold)),
//                                         SizedBox(height: 7),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                );
//                               },
//                               child: BubbleSpecialOne(
//                                 text: chat.msg,
//                                 isSender: chat.isSender,
//                                 color: chat.isSender
//                                     ? Colors.blue
//                                     : Colors.grey.shade400,
//                                 textStyle: TextStyle(
//                                   color: chat.isSender
//                                       ? Colors.white
//                                       : Colors.black,
//                                 ),
//                                 tail: true,
//                                 sent: true,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                 if (p.loadingFor == "ai")
//                   const SizedBox(height: 20, child: Center(child: DotLoader())),
//               ],
//             ),
//           ),

//           // Bottom Input Bar with SafeArea
//         ],
//       ),
//     );
//   }
// }

// preChatBox({
//   String title = "",
//   String imgPath = "",
//   double width = 0.0,
//   double height = 0.0,
//   Function()? onTap,
// }) {
//  return GestureDetector(
//     onTap: () {
//       onTap!();
//     },
//     child: Container(
//       width: width * 0.2,
//       height: height * 0.23,
//       decoration: BoxDecoration(
//         color: ColorsPallet.blue,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset(imgPath, width: width * 0.1),
//             SizedBox(height: 12),
//             Text(title, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
//             SizedBox(height: 7),
//           ],
//         ),
//       ),
//     ),
//   );
// }
