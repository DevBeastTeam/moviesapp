import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/widgets/card_3d.dart';
import 'package:edutainment/widgets/emptyWidget.dart';
import 'package:edutainment/widgets/loaders/dotloader.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/screenssize.dart';
import '../../controllers/grammer_controller.dart';
import '../../controllers/navigation_args_controller.dart';
import '../../widgets/header_bar/custom_header_bar.dart';
import 'grammerdetail.dart';

class GrammerCatgPage extends StatefulWidget {
  // AllowedCategory? level;
  // String id = "";
  const GrammerCatgPage({
    super.key,
    // this.id = "", this.level,
  });

  @override
  State<GrammerCatgPage> createState() => GrammerCatgPageState();
}

class GrammerCatgPageState extends State<GrammerCatgPage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<GrammerController>().getGrammersF(
        context,
        loadingFor: "grammerCatg",
      );
    });
  }

  List<String> allLevels = ["A1", "A2", "B1", "B2", "C1", "C2"];

  @override
  Widget build(BuildContext context) {
    final p = Get.find<GrammerController>();
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    //////////
    // Access the extra data from GoRouterState
    // final extra = Get.arguments as Map<String, dynamic>?;

    // if (extra == null) {
    //   return Scaffold(
    //     body: Center(child: EmptyWidget(text: "Empty")),
    //   );
    // }

    // final id = extra['id'].toString().toNullString();
    // final level = extra['level'] == null
    //     ? AllowedCategory(id: "1", label: "abc", reference: "abc", level: "a1")
    //     : extra['level'] as AllowedCategory ??
    //           AllowedCategory(
    //             id: "1",
    //             label: "abc",
    //             reference: "abc",
    //             level: "a1",
    //           );
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
                Navigator.pop(context);
              },
              centerTitle: false,
              title: 'LESSONS',
            ),

            ///////////////
            SizedBox(
              height: Screen.isPhone(context) && Screen.isLandscape(context)
                  ? h * 0.15
                  : h * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: allLevels.map((data) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        p.setSelectedLabelCH(data.toString());
                      },
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            // color:
                            // level.toString().toString().toLowerCase() ==
                            //     data.toString().toLowerCase()
                            // ? Colors.blue
                            // : Colors.white,
                            color: Colors.white,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors:
                                  p.selctedLableChIs.toString().toLowerCase() ==
                                      data.toString().toLowerCase()
                                  ? [
                                      Colors.orange.shade400,
                                      Colors.orange.shade400,
                                      Colors.red.shade500,
                                    ]
                                  : [Colors.white, Colors.white],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Text(
                              data.toUpperCase(),
                              style: TextStyle(
                                color:
                                    p.selctedLableChIs
                                            .toString()
                                            .toLowerCase() ==
                                        data.toString().toLowerCase()
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 15),
            const Text(
              'LESSONS CATEGORIES',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 15),
            Obx(
              () => p.loadingFor == "grammerCatg"
                  ? Padding(
                      padding: EdgeInsets.only(top: h * 0.45),
                      child: const Center(child: DotLoader()),
                    )
                  : p.grammersList.isEmpty
                  ? EmptyWidget(text: "Empty")
                  : ListView.builder(
                      itemCount: p.grammersList[0].tags.length,
                      // itemCount: p.grammersList.length,
                      shrinkWrap: true,
                      controller: ScrollController(),
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var tag = p.grammersList[0].tags[index];

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
                                padding: const EdgeInsets.all(5),
                                child: Card3D(
                                  borderRadius: 7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      // border: Border.all(
                                      //   color: Colors.blue,
                                      //   width: 1,
                                      // ),
                                    ),
                                    child: CupertinoListTile(
                                      title: Text(
                                        tag.label,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
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
                            ),
                            if (p.expandedIndexIs == index)
                              ListView(
                                shrinkWrap: true,
                                controller: ScrollController(),
                                children: data!
                                    .where((e) => e.id != tag.id)
                                    .map((e) {
                                      // return Text("${e.contenten}");
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 3,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            // p.getGrammerSingleByIdF(
                                            //   context,
                                            //   //   id: e.id,
                                            //   //   loadingFor: "next",
                                            //   // );

                                            final navCtrl =
                                                Get.find<
                                                  NavigationArgsController
                                                >();
                                            navCtrl.grammerCatgName =
                                                p.selctedLableChIs;
                                            navCtrl.grammerSubCatgName =
                                                tag.label;
                                            navCtrl.grammerSubLessons = data;
                                            navCtrl.grammerSelectedLesson = e;
                                            Get.to(
                                              () => const GrammerDetailPage(),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: CupertinoListTile(
                                              title: Text(
                                                e.label,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              trailing: SizedBox(
                                                width: 25,
                                                child: e.isRead
                                                    ? Image.asset(
                                                        AppImages.check,
                                                        width: 25,
                                                      )
                                                    : Image.asset(
                                                        AppImages.uncheck,
                                                        width: 25,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
