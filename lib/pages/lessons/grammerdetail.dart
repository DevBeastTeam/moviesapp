import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/constants/screenssize.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:html_to_flutter/html_to_flutter.dart';
// import 'package:get/get.dart';

import '../../models/grammerModel.dart';
import '../../providers/grammerVm.dart';
import '../../widgets/header_bar/custom_header_bar.dart';
import '../../widgets/loaders/dotloader.dart';

class GrammerDetailPage extends ConsumerStatefulWidget {
  // final List<Lesson> labelsLessons;

  const GrammerDetailPage({
    super.key,
    //
    // this.labelsLessons = const []
    //
  });

  @override
  ConsumerState<GrammerDetailPage> createState() => _GrammerDetailPageState();
}

class _GrammerDetailPageState extends ConsumerState<GrammerDetailPage> {
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
  //         var p = ref.watch(grammerData);

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
    ref.watch(grammerData).stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(grammerData);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isTablet =
        mediaQuery.size.shortestSide >= 600; // Common tablet threshold

    // var lessonDetailData = p.grammerSingleData.isNotEmpty
    //     ? p.grammerSingleData[0]
    //     : GrammerDetailModel();

    final extra = Get.arguments as Map<String, dynamic>?;

    if (extra == null) {
      return const Scaffold(
        body: Center(child: Text("Should Pass Extra Data")),
      );
    }

    final catgName = extra['catgName'] as String;
    final subCatgName = extra['subCatgName'] as String;
    final subLessons = extra['subLessons'] as List<Lesson>;
    final lesson = extra['selectedLesson'] as Lesson;

    return DefaultScaffold(
      currentPage: '/home/GrammerPage/grammerCatg/grammerDetail',
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
          Text(catgName, style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // if (isTablet && isLandscape)
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       p.isLoadingFor == 'grammerDetails'
          //           ? Padding(
          //               padding: EdgeInsets.only(top: h * 0.45),
          //               child: const Center(child: DotLoader()),
          //             )
          //           : SizedBox(
          //               width: MediaQuery.of(context).size.width * 0.4,
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.circular(10),
          //                 ),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   children: [
          //                     InkWell(
          //                       onTap: () {
          //                         p.setSlectedTabBtnIs = 0;
          //                         p.stopTimer();
          //                       },
          //                       borderRadius: BorderRadius.circular(15),
          //                       child: Container(
          //                         width:
          //                             MediaQuery.of(context).size.width * 0.2,
          //                         decoration: BoxDecoration(
          //                           color: Colors.white,
          //                           gradient: LinearGradient(
          //                             colors: [
          //                               p.slectedTabBtnIs == 0
          //                                   ? Colors.orangeAccent
          //                                   : Colors.orangeAccent.withOpacity(
          //                                       0.4,
          //                                     ),
          //                               p.slectedTabBtnIs == 0
          //                                   ? Colors.deepOrange
          //                                   : Colors.deepOrange.withOpacity(
          //                                       0.4,
          //                                     ),
          //                             ],
          //                           ),
          //                           boxShadow: [
          //                             BoxShadow(
          //                               color: Colors.grey.withOpacity(0.5),
          //                               spreadRadius: 2,
          //                               blurRadius: 5,
          //                               offset: const Offset(0, 1),
          //                             ),
          //                           ],
          //                         ),
          //                         child: Center(
          //                           child: Padding(
          //                             padding: const EdgeInsets.symmetric(
          //                               horizontal: 15,
          //                               vertical: 5,
          //                             ),
          //                             child: Text(
          //                               'ENGLISH'.toUpperCase(),
          //                               style: const TextStyle(
          //                                 fontSize: 18,
          //                                 color: Colors.white,
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                     InkWell(
          //                       onTap: () {
          //                         p.setSlectedTabBtnIs = 1;
          //                         p.stopTimer();
          //                       },
          //                       borderRadius: BorderRadius.circular(15),
          //                       child: Container(
          //                         width:
          //                             MediaQuery.of(context).size.width * 0.2,
          //                         decoration: BoxDecoration(
          //                           color: Colors.white,
          //                           gradient: LinearGradient(
          //                             colors: [
          //                               p.slectedTabBtnIs == 1
          //                                   ? Colors.orangeAccent
          //                                   : Colors.orangeAccent.withOpacity(
          //                                       0.4,
          //                                     ),
          //                               p.slectedTabBtnIs == 1
          //                                   ? Colors.deepOrange
          //                                   : Colors.deepOrange.withOpacity(
          //                                       0.4,
          //                                     ),
          //                             ],
          //                           ),
          //                           boxShadow: [
          //                             BoxShadow(
          //                               color: Colors.grey.withOpacity(0.5),
          //                               spreadRadius: 2,
          //                               blurRadius: 5,
          //                               offset: const Offset(0, 1),
          //                             ),
          //                           ],
          //                         ),
          //                         child: Center(
          //                           child: Padding(
          //                             padding: const EdgeInsets.symmetric(
          //                               horizontal: 15,
          //                               vertical: 5,
          //                             ),
          //                             child: Text(
          //                               'FRANÇAIS'.toUpperCase(),
          //                               style: const TextStyle(
          //                                 fontSize: 18,
          //                                 color: Colors.white,
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //       // Spacer(),
          //       p.isLoadingFor == 'grammerDetails'
          //           ? const SizedBox.shrink()
          //           : InkWell(
          //               onTap: () {},
          //               child: Container(
          //                 height: 35,
          //                 width: MediaQuery.of(context).size.width * 0.4,
          //                 decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.circular(20),
          //                 ),
          //                 child: Padding(
          //                   padding: const EdgeInsets.symmetric(horizontal: 20),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Text(
          //                         '${lessonDetailData.lesson!.label}',
          //                         style: const TextStyle(color: Colors.blue),
          //                       ),
          //                       Image.asset(AppImages.check, width: 20),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //     ],
          //   ),
          // if (!isTablet && !isLandscape)
          p.isLoadingFor == 'grammerDetails'
              ? Padding(
                  padding: EdgeInsets.only(top: h * 0.45),
                  child: const Center(child: DotLoader()),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            p.setSlectedTabBtnIs = 0;
                            p.stopTimer();
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              gradient: LinearGradient(
                                colors: [
                                  p.slectedTabBtnIs == 0
                                      ? Colors.orangeAccent
                                      : Colors.orangeAccent.withOpacity(0.4),
                                  p.slectedTabBtnIs == 0
                                      ? Colors.deepOrange
                                      : Colors.deepOrange.withOpacity(0.4),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                child: Text(
                                  'ENGLISH'.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            p.setSlectedTabBtnIs = 1;
                            p.stopTimer();
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              gradient: LinearGradient(
                                colors: [
                                  p.slectedTabBtnIs == 1
                                      ? Colors.orangeAccent
                                      : Colors.orangeAccent.withOpacity(0.4),
                                  p.slectedTabBtnIs == 1
                                      ? Colors.deepOrange
                                      : Colors.deepOrange.withOpacity(0.4),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                child: Text(
                                  'FRANÇAIS'.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

          // if (!isTablet && !isLandscape)
          const SizedBox(height: 10),
          // if (!isTablet && !isLandscape)
          p.isLoadingFor == 'grammerDetails'
              ? const SizedBox.shrink()
              : InkWell(
                  onTap: () {},
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.82,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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

          // Divider(),
          // Text("${lessonDetailData.lesson!.contenten}", style: TextStyle(color: Colors.white),),
          // Divider(),
          // Text("${lessonDetailData.lesson!.contentfr}", style: TextStyle(color: Colors.white),),
          // Divider(),
          const SizedBox(height: 20),

          if (Screen.isPhone(context) || (isTablet && !isLandscape))
            Column(
              // direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                p.isLoadingFor == 'grammerDetails'
                    ? const SizedBox.shrink()
                    : Stack(
                        children: [
                          // Image.network(lessonDetailData.lesson!.)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // InkWell(
                              //   onTap: () {
                              //     if (p.sletedLableIndexIs > 0) {
                              //       p.stopTimer();
                              //       p.setSelctedLableIndexIs =
                              //           p.sletedLableIndexIs - 1;
                              //       p.getGrammerSingleByIdF(
                              //         context,
                              //         loadingFor: 'previous',
                              //         id:
                              //             labelsLessons[p.sletedLableIndexIs -
                              //                     1]
                              //                 .id,
                              //       );
                              //     }
                              //   },
                              //   borderRadius: BorderRadius.circular(50),
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(8),
                              //     child: p.isLoadingFor == 'previous'
                              //         ? const SizedBox(
                              //             width: 20,
                              //             height: 20,
                              //             child:
                              //                 CircularProgressIndicator.adaptive(
                              //                   valueColor:
                              //                       AlwaysStoppedAnimation(
                              //                         Colors.yellow,
                              //                       ),
                              //                   // backgroundColor: Colors.yellow,
                              //                   strokeWidth: 1,
                              //                 ),
                              //           )
                              //         : Icon(
                              //             Icons.replay_10_rounded,
                              //             color: p.sletedLableIndexIs == 0
                              //                 ? Colors.grey
                              //                 : null,
                              //           ),
                              //   ),
                              // ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    p.slectedTabBtnIs == 0
                                        ? AppImages.eng
                                        : AppImages.fr,
                                    width:
                                        Screen.isTablet(context) &&
                                            Screen.isPortrait(context)
                                        ? Screen.width(context) * 0.25
                                        : Screen.width(context) * 0.4,
                                    opacity: AlwaysStoppedAnimation(0.6),
                                  ),
                                  p.isTimerStart == true &&
                                          p.remainingSeconds >= 1
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

                              // InkWell(
                              //   onTap: () {
                              //     p.stopTimer();
                              //     if (p.sletedLableIndexIs <=
                              //         labelsLessons.length) {
                              //       p.setSelctedLableIndexIs =
                              //           p.sletedLableIndexIs + 1;
                              //       p.getGrammerSingleByIdF(
                              //         context,
                              //         loadingFor: 'next',
                              //         id:
                              //             labelsLessons[p.sletedLableIndexIs +
                              //                     1]
                              //                 .id,
                              //       );
                              //     }
                              //   },
                              //   child: Transform.flip(
                              //     flipX: true,
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(8),
                              //       child: p.isLoadingFor == 'next'
                              //           ? const SizedBox(
                              //               width: 20,
                              //               height: 20,
                              //               child: CircularProgressIndicator.adaptive(
                              //                 valueColor:
                              //                     AlwaysStoppedAnimation(
                              //                       Colors.yellow,
                              //                     ),
                              //                 // backgroundColor: Colors.yellow,
                              //                 strokeWidth: 1,
                              //               ),
                              //             )
                              //           : Icon(
                              //               Icons.replay_10_rounded,
                              //               color:
                              //                   p.sletedLableIndexIs ==
                              //                       labelsLessons.length
                              //                   ? Colors.grey
                              //                   : null,
                              //             ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(height: 20),
                // Spacer(),
                Container(
                  height: Screen.isTablet(context) && Screen.isPortrait(context)
                      ? Screen.height(context) * 0.43
                      : Screen.height(context) * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                      child:
                          p.isLoadingFor == 'next' ||
                              p.isLoadingFor == 'previous'
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
                                // Text('Daily Greeting',
                                //     style:
                                //         TextStyle(color: Colors.black, fontSize: 18)),
                                // SizedBox(height: 20),
                                // Text('Year: 1 Time, 2 Hours',
                                //     style:
                                //         TextStyle(color: Colors.black, fontSize: 18)),
                                // SizedBox(height: 20),
                                // Text(
                                //     'Competency , /Objective: i can great people appropriatley at any time of day.',
                                //     style:
                                //         TextStyle(color: Colors.black, fontSize: 18)),
                                // SizedBox(height: 20),
                                // Text(
                                //     'Motivation Draw this diagram o the board and students copy.',
                                //     style:
                                //         TextStyle(color: Colors.black, fontSize: 18)),
                                // SizedBox(height: 20),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),

          if (isTablet && isLandscape)
            Row(
              // direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // height: double.infinity,
                  width: Screen.width(context) * 0.55,
                  height: Screen.width(context) * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                      child:
                          p.isLoadingFor == 'next' ||
                              p.isLoadingFor == 'previous'
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
                                // Text('Daily Greeting',
                                //     style:
                                //         TextStyle(color: Colors.black, fontSize: 18)),
                                // SizedBox(height: 20),
                                // Text('Year: 1 Time, 2 Hours',
                                //     style:
                                //         TextStyle(color: Colors.black, fontSize: 18)),
                                // SizedBox(height: 20),
                                // Text(
                                //     'Competency , /Objective: i can great people appropriatley at any time of day.',
                                //     style:
                                //         TextStyle(color: Colors.black, fontSize: 18)),
                                // SizedBox(height: 20),
                                // Text(
                                //     'Motivation Draw this diagram o the board and students copy.',
                                //     style:
                                //         TextStyle(color: Colors.black, fontSize: 18)),
                                // SizedBox(height: 20),
                              ],
                            ),
                    ),
                  ),
                ),

                p.isLoadingFor == 'grammerDetails'
                    ? const SizedBox.shrink()
                    : Stack(
                        children: [
                          // Image.network(lessonDetailData.lesson!.)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // InkWell(
                              //   onTap: () {
                              //     if (p.sletedLableIndexIs > 0) {
                              //       p.stopTimer();

                              //       p.setSelctedLableIndexIs =
                              //           p.sletedLableIndexIs - 1;
                              //       // p.getGrammerSingleByIdF(
                              //       //   context,
                              //       //   loadingFor: 'previous',
                              //       //   id:
                              //       //       labelsLessons[p.sletedLableIndexIs -
                              //       //               1]
                              //       //           .id,
                              //       // );
                              //     }
                              //   },
                              //   borderRadius: BorderRadius.circular(50),
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(8),
                              //     child: p.isLoadingFor == 'previous'
                              //         ? const SizedBox(
                              //             width: 20,
                              //             height: 20,
                              //             child:
                              //                 CircularProgressIndicator.adaptive(
                              //                   valueColor:
                              //                       AlwaysStoppedAnimation(
                              //                         Colors.yellow,
                              //                       ),
                              //                   // backgroundColor: Colors.yellow,
                              //                   strokeWidth: 1,
                              //                 ),
                              //           )
                              //         : Icon(
                              //             Icons.replay_10_rounded,
                              //             color: p.sletedLableIndexIs == 0
                              //                 ? Colors.grey
                              //                 : null,
                              //           ),
                              //   ),
                              // ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Image.asset(
                                      p.slectedTabBtnIs == 0
                                          ? AppImages.eng
                                          : AppImages.fr,
                                      width: Screen.width(context) * 0.35,
                                      opacity: AlwaysStoppedAnimation(0.6),
                                    ),
                                  ),
                                  p.isTimerStart == true &&
                                          p.remainingSeconds >= 1
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
                                              // lessonsForLoop: subLessons,
                                            );
                                          },
                                          child: Image.asset(
                                            AppImages.playericon,
                                            width: 70,
                                          ),
                                        ),
                                ],
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     p.stopTimer();

                              //     // if (p.sletedLableIndexIs <=
                              //     //     labelsLessons.length) {
                              //     //   p.setSelctedLableIndexIs =
                              //     //       p.sletedLableIndexIs + 1;
                              //     //   p.getGrammerSingleByIdF(
                              //     //     context,
                              //     //     loadingFor: 'next',
                              //     //     id:
                              //     //         labelsLessons[p.sletedLableIndexIs +
                              //     //                 1]
                              //     //             .id,
                              //     //   );
                              //     // }
                              //   },
                              //   child: Transform.flip(
                              //     flipX: true,
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(8),
                              //       child: p.isLoadingFor == 'next'
                              //           ? const SizedBox(
                              //               width: 20,
                              //               height: 20,
                              //               child: CircularProgressIndicator.adaptive(
                              //                 valueColor:
                              //                     AlwaysStoppedAnimation(
                              //                       Colors.yellow,
                              //                     ),
                              //                 // backgroundColor: Colors.yellow,
                              //                 strokeWidth: 1,
                              //               ),
                              //             )
                              //           : Icon(
                              //               Icons.replay_10_rounded,
                              //               // color:
                              //               //     p.sletedLableIndexIs ==
                              //               //         labelsLessons.length
                              //               //     ? Colors.grey
                              //               //     : null,
                              //             ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
        ],
      ),
    );
  }
}
