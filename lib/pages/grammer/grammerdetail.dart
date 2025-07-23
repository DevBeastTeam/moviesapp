import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/models/grammerDetailModel.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_to_flutter/html_to_flutter.dart';
// import 'package:get/get.dart';

import '../../models/grammerModel.dart';
import 'grammerData.dart';
import '../../widgets/header_bar/custom_header_bar.dart';
import '../../widgets/loaders/dotloader.dart';

class GrammerDetailPage extends ConsumerStatefulWidget {
  final List<Lesson> labelsLessons;

  const GrammerDetailPage({super.key, this.labelsLessons = const []});

  @override
  ConsumerState<GrammerDetailPage> createState() => _GrammerDetailPageState();
}

class _GrammerDetailPageState extends ConsumerState<GrammerDetailPage> {
  @override
  Widget build(BuildContext context) {
    var p = ref.watch(grammerData);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    var lessonDetailData = p.grammerSingleData.isNotEmpty
        ? p.grammerSingleData[0]
        : GrammerDetailModel();

    return DefaultScaffold(
      currentPage: '',
      child: Column(
        children: [
          CustomHeaderBar(
            onBack: () async {
              // Get.back();
              Navigator.pop(context);
            },
            centerTitle: false,
            title: 'Lessons',
          ),
          ////////////////////
          const Text('DAILY', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          p.isLoading && p.isLoadingFor == ''
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
                                    fontSize: 22,
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
                                    fontSize: 22,
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
          const SizedBox(height: 10),
          p.isLoading && p.isLoadingFor == ''
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
                            '${lessonDetailData.lesson!.label}',
                            style: const TextStyle(color: Colors.blue),
                          ),
                          Image.asset(AppImages.check, width: 20),
                        ],
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 70),
          p.isLoading && p.isLoadingFor == ''
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        if (p.sletedLableIndexIs > 0) {
                          p.setSelctedLableIndexIs = p.sletedLableIndexIs - 1;
                          p.getGrammerSingleByIdF(
                            context,
                            loadingFor: 'preIcon',
                            id: widget
                                .labelsLessons[p.sletedLableIndexIs - 1]
                                .id,
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: p.isLoading && p.isLoadingFor == 'preIcon'
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator.adaptive(
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.yellow,
                                  ),
                                  // backgroundColor: Colors.yellow,
                                  strokeWidth: 1,
                                ),
                              )
                            : Icon(
                                Icons.replay_10_rounded,
                                color: p.sletedLableIndexIs == 0
                                    ? Colors.grey
                                    : null,
                              ),
                      ),
                    ),
                    Image.asset(AppImages.playericon, width: 70),
                    InkWell(
                      onTap: () {
                        if (p.sletedLableIndexIs <=
                            widget.labelsLessons.length) {
                          p.setSelctedLableIndexIs = p.sletedLableIndexIs + 1;
                          p.getGrammerSingleByIdF(
                            context,
                            loadingFor: 'next',
                            id: widget
                                .labelsLessons[p.sletedLableIndexIs + 1]
                                .id,
                          );
                        }
                      },
                      child: Transform.flip(
                        flipX: true,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: p.isLoading && p.isLoadingFor == 'next'
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator.adaptive(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.yellow,
                                    ),
                                    // backgroundColor: Colors.yellow,
                                    strokeWidth: 1,
                                  ),
                                )
                              : Icon(
                                  Icons.replay_10_rounded,
                                  color:
                                      p.sletedLableIndexIs ==
                                          widget.labelsLessons.length
                                      ? Colors.grey
                                      : null,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 70),
          p.isLoading && p.isLoadingFor == ''
              ? const SizedBox.shrink()
              : Expanded(
                  child: Container(
                    // height: double.infinity,
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
                        child: Column(
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
                              data: '${lessonDetailData.lesson!.content}',
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
                ),
        ],
      ),
    );
  }
}
