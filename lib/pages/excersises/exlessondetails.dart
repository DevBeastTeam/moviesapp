import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/exercisesVm.dart';
import '../../widgets/header_bar/custom_header_bar.dart';
import '../../widgets/loaders/dotloader.dart';

class ExLessonQuestionPage extends ConsumerStatefulWidget {
  final String labelTitle;
  const ExLessonQuestionPage({super.key, this.labelTitle = ''});

  @override
  ConsumerState<ExLessonQuestionPage> createState() =>
      _ExLessonQuestionPageState();
}

class _ExLessonQuestionPageState extends ConsumerState<ExLessonQuestionPage> {
  @override
  Widget build(BuildContext context) {
    var p = ref.watch(excerVm);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return DefaultScaffold(
      currentPage: '',
      child:
          // p.isLoading
          //     ? Padding(
          //         padding: EdgeInsets.only(top: h * 0.35),
          //         child: const Center(child: DotLoader()))
          //     : p.excersiseList.isEmpty
          //         ? Padding(
          //             padding: EdgeInsets.only(top: h * 0.35),
          //             child: Center(
          //                 child: Text('Empty',
          //                     style: t.titleMedium!.copyWith(
          //                         color: Colors.orange,
          //                         fontWeight: FontWeight.bold,
          //                         letterSpacing: 2))))
          //         :
          Column(
            children: [
              CustomHeaderBar(
                onBack: () async {
                  // context.pop();
                  // Get.back();
                  Navigator.pop(context);
                },
                centerTitle: false,
                title: widget.labelTitle,
              ),
              0 == 0
                  ? Padding(
                      padding: EdgeInsets.only(top: h * 0.35),
                      child: const Center(child: DotLoader()),
                    )
                  : Column(
                      children: [
                        ///////////////
                        Container(
                          height: 90,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 210, 206),
                                Color.fromARGB(255, 255, 156, 156),
                              ],
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Lesson  1 \n Time \n Question 1/4',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Image.asset(AppImages.video1),
                        const SizedBox(height: 30),
                        const Text(
                          '....she going to the worresturaent after work ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 100),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                'Answer A',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                'Answer B',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                'Answer C',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                'Answer D',
                                style: TextStyle(color: Colors.blue),
                              ),
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
