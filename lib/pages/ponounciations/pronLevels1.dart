import 'pronCatgPage2.dart';
import 'package:edutainment/widgets/emptyWidget.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_widgets/widgets/tiktok.dart';

import '../../controllers/pronunciation_controller.dart';
import '../../constants/screenssize.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class PronlevelsPage1 extends StatefulWidget {
  const PronlevelsPage1({super.key});

  @override
  State<PronlevelsPage1> createState() => _PronlevelsPage1State();
}

class _PronlevelsPage1State extends State<PronlevelsPage1> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<PronunciationController>().getPronunciations(
        context,
        loadingFor: "plevel",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: '/home/PronlevelsPage1',
      child: SingleChildScrollView(
        controller: ScrollController(),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              // height: MediaQuery.of(context).size.height * 0.18,
              child: Column(
                children: [
                  CustomHeaderBar(
                    onBack: () async {
                      Navigator.pop(context);
                    },
                    centerTitle: false,
                    title: 'Select Your Levels'.toUpperCase(),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            GetBuilder<PronunciationController>(
              builder: (controller) {
                if (controller.loadingFor == "plevel") {
                  return QuickTikTokLoader();
                }

                if (controller.pLevelCatgModelData == null) {
                  return EmptyWidget();
                }

                return Padding(
                  padding: const EdgeInsets.all(14),
                  child: SizedBox(
                    width: Screen.width(context) > 450
                        ? Screen.width(context) * 0.7
                        : null,
                    child: ListView.builder(
                      itemCount:
                          controller.pLevelCatgModelData!.data.levels.length,
                      shrinkWrap: true,
                      controller: ScrollController(),
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var data = controller
                            .pLevelCatgModelData!
                            .data
                            .levels[index]
                            .toUpperCase();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () {
                              // Store data in controller
                              controller.setSelectedLevel(
                                level: data,
                                allLevels:
                                    controller.pLevelCatgModelData!.data.levels,
                                categories: controller
                                    .pLevelCatgModelData!
                                    .data
                                    .categories,
                              );
                              // Navigate without extra
                              Get.to(() => const PronCatgPage2());
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                // currentLevel: a1, b1 etc
                                // color: data.currentLevel.toString().toUpperCase() == data.toUpperCase() ? Colors.grey :  Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
