import 'package:edutainment/providers/pronounciationVM.dart';
import 'package:edutainment/widgets/emptyWidget.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_widgets/widgets/tiktok.dart';

import '../../widgets/header_bar/custom_header_bar.dart';

class PronlevelsPage extends ConsumerStatefulWidget {
  const PronlevelsPage({super.key});

  @override
  ConsumerState<PronlevelsPage> createState() => _PronlevelsPageState();
}

class _PronlevelsPageState extends ConsumerState<PronlevelsPage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(pronounciationVm).getPronounciationF(context, loadingFor: "plevel");
      // ref
      //         .read(pronounciationVm)
      //         .getPronounciationFSingleByIdF(context, id: 'k');
    });
  }

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(pronounciationVm);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return DefaultScaffold(
      currentPage: 'PronlevelsPage',
      child: Column(
        children: [
          SizedBox(
            // height: MediaQuery.of(context).size.height * 0.18,
            child: Column(
              children: [
                CustomHeaderBar(
                  onBack: () async {
                    // Get.back();
                    Navigator.pop(context);
                  },
                  centerTitle: false,
                  title: 'Select Your Levels'.toUpperCase(),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
          if(p.loadingFor =="plevel")
               QuickTikTokLoader(),
               p.pLevelCatgModelData == null
              ? EmptyWidget()
              : Padding(
                  padding: const EdgeInsets.all(14),
                  child: ListView.builder(
                    itemCount: p.pLevelCatgModelData!.data.levels.length,
                    shrinkWrap: true,
                    controller: ScrollController(),
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var data = p.pLevelCatgModelData!.data.levels[index].toUpperCase();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const PronCatgPage(),
                            //   ),
                            // );
                            context.go("/home/PronlevelsPage/PronCatgPage", extra: {
                              "selectedlabel":data, 
                              "allLevels": p.pLevelCatgModelData!.data.levels,
                              "categories":p.pLevelCatgModelData!.data.categories
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: const BoxDecoration(
                              color:  Colors.white,
                              // currentLevel: a1, b1 etc
                              // color: data.currentLevel.toString().toUpperCase() == data.toUpperCase() ? Colors.grey :  Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child:  Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    data,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'select The Level',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
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
    );
  }
}
