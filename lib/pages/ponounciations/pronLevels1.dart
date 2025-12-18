import 'package:edutainment/theme/colors.dart';
import 'package:edutainment/widgets/card_3d.dart';

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

                final isTablet = Screen.width(context) > 450;

                return Padding(
                  padding: const EdgeInsets.all(14),
                  child: SizedBox(
                    width: isTablet ? Screen.width(context) * 0.7 : null,
                    child: isTablet
                        ? GridView.builder(
                            itemCount: controller
                                .pLevelCatgModelData!
                                .data
                                .levels
                                .length,
                            shrinkWrap: true,
                            controller: ScrollController(),
                            physics: const ScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 3.5, // Adjust as needed
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              var data = controller
                                  .pLevelCatgModelData!
                                  .data
                                  .levels[index]
                                  .toUpperCase();
                              return InkWell(
                                onTap: () {
                                  // Store data in controller
                                  controller.setSelectedLevel(
                                    level: data,
                                    allLevels: controller
                                        .pLevelCatgModelData!
                                        .data
                                        .levels,
                                    categories: controller
                                        .pLevelCatgModelData!
                                        .data
                                        .categories,
                                  );
                                  // Navigate without extra
                                  Get.to(() => const PronCatgPage2());
                                },
                                child: Card3D(
                                  borderRadius: 5,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      // color: ColorsPallet.darkBlue,
                                      // color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            data.toUpperCase(), // Use data here if needed
                                            // 'Level Name', // Placeholder
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'select The Level',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: controller
                                .pLevelCatgModelData!
                                .data
                                .levels
                                .length,
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
                                      allLevels: controller
                                          .pLevelCatgModelData!
                                          .data
                                          .levels,
                                      categories: controller
                                          .pLevelCatgModelData!
                                          .data
                                          .categories,
                                    );
                                    Get.to(() => const PronCatgPage2());
                                  },
                                  child: Card3D(
                                    borderRadius: 4,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        // color: Colors.white,
                                        color: ColorsPallet.darkBlue,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              // data, // Use data here if needed
                                              data.toUpperCase(), // Placeholder
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'select The Level',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
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
