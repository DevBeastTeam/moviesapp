import 'package:edutainment/constants/screenssize.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import '../../controllers/exercises_controller.dart';
import '../../controllers/navigation_args_controller.dart';

import '../../widgets/emptyWIdget.dart';
import '../../widgets/header_bar/custom_header_bar.dart';
import 'excerciseCatg.dart';

class ExcersisesPage extends StatefulWidget {
  const ExcersisesPage({super.key});

  @override
  State<ExcersisesPage> createState() => _ExcersisesPageState();
}

class _ExcersisesPageState extends State<ExcersisesPage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<ExercisesController>().getExcerF(context, loadingFor: "getAll");
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = Get.find<ExercisesController>();
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return DefaultScaffold(
      currentPage: '/home/ExcersisesPage',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomHeaderBar(
            onBack: () => Navigator.pop(context),
            centerTitle: false,
            title: 'Excercises',
          ),
          Obx(
            () => p.loadingFor == "refresh" || p.loadingFor == "getAll"
                ? QuickTikTokLoader()
                : SizedBox.shrink(),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              SizedBox(height: Screen.height(context) * 0.02),
              const Text(
                'LEVELS',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: Screen.isTablet(context) && !Screen.isLandscape(context)
                    ? Screen.height(context) * 0.1
                    : Screen.height(context) * 0.02,
                // height: Screen.isPhone(context) && Screen.isLandscape(context)
                //     ? Screen.height(context) * 0.02
                //     : 50,
              ),
              (p.excersiseList.isEmpty ||
                      p.excersiseList.first.allowedLessonCategory.isEmpty)
                  ? EmptyWidget(
                      paddingTop:
                          Screen.isPhone(context) && Screen.isLandscape(context)
                          ? 5
                          : 30,
                    )
                  : Center(
                      child: SizedBox(
                        width: Screen.isPhone(context)
                            ? Screen.width(context) * 0.8
                            : MediaQuery.of(context).size.width * 0.4,
                        height:
                            Screen.isTablet(context) &&
                                !Screen.isLandscape(context)
                            ? Screen.height(context) * 0.6
                            : Screen.height(context) * 0.7,

                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 30,
                                mainAxisSpacing: 15,
                              ),
                          shrinkWrap: true,
                          controller: ScrollController(),
                          itemCount: p
                              .excersiseList
                              .first
                              .allowedLessonCategory
                              .length,
                          itemBuilder: (context, index) {
                            var data = p
                                .excersiseList
                                .first
                                .allowedLessonCategory[index];
                            bool isLocked =
                                p.excersiseList.first.userLevel.index < index;
                            return InkWell(
                              onTap:
                                  // isLocked
                                  //     ? null
                                  //     :
                                  () {
                                    p.getExcercisesCatgLessonsStepsF(
                                      context,
                                      // catgRef: data.reference.toString(),
                                      catgRef: data.reference
                                          // .toUpperCase()
                                          .toString(),
                                      loadingFor: "getExcercisesByCatg",
                                    );
                                    final navCtrl =
                                        Get.find<NavigationArgsController>();
                                    navCtrl.exerciseLabelTitle =
                                        data.label[0].toUpperCase() +
                                        data.label.substring(1);
                                    Get.to(() => const ExcerciseCatgPage());
                                  },
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: isLocked
                                            ? [
                                                Colors.orange.shade200
                                                    .withOpacity(0.5),
                                                Colors.orange.shade200
                                                    .withOpacity(0.5),
                                                Colors.deepOrange.shade300
                                                    .withOpacity(0.5),
                                                Colors.red.withOpacity(0.5),
                                                Colors.red.shade800.withOpacity(
                                                  0.5,
                                                ),
                                              ]
                                            : [
                                                Colors.orange.shade200,
                                                Colors.orange.shade200,
                                                Colors.deepOrange.shade300,
                                                Colors.red,
                                                Colors.red.shade800,
                                              ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(40),
                                      child: Center(
                                        child: Text(
                                          data.label[0].toUpperCase() +
                                              data.label.substring(1),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isLocked)
                                    const Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(Icons.lock_clock),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
