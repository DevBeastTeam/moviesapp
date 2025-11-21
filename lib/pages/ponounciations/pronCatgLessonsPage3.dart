import 'pronParacticePage4.dart';
import 'package:edutainment/constants/screenssize.dart';
import 'package:edutainment/controllers/pronunciation_controller.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_widgets/widgets/tiktok.dart';

import '../../constants/appimages.dart';
import '../../models/pLevelCatgModel.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class PronCatgLessonsPage3 extends StatefulWidget {
  const PronCatgLessonsPage3({super.key});

  @override
  State<PronCatgLessonsPage3> createState() =>
      _PronCatgLessonsPage3State();
}

class _PronCatgLessonsPage3State extends State<PronCatgLessonsPage3> {
  // List catgList = [
  //   {'icon': AppImages.check, 'title': 'DAILY'},
  //   {'icon': AppImages.check, 'title': 'HISTORY'},
  //   {'icon': AppImages.uncheck, 'title': 'PRONOUNCE'},
  //   {'icon': AppImages.uncheck, 'title': 'BODY'},
  //   {'icon': AppImages.uncheck, 'title': 'NUMBERS'},
  //   {'icon': AppImages.uncheck, 'title': 'TIME'},
  //   {'icon': AppImages.uncheck, 'title': 'COLORS'},
  //   {'icon': AppImages.uncheck, 'title': 'BLABLA'},
  // ];
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;

    return DefaultScaffold(
      currentPage: '/home/PronlevelsPage1/2/3',
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: GetBuilder<PronunciationController>(
          builder: (controller) {
            // Get data from GetX controller inside the builder for reactive updates
            final selectedlabel = controller.selectedLevel;
            List<String> allLevels = controller.allLevels;
            List<Category> categories = controller.categories;
            Category? selectedCatg = controller.selectedCategory;
            
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.loadingFor == "getPronBySelectedCatgOptionsByIdF")
                  QuickTikTokLoader(),

              Column(
              children: [
                CustomHeaderBar(
                  onBack: () async {
                    Navigator.pop(context);
                  },
                  centerTitle: false,
                  title: 'Pronounciations'.toUpperCase(),
                ),
                const SizedBox(height: 10),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    Screen.isTablet(context) && Screen.isLandscape(context)
                    ? h * 0.07
                    : 30,
              ),
              child: SizedBox(
                height: Screen.isTablet(context) && Screen.isLandscape(context)
                    ? h * 0.15
                    : h * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: allLevels.map((data) {
                    return Padding(
                      padding: const EdgeInsets.all(6),
                      child: InkWell(
                        onTap: () {
                          // Update selected level in controller
                          controller.setSelectedLevel(
                            level: data,
                            allLevels: allLevels,
                            categories: categories,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            // color:
                            // level.toString().toString().toLowerCase() ==
                            //     data.toString().toLowerCase()
                            // ? Colors.blue
                            // : Colors.white,
                            color: Colors.white,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors:
                                  selectedlabel
                                          .toString()
                                          .toString()
                                          .toLowerCase() ==
                                      data.toString().toLowerCase()
                                  ? [
                                      Colors.orange.shade200,
                                      Colors.deepOrange.shade300,
                                      Colors.red,
                                      Colors.red.shade800,
                                    ]
                                  : [Colors.white, Colors.white],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: 45,
                          height: 55,
                          child: Center(
                            child: Text(
                              data.toUpperCase(),
                              style: TextStyle(
                                color:
                                    selectedlabel.toString().toLowerCase() ==
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
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.87,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CupertinoListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  title: Text(
                    selectedCatg?.label ?? '',
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
                  itemCount:                 controller.pLevelCatgModelData!.data.lessons.length,
                  shrinkWrap: true,
                  controller: ScrollController(),
                  physics: const ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    // var data = catgList[index];
                    var data = controller.pLevelCatgModelData!.data.lessons[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      child: InkWell(
                        onTap: () {
                          // Store lesson data in controller
                          controller.setSelectedLesson(
                            lesson: data,
                            lessonId: data.id,
                            lessonIndex: index,
                          );
                          // Navigate without extra
                          Get.to(() => const PronParacticePage4());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(width: 1, color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CupertinoListTile(
                            title: Text(
                              data.label,
                              style: const TextStyle(color: Colors.blue),
                            ),
                            leading: SizedBox(
                              width: 25,
                              child: data.completed ? Image.asset(AppImages.check, width: 25) : Image.asset(AppImages.uncheck, width: 25),
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
        );
          },
        ),
      ),
    );
  }
}
