import 'package:edutainment/widgets/header_bar/custom_header_bar.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import '../../providers/aichatvm.dart';
import '../../widgets/emptyWidget.dart';

class AllAIChatHistoryPage extends ConsumerStatefulWidget {
  const AllAIChatHistoryPage({super.key});

  @override
  ConsumerState<AllAIChatHistoryPage> createState() => _AllAIChatHistoryPageState();
}

class _AllAIChatHistoryPageState extends ConsumerState<AllAIChatHistoryPage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .watch(aiChatVm)
          .getAllAiChatsF(context, loadingFor: "getAllChatsHistory");
    });
  }

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(aiChatVm);
    // .getAllAiChatsF(context)
    return DefaultScaffold(
      currentPage: "/home/AIMenuPage/AllAIChatHistoryPage",
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

          ///////
          // Text("AI Chat History Page"),
          p.loadingFor == "refresh" || p.loadingFor == "getAllChatsHistory"
              ? QuickTikTokLoader()
              : SizedBox.shrink(),

          (p.allAiChatHistoryConversionsTitlesData == null)
              ? EmptyWidget(paddingTop: 30)
              : ListView.separated(
                  itemCount:
                      p.allAiChatHistoryConversionsTitlesData!.chats.length,
                  shrinkWrap: true,
                  controller: ScrollController(),
                   separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    var data =
                        p.allAiChatHistoryConversionsTitlesData!.chats[index];
                    return ListTile(
                      leading: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          CircleAvatar(child: Text("${index+1}")),
                         data.isPinned? Icon(Icons.push_pin_rounded, color: Colors.blue,size: 15,):SizedBox.shrink()
                        ],
                      ),
                      title: Text(data.title),
                      subtitle: Text(data.createdAt.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_outlined),
                          IconButton(onPressed: (){
                            showModalBottomSheet(context: context, builder: (context)=>SizedBox(
                              height: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.push_pin_rounded),
                                    title: Text("Pin"),
                                    onTap: () async{
                                      // await p.pinAiChatByIdF(context, chatId: data.id);
                                      context.pop();
                                    },
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text("Delete"),
                                    onTap: () async{
                                      // await p.deleteAiChatByIdF(context, chatId: data.id);
                                      context.pop();
                                    },
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),);
                         }, icon: Icon(Icons.more_vert))
                        ],
                      ),
                      onTap: () async{
                        // await p.getAiChatByIdF(context, chatId: data.id);
                        // context.pop();
                      },
                    );
                  },
                 
                ),
        ],
      ),
    );
  }
}
