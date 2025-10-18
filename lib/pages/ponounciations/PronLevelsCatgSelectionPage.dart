import 'package:edutainment/constants/screenssize.dart';
import 'package:edutainment/pages/ponounciations/pronoundetails.dart';
import 'package:edutainment/providers/pronounciationVM.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_widgets/widgets/tiktok.dart';

import '../../constants/appimages.dart';
import '../../models/pLevelCatgModel.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class PronLevelsCatgSelectionPage extends ConsumerStatefulWidget {
  const PronLevelsCatgSelectionPage({super.key});

  @override
  ConsumerState<PronLevelsCatgSelectionPage> createState() =>
      _PronLevelsCatgSelectionPageState();
}

class _PronLevelsCatgSelectionPageState
    extends ConsumerState<PronLevelsCatgSelectionPage> {
  List catgList = [
    {'icon': AppImages.check, 'title': 'DAILY'},
    {'icon': AppImages.check, 'title': 'HISTORY'},
    {'icon': AppImages.uncheck, 'title': 'PRONOUNCE'},
    {'icon': AppImages.uncheck, 'title': 'BODY'},
    {'icon': AppImages.uncheck, 'title': 'NUMBERS'},
    {'icon': AppImages.uncheck, 'title': 'TIME'},
    {'icon': AppImages.uncheck, 'title': 'COLORS'},
    {'icon': AppImages.uncheck, 'title': 'BLABLA'},
  ];
  @override
  Widget build(BuildContext context) {
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    // Get the extra data passed from GoRouter
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final selectedlabel = extra?['selectedlabel'] as String;
    List<String> allLevels = extra?['allLevels'] as List<String>;
    List<Category> categories = extra?['categories'] as List<Category>;
    Category selectedCatg = extra?['selectedCatg'] as Category;

    // // get data
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref
    //       .read(pronounciationVm)
    //       .getPronBySelectedCatgOptionsByIdF(
    //         context,
    //         id: selectedCatg.id,
    //         loadingFor: "getPronBySelectedCatgOptionsByIdF",
    //       );
    // });

    return DefaultScaffold(
      currentPage: 'PronLevelsCatgSelectionPage',
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ref.watch(pronounciationVm).loadingFor ==
                "getPronBySelectedCatgOptionsByIdF")
              QuickTikTokLoader(),

            Column(
              children: [
                CustomHeaderBar(
                  onBack: () async {
                    // Get.back();
                    Navigator.pop(context);
                  },
                  centerTitle: false,
                  title: 'Pronounciations'.toUpperCase(),
                ),
                const SizedBox(height: 10),
              ],
            ),
            SizedBox(
              height: Screen.isPhone(context) && Screen.isLandscape(context)
                  ? h * 0.15
                  : h * 0.08,
              child: ListView.builder(
                itemCount: allLevels.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var data = allLevels[index];
                  return Padding(
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedlabel.toLowerCase() == data.toLowerCase()
                            ? Colors.blue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 50,
                      height: 40,
                      child: Center(
                        child: Text(
                          data.toUpperCase(),
                          style: TextStyle(
                            color:
                                selectedlabel.toLowerCase() ==
                                    data.toLowerCase()
                                ? Colors.white
                                : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.87,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: CupertinoListTile(
                  onTap: () {
                    context.pop();
                  },
                  title: Text(
                    selectedCatg.label,
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                // height: MediaQuery.of(context).size.height * 0.65,
                child: ListView.builder(
                  itemCount: catgList.length,
                  shrinkWrap: true,
                  controller: ScrollController(),
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    var data = catgList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PronounciationsDetailsPage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(width: 1, color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CupertinoListTile(
                            title: Text(
                              data['title'],
                              style: const TextStyle(color: Colors.blue),
                            ),
                            leading: SizedBox(
                              width: 25,
                              child: Image.asset(data['icon'], width: 25),
                            ),
                            // trailing: SizedBox(
                            //   width: 25,
                            //   child: Image.asset(AppImages.playIcon, width: 25),
                            // ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
