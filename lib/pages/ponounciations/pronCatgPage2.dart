import 'pronCatgLessonsPage3.dart';
import 'package:edutainment/helpers/safe_converters.dart';
import 'package:edutainment/widgets/emptyWIdget.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/screenssize.dart';
import '../../models/pLevelCatgModel.dart';
import '../../controllers/pronunciation_controller.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class PronCatgPage2 extends StatefulWidget {
  const PronCatgPage2({super.key});

  @override
  State<PronCatgPage2> createState() => _PronCatgPage2State();
}

class _PronCatgPage2State extends State<PronCatgPage2> {
  // List catgList = [
  //   {'icon': '📚', 'title': 'Education', " subtitle": "Education"},
  //   {'icon': '✈️', 'title': 'Travel', " subtitle": "Education"},
  //   {'icon': '💼', 'title': 'Work', " subtitle": "Education"},
  //   {'icon': '🎭', 'title': 'Culture & Entetainment', " subtitle": "Education"},
  //   {'icon': '⚽', 'title': 'Sports', " subtitle": "Education"},
  //   {'icon': '🏠', 'title': 'Daily Life', " subtitle": "Education"},
  //   {'icon': '👥', 'title': 'Holidays', " subtitle": "Education"},
  //   {'icon': '🏥', 'title': 'Relatioins', " subtitle": "Education"},
  // ];
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: '/home/PronlevelsPage1/2',
      child: SingleChildScrollView(
        controller: ScrollController(),

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
                    title: 'Select A Category'.toUpperCase(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            SizedBox(
              height: Screen.isTablet(context) && Screen.isLandscape(context)
                  ? Screen.height(context) * 0.15
                  : Screen.height(context) * 0.00,
            ),
            GetBuilder<PronunciationController>(
              builder: (controller) {

                List<Category> categories = controller.categories;
                
                return categories.isEmpty
                    ? EmptyWidget()
                    : Padding(
                        padding: const EdgeInsets.all(14),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: List.generate(categories.length, (index) {
                            var data = categories[index];
                            return InkWell(
                              onTap: () {
                                // Store selected category in controller
                                controller.setSelectedCategory(data);
                                // Navigate without extra
                                Get.to(() => const PronCatgLessonsPage3());
                              },
                          child: Container(
                            width:
                                Screen.isTablet(context) &&
                                    Screen.isPortrait(context)
                                ? Screen.width(context) * 0.7
                                : Screen.isTablet(context) &&
                                      Screen.isLandscape(context)
                                ? Screen.width(context) * 0.3
                                : null,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    data.icon,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    Screen.isTablet(context) &&
                                            Screen.isLandscape(context)
                                        ? data.label.toString().toSubStringText(
                                            0,
                                            20,
                                          )
                                        : data.label.toUpperCase(),
                                    maxLines: 3,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                          }),
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
