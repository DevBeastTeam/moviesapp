import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/helpers/forstrings.dart';
import 'package:edutainment/models/grammerModel.dart';
import 'package:edutainment/pages/grammer/grammerdetail.dart';
import 'package:edutainment/widgets/loaders/dotloader.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/grammerData.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class GrammerCatgPage extends ConsumerStatefulWidget {
  // AllowedCategory? level;
  // String id = "";
  const GrammerCatgPage({super.key, 
  // this.id = "", this.level, 
  });

  @override
  ConsumerState<GrammerCatgPage> createState() => GrammerCatgPageState();
}

class GrammerCatgPageState extends ConsumerState<GrammerCatgPage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(grammerData).getGrammersF(context, loadingFor: "grammerCatg");
    });
  }

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(grammerData);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    //////////
    // Access the extra data from GoRouterState
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    if (extra == null) {
      return const Scaffold(
        body: Center(child: Text("Should Pass Extra Data")),
      );
    }

    final id = extra['id'].toString().toNullString(); 
    // final level = extra['level'] as AllowedCategory ?? AllowedCategory(id: "1", label: "abc", reference: "abc", level: "a1"); 
    ///////////



    return DefaultScaffold(
      currentPage: '/home/GrammerPage/grammerCatg',
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        controller: ScrollController(),
        child: Column(
          children: [
            CustomHeaderBar(
              onBack: () async {
                // context.pop();
                // Get.back();
                Navigator.pop(context);
              },
              centerTitle: false,
              title: 'Lessaons',
            ),
            ///////////////
            const Text(
              'LESSONS CATEGORIES',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            
            // Text("id: ${widget.id}"),
            // Text("level: ${widget.level!.label.toString()}"),
            // Text("level: ${widget.level!.level.toString()}"),
            // Text("level: ${widget.level!.reference.toString()}"),
            p.loadingFor=="grammerCatg"
                ? Padding(
                    padding: EdgeInsets.only(top: h * 0.45),
                    child: const Center(child: DotLoader()),
                  )
                : p.grammersList.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: h * 0.45),
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
                : ListView.builder(
                    itemCount: p.grammersList[0].groupLessons.keys.length,
                    // itemCount: p.grammersList.length,
                    shrinkWrap: true,
                    controller: ScrollController(),
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var key = p.grammersList[0].groupLessons.keys
                          .toList()[index];
                      var data = p.grammersList[0].groupLessons[key];

                      // return Text("$data");

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              p.setExpandedIndexIs = index;
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1,
                                  ),
                                ),
                                child: CupertinoListTile(
                                  title: Text(
                                    key,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: SizedBox(
                                    width: 35,
                                    child: Image.asset(
                                      AppImages.playerlight,
                                      width: 35,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (p.expandedIndexIs == index)
                            ListView(
                              shrinkWrap: true,
                              controller: ScrollController(),
                              children: data!.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      // context.go('/lessondetail');
                                      p.getGrammerSingleByIdF(
                                        context,
                                        id: e.id,
                                        loadingFor: "next"
                                      );

                                      context.go('/home/GrammerPage/grammerCatg/grammerdetail', extra: {
                                        'labelsLessons': data,
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: CupertinoListTile(
                                        // title: Text('hjk',
                                        title: Text(
                                          e.label,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        trailing: SizedBox(
                                          width: 25,
                                          child: Image.asset(
                                            AppImages.check,
                                            width: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
