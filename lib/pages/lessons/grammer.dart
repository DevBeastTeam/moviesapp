import 'package:edutainment/widgets/emptyWidget.dart';
import 'package:edutainment/widgets/loaders/dotloader.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import '../../providers/grammerVm.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class GrammerPage extends ConsumerStatefulWidget {
  const GrammerPage({super.key});

  @override
  ConsumerState<GrammerPage> createState() => GrammerPageState();
}

class GrammerPageState extends ConsumerState<GrammerPage> {
  @override
  void initState() {
    super.initState();
    //
    syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(grammerData).getGrammersF(context, loadingFor: "grammer");
    });
  }

  @override
  Widget build(BuildContext context) {
    // var p = ref.watch(grammerData);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return DefaultScaffold(
      currentPage: '/home/GrammerPage',
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        controller: ScrollController(),
        child: Column(
          children: [
            CustomHeaderBar(
              onBack: () async {
                Navigator.pop(context);
              },
              centerTitle: false,
              title: 'Lessons',
            ),

            if (ref.watch(grammerData).loadingFor == "grammer")
              QuickTikTokLoader(),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'SELECT YOUR LEVEL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),

            if (ref.watch(grammerData).grammersList.isEmpty)
              EmptyWidget()
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ref
                      .watch(grammerData)
                      .grammersList
                      .first
                      .allowedLessonCategory
                      .length,
                  controller: ScrollController(),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    var level = ref
                        .watch(grammerData)
                        .grammersList
                        .first
                        .allowedLessonCategory[index];
                    return buildLevelBox(
                      level.label,
                      // subtitle: "",
                      onTap: () async {
                        // in future if need
                        //  await ref.read(grammerData).getGrammersByIdForCatgListF(context, levelId:level.id , loadingFor: "grammerCatg");
                        await ref
                            .read(grammerData)
                            .getGrammerSingleByIdF(
                              context,
                              id: level.id,
                              loadingFor: "grammerCatg",
                            );

                        context.go(
                          '/home/GrammerPage/grammerCatg',
                          extra: {"id": level.id.toString(), "level": level},
                        );

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => GrammerCatgPage(
                        //       id: level.id.toString(),
                        //       level: level,
                        //     ),
                        //   ),
                        // );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildLevelBox(
    String level, {
    String subtitle = "Select this level",
    required Function onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Center(
          child: Text(
            level,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(subtitle, style: TextStyle(color: Colors.grey)),
          ),
        ),
        onTap: () {
          onTap();
        },
      ),
    );
  }
}
