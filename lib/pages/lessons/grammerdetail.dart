import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/constants/screenssize.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:html_to_flutter/html_to_flutter.dart';
import '../../controllers/grammer_controller.dart';
import '../../controllers/navigation_args_controller.dart';
import '../../widgets/header_bar/custom_header_bar.dart';
import '../../widgets/loaders/dotloader.dart';

class GrammerDetailPage extends StatefulWidget {
  // final List<Lesson> labelsLessons;

  const GrammerDetailPage({
    super.key,
    //
    // this.labelsLessons = const []
    //
  });

  @override
  State<GrammerDetailPage> createState() => _GrammerDetailPageState();
}

class _GrammerDetailPageState extends State<GrammerDetailPage> {
  bool _isPopping = false;
  // Timer? timer;
  // int remainingSeconds = 30;
  // bool isTimerStart = false;

  // playTimer() async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await Timer.periodic(Duration(seconds: 1), (v) {
  //       print("hgjkl");
  //       if (remainingSeconds <= 1) {
  //         remainingSeconds = 30;
  //         isTimerStart = false;
  //       } else {
  //         remainingSeconds--;

  //         if (p.sletedLableIndexIs <= labelsLessons.length) {
  //           p.setSelctedLableIndexIs = p.sletedLableIndexIs + 1;
  //           p.getGrammerSingleByIdF(
  //             context,
  //             loadingFor: 'next',
  //             id: labelsLessons[p.sletedLableIndexIs + 1].id,
  //           );
  //         }
  //       }

  //       isTimerStart = false;
  //       //
  //       setState(() {});
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
    Get.find<GrammerController>().stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    final p = Get.find<GrammerController>();
    var h = MediaQuery.of(context).size.height;

    // var lessonDetailData = p.grammerSingleData.isNotEmpty
    //     ? p.grammerSingleData[0]
    //     : GrammerDetailModel();

    final navCtrl = Get.find<NavigationArgsController>();
    final catgName = navCtrl.grammerCatgName;
    final subCatgName = navCtrl.grammerSubCatgName;

    final lesson = navCtrl.grammerSelectedLesson;

    if (lesson == null) {
      return const Scaffold(
        body: Center(child: Text("Should Pass Extra Data")),
      );
    }

    return DefaultScaffold(
      currentPage: '/home/GrammerPage/grammerCatg/grammerDetail',
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            CustomHeaderBar(
              onBack: () {
                if (_isPopping) return;
                _isPopping = true;
                p.stopTimer();
                Navigator.pop(context);
                // Navigator.pop(context);
              },
              centerTitle: false,
              title: 'Select A Lesson',
            ),
            ////////////////////
            Text(
              navCtrl.grammerSubCatgName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 5),

            Obx(
              () => p.loadingFor == 'grammerDetails'
                  ? Padding(
                      padding: EdgeInsets.only(top: h * 0.45),
                      child: const Center(child: DotLoader()),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                p.setSlectedTabBtnIs = 0;
                                p.stopTimer();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                child: SizedBox(
                                  width: Screen.width(context) * 0.35,
                                  child: Center(child: Text("ENGLISH")),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                p.setSlectedTabBtnIs = 1;
                                p.stopTimer();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                child: SizedBox(
                                  width: Screen.width(context) * 0.35,
                                  child: Center(child: Text("FRANÇAIS")),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 4,
                              width: Screen.width(context) * 0.5,
                              decoration: BoxDecoration(
                                gradient: p.slectedTabBtnIs == 0
                                    ? LinearGradient(
                                        colors: [
                                          Colors.deepOrange,
                                          Colors.orange,
                                        ],
                                      )
                                    : LinearGradient(
                                        colors: [Colors.white, Colors.white],
                                      ),
                              ),
                            ),
                            Container(
                              height: 4,
                              width: Screen.width(context) * 0.5,
                              decoration: BoxDecoration(
                                gradient: p.slectedTabBtnIs == 1
                                    ? LinearGradient(
                                        colors: [
                                          Colors.deepOrange,
                                          Colors.orange,
                                        ],
                                      )
                                    : LinearGradient(
                                        colors: [Colors.white, Colors.white],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),

            // if (!isTablet && !isLandscape)
            const SizedBox(height: 10),
            // if (!isTablet && !isLandscape)
            Obx(
              () => p.loadingFor == 'grammerDetails'
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: () {},
                      child: Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                subCatgName,
                                // lessonDetailData != null
                                //     ? '${lessonDetailData.lesson!.label}'
                                //     : "Empty",
                                style: const TextStyle(color: Colors.blue),
                              ),

                              p.lessonReadedId == lesson.id
                                  ? Image.asset(AppImages.check, width: 20)
                                        .animate(
                                          onPlay: (controller) =>
                                              controller.repeat(reverse: true),
                                        )
                                        .scale(
                                          begin: Offset(0.7, 0.7),
                                          end: Offset(1, 1),
                                        )
                                  : !lesson.isRead
                                  ? Image.asset(AppImages.uncheck, width: 20)
                                  : Image.asset(AppImages.check, width: 20)
                                        .animate(
                                          onPlay: (controller) =>
                                              controller.repeat(reverse: true),
                                        )
                                        .scale(
                                          begin: Offset(0.7, 0.7),
                                          end: Offset(1, 1),
                                        ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            // if (Screen.isPhone(context) ||
            //     (Screen.isTablet(context) && !Screen.isLandscape(context)))
            Obx(
              () => p.loadingFor == 'grammerDetails'
                  ? const SizedBox.shrink()
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          p.slectedTabBtnIs == 0 ? AppImages.eng : AppImages.fr,
                          width: Screen.isTablet(context)
                              ? Screen.width(context) * 0.7
                              : Screen.width(context) * 0.8,
                          height: Screen.isTablet(context)
                              ? Screen.height(context) * 0.25
                              : Screen.height(context) * 0.2,
                          opacity: AlwaysStoppedAnimation(0.6),
                          fit: BoxFit.cover,
                        ),
                        p.isTimerStart == true && p.remainingSeconds >= 1
                            ? GestureDetector(
                                onTap: () {
                                  p.stopTimer();
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "${p.remainingSeconds}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(2, 2),
                                            blurRadius: 5,
                                          ),
                                        ],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Image.asset(
                                      AppImages.pause,
                                      width: 70,
                                      color: Colors.yellow,
                                    ),
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  p.playTimer(
                                    context,
                                    lessonReadingId: lesson.id,
                                    // labelsLessons: labelsLessons,
                                  );
                                },
                                child: Image.asset(
                                  AppImages.playericon,
                                  width: 70,
                                ),
                              ),
                      ],
                    ),
            ),
            const SizedBox(height: 20),
            // Spacer(),
            Container(
              // height: Screen.isTablet(context) && Screen.isPortrait(context)
              //     ? Screen.height(context) * 0.43
              //     : Screen.height(context) * 0.4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Obx(
                    () => p.loadingFor == 'next' || p.loadingFor == 'previous'
                        ? Center(child: const DotLoader())
                        : Column(
                            children: [
                              // Text("${lessonDetailData.lesson!}"),
                              Html(
                                config: HtmlConfig(
                                  styleOverrides: const {
                                    'p': Style(color: Colors.black),
                                    'div': Style(color: Colors.black),
                                  },
                                  // defaultColor: Colors.black,
                                  onTap: (url, [attributes, element]) {},
                                ),
                                padding: const EdgeInsets.all(10),
                                renderMode: RenderMode.column,
                                data: p.slectedTabBtnIs == 0
                                    ? lesson.contenten
                                    : lesson.contentfr,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),

            // if (Screen.isTablet(context) && Screen.isLandscape(context))
            //   Row(
            //     // direction: Axis.horizontal,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     // crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Container(
            //         // height: double.infinity,
            //         width: Screen.width(context) * 0.55,
            //         height: Screen.width(context) * 0.5,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(20),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.grey.withOpacity(0.5),
            //               spreadRadius: 2,
            //               blurRadius: 5,
            //               offset: const Offset(0, 1),
            //             ),
            //           ],
            //         ),
            //         child: Padding(
            //           padding: const EdgeInsets.all(14),
            //           child: SingleChildScrollView(
            //             controller: ScrollController(),
            //             child:
            //                 p.loadingFor == 'next' || p.loadingFor == 'previous'
            //                 ? Center(child: const DotLoader())
            //                 : Column(
            //                     children: [
            //                       // Text("${lessonDetailData.lesson!}"),
            //                       Html(
            //                         config: HtmlConfig(
            //                           styleOverrides: const {
            //                             'p': Style(color: Colors.black),
            //                             'div': Style(color: Colors.black),
            //                           },
            //                           // defaultColor: Colors.black,
            //                           onTap: (url, [attributes, element]) {},
            //                         ),
            //                         padding: const EdgeInsets.all(10),
            //                         renderMode: RenderMode.column,
            //                         data: p.slectedTabBtnIs == 0
            //                             ? lesson.contenten
            //                             : lesson.contentfr,
            //                       ),
            //                       // Text('Daily Greeting',
            //                       //     style:
            //                       //         TextStyle(color: Colors.black, fontSize: 18)),
            //                       // SizedBox(height: 20),
            //                       // Text('Year: 1 Time, 2 Hours',
            //                       //     style:
            //                       //         TextStyle(color: Colors.black, fontSize: 18)),
            //                       // SizedBox(height: 20),
            //                       // Text(
            //                       //     'Competency , /Objective: i can great people appropriatley at any time of day.',
            //                       //     style:
            //                       //         TextStyle(color: Colors.black, fontSize: 18)),
            //                       // SizedBox(height: 20),
            //                       // Text(
            //                       //     'Motivation Draw this diagram o the board and students copy.',
            //                       //     style:
            //                       //         TextStyle(color: Colors.black, fontSize: 18)),
            //                       // SizedBox(height: 20),
            //                     ],
            //                   ),
            //           ),
            //         ),
            //       ),

            //       Obx(
            //         () => p.loadingFor == 'grammerDetails'
            //             ? const SizedBox.shrink()
            //             : Stack(
            //                 children: [
            //                   // Image.network(lessonDetailData.lesson!.)
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       // InkWell(
            //                       //   onTap: () {
            //                       //     if (p.sletedLableIndexIs > 0) {
            //                       //       p.stopTimer();

            //                       //       p.setSelctedLableIndexIs =
            //                       //           p.sletedLableIndexIs - 1;
            //                       //       // p.getGrammerSingleByIdF(
            //                       //       //   context,
            //                       //       //   loadingFor: 'previous',
            //                       //       //   id:
            //                       //       //       labelsLessons[p.sletedLableIndexIs -
            //                       //       //               1]
            //                       //       //           .id,
            //                       //       // );
            //                       //     }
            //                       //   },
            //                       //   borderRadius: BorderRadius.circular(50),
            //                       //   child: Padding(
            //                       //     padding: const EdgeInsets.all(8),
            //                       //     child: p.isLoadingFor == 'previous'
            //                       //         ? const SizedBox(
            //                       //             width: 20,
            //                       //             height: 20,
            //                       //             child:
            //                       //                 CircularProgressIndicator.adaptive(
            //                       //                   valueColor:
            //                       //                       AlwaysStoppedAnimation(
            //                       //                         Colors.yellow,
            //                       //                       ),
            //                       //                   // backgroundColor: Colors.yellow,
            //                       //                   strokeWidth: 1,
            //                       //                 ),
            //                       //           )
            //                       //         : Icon(
            //                       //             Icons.replay_10_rounded,
            //                       //             color: p.sletedLableIndexIs == 0
            //                       //                 ? Colors.grey
            //                       //                 : null,
            //                       //           ),
            //                       //   ),
            //                       // ),
            //                       Stack(
            //                         alignment: Alignment.center,
            //                         children: [
            //                           Padding(
            //                             padding: const EdgeInsets.only(
            //                               right: 8.0,
            //                             ),
            //                             child: Image.asset(
            //                               p.slectedTabBtnIs == 0
            //                                   ? AppImages.eng
            //                                   : AppImages.fr,
            //                               width: Screen.width(context) * 0.35,
            //                               opacity: AlwaysStoppedAnimation(0.6),
            //                             ),
            //                           ),
            //                           p.isTimerStart == true &&
            //                                   p.remainingSeconds >= 1
            //                               ? GestureDetector(
            //                                   onTap: () {
            //                                     p.stopTimer();
            //                                   },
            //                                   child: Column(
            //                                     children: [
            //                                       Text(
            //                                         "${p.remainingSeconds}",
            //                                         style: TextStyle(
            //                                           color: Colors.white,
            //                                           shadows: [
            //                                             BoxShadow(
            //                                               color: Colors.black26,
            //                                               offset: Offset(2, 2),
            //                                               blurRadius: 5,
            //                                             ),
            //                                           ],
            //                                           fontWeight: FontWeight.bold,
            //                                           fontSize: 20,
            //                                         ),
            //                                       ),
            //                                       Image.asset(
            //                                         AppImages.pause,
            //                                         width: 70,
            //                                         color: Colors.yellow,
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 )
            //                               : InkWell(
            //                                   onTap: () {
            //                                     p.playTimer(
            //                                       context,
            //                                       lessonReadingId: lesson.id,
            //                                       // lessonsForLoop: subLessons,
            //                                     );
            //                                   },
            //                                   child: Image.asset(
            //                                     AppImages.playericon,
            //                                     width: 70,
            //                                   ),
            //                                 ),
            //                         ],
            //                       ),
            //                       // InkWell(
            //                       //   onTap: () {
            //                       //     p.stopTimer();

            //                       //     // if (p.sletedLableIndexIs <=
            //                       //     //     labelsLessons.length) {
            //                       //     //   p.setSelctedLableIndexIs =
            //                       //     //       p.sletedLableIndexIs + 1;
            //                       //     //   p.getGrammerSingleByIdF(
            //                       //     //     context,
            //                       //     //     loadingFor: 'next',
            //                       //     //     id:
            //                       //     //         labelsLessons[p.sletedLableIndexIs +
            //                       //     //                 1]
            //                       //     //             .id,
            //                       //     //   );
            //                       //     // }
            //                       //   },
            //                       //   child: Transform.flip(
            //                       //     flipX: true,
            //                       //     child: Padding(
            //                       //       padding: const EdgeInsets.all(8),
            //                       //       child: p.isLoadingFor == 'next'
            //                       //           ? const SizedBox(
            //                       //               width: 20,
            //                       //               height: 20,
            //                       //               child: CircularProgressIndicator.adaptive(
            //                       //                 valueColor:
            //                       //                     AlwaysStoppedAnimation(
            //                       //                       Colors.yellow,
            //                       //                     ),
            //                       //                 // backgroundColor: Colors.yellow,
            //                       //                 strokeWidth: 1,
            //                       //               ),
            //                       //             )
            //                       //           : Icon(
            //                       //               Icons.replay_10_rounded,
            //                       //               // color:
            //                       //               //     p.sletedLableIndexIs ==
            //                       //               //         labelsLessons.length
            //                       //               //     ? Colors.grey
            //                       //               //     : null,
            //                       //             ),
            //                       //     ),
            //                       //   ),
            //                       // ),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //       ),
            //     ],
            //   ),
          ],
        ),
      ),
    );
  }
}
