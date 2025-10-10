import 'package:edutainment/constants/toats.dart';
import 'package:edutainment/widgets/header_bar/custom_header_bar.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import '../../providers/aichatvm.dart';
import '../../widgets/emptyWidget.dart';

class AllAIChatHistoryPage extends ConsumerStatefulWidget {
  const AllAIChatHistoryPage({super.key});

  @override
  ConsumerState<AllAIChatHistoryPage> createState() =>
      _AllAIChatHistoryPageState();
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

     // Get the questions list passed from GoRouter
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    bool isPinnedOnly = extra?['isPinnedOnly']  as bool ?? false;

    return DefaultScaffold(
      currentPage: "/home/AIMenuPage/AllAIChatHistoryPage",
      child: SingleChildScrollView(
        controller: ScrollController(),
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
            Text("${isPinnedOnly? 'Pinned':'All'} Chats ${isPinnedOnly? '':'History'} ", style: Theme.of(context).textTheme.titleMedium,),
            p.loadingFor == "refresh" || p.loadingFor == "getAllChatsHistory"
                ? QuickTikTokLoader()
                : SizedBox.shrink(),
        
            (p.allAiChatHistoryConversionsTitlesData == null)
                ? EmptyWidget(paddingTop: 30)
                : ListView.separated(
                    itemCount: isPinnedOnly
                        ? p.allAiChatHistoryConversionsTitlesData!.chats
                            .where((element) => element.isPinned)
                            .length
                        :
                        p.allAiChatHistoryConversionsTitlesData!.chats.length,
                    shrinkWrap: true,
                    controller: ScrollController(),
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      var data = isPinnedOnly 
                          ? p.allAiChatHistoryConversionsTitlesData!.chats
                              .where((element) => element.isPinned)
                              .toList()[index]
                          :
                          p.allAiChatHistoryConversionsTitlesData!.chats[index];
                      return ListTile(
                        leading: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            CircleAvatar(child: Text("${index + 1}")),
                            data.isPinned
                                ? Icon(
                                    Icons.push_pin_rounded,
                                    color: Colors.blue,
                                    size: 15,
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                        title: Text(data.title),
                        subtitle: Text(data.createdAt.toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () async{
                                context.pop();
                          await p.getAiChatByIdF(context, chatId: data.id, loadingFor: "refresh");
                              },
                              child: Icon(Icons.chat_outlined)),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: 300,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: data.isPinned? Icon(Icons.push_pin_outlined) : Icon(Icons.push_pin_rounded),
                                          title:  Text(data.isPinned? "UnPin" : "Pin"),
                                          onTap: () async {
                                            context.pop();
                                            await p.toggleConversationChatsPinByIdF(context, conversationId: data.id);
                                          },
                                        ),
                                        Divider(),
                                        ListTile(
                                          leading: Icon(Icons.delete),
                                          title: Text("Delete"),
                                          onTap: () async {
                                            context.pop();
                                            await p.deleteConversationChatsByIdF(context, conversationId: data.id);
                                          },
                                        ),
                                        Divider(),
                                        ListTile(
                                          leading: Icon(Icons.edit),
                                          title: Text("Update Title"),
                                          onTap: () async {
                                            context.pop();
                                            TextEditingController titleControler = TextEditingController(text: data.title??'');
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("Update Title"),
                                                content: TextFormField(
                                                  controller: titleControler,                                               
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      context.pop();
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await p
                                                          .updateConversationChatsTitleByIdF(
                                                            context,
                                                            conversationId:
                                                                data.id,
                                                            newTitle: titleControler.text,
                                                          ).then((v){
                                                              context.pop();
                                                          });
                                                    },
                                                    child: Text("Update"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                        onTap: () async {
                          context.pop();
                          await p.getAiChatByIdF(context, chatId: data.id, loadingFor: "refresh");
                        },
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
