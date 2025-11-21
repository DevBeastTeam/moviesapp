import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/screenssize.dart';
import '../../controllers/quiz_controller.dart';
import '../../theme/colors.dart';
import '../../widgets/ui/default_scaffold.dart';
import 'tests_base_page.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({super.key});

  @override
  State<TestsPage> createState() => _TestsPage();
}

class _TestsPage extends State<TestsPage> {
  final QuizController quizController = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: 'tests',
      bgWidget: Container(
        width: Screen.width(context),
        height: Screen.height(context),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.bottomCenter,
            end: FractionalOffset.topCenter,
            colors: [Colors.blueGrey, ColorsPallet.darkBlue],
          ),
        ),
      ),
      // hideBottomBar: Screen.isTablet(context) || Screen.isLandscape(context),
      child: Column(
        children: [
          // Screen.isTablet(context) || Screen.isLandscape(context)
          //     ? TopBarWidget(paddingLeft: 0)
          //     : SizedBox.shrink(),
          AppBar(
            leading: null,
            centerTitle: false,
            title: const Text(
              'TEST',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            // backgroundColor: ColorsPallet.darkBlue,
          ),
          Expanded(
            child: Obx(() {
              if (quizController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (quizController.categories.isEmpty) {
                return const Center(
                  child: Text(
                    "No categories available",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var category in quizController.categories)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          // padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            // color: ColorsPallet.blueComponent,
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () async {
                              quizController.selectedCategory.value = category;
                              quizController.selectedType.value = 'training';
                              await quizController.fetchQuizzesByCategory(
                                category.id,
                                'training',
                              );
                              if (context.mounted) {
                                Get.to(() => const TestsBasePage());
                              }
                            },
                            child: Container(
                              // margin: const EdgeInsets.only(left: 12),
                              padding: const EdgeInsets.symmetric(
                                vertical: 24,
                                horizontal: 8,
                              ),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    category.label,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
