import 'package:edutainment/constants/screenssize.dart';
import 'package:edutainment/providers/exercisesVm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import '../../widgets/emptyWIdget.dart';
import '../../widgets/header_bar/custom_header_bar.dart';
import '../../widgets/ui/default_scaffold.dart';

class ExcerciseCatgPage extends ConsumerStatefulWidget {
  final String labelTitle;
  const ExcerciseCatgPage({super.key, this.labelTitle = ''});

  @override
  ConsumerState<ExcerciseCatgPage> createState() => _ExcerciseCatgPageState();
}

class _ExcerciseCatgPageState extends ConsumerState<ExcerciseCatgPage> {
  @override
  Widget build(BuildContext context) {
    // var p = ref.watch(excerVm);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    // Get the extra data passed from GoRouter
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final labelTitleCheck = extra?['labelTitle'] ?? widget.labelTitle;
    String labelTitle = labelTitleCheck.toString().isEmpty
        ? ""
        : labelTitleCheck.toString();

    return DefaultScaffold(
      currentPage: '/home/ExcersisesPage/ExcerciseCatgPage',
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            CustomHeaderBar(
              onBack: () => Navigator.pop(context),
              centerTitle: false,
              title: 'Excercises',
            ),
            ref.watch(excerVm).loadingFor == "refresh" ||
                    ref.watch(excerVm).loadingFor == "getExcercisesByCatg"
                ? QuickTikTokLoader()
                : SizedBox.shrink(),
            ref.watch(excerVm).excercisesCatgLessonsSteps == null
                ? EmptyWidget(paddingTop: h * 0.25)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: w,
                        padding: const EdgeInsets.symmetric(
                          vertical: 7,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFf9bf13),
                              Color(0xFFf1711c),
                              Color(0xFFf82424),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            labelTitle.toUpperCase(),
                            style: t.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10,
                        ),
                        child: Stack(
                          children: [
                            // Vertical line in the center
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 2,
                                color: Colors.blueAccent,
                              ),
                            ),

                            // Timeline items
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: ref
                                  .watch(excerVm)
                                  .excercisesCatgLessonsSteps!
                                  .data
                                  .lessons
                                  .length,
                              controller: ScrollController(),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, index) {
                                var data = ref
                                    .watch(excerVm)
                                    .excercisesCatgLessonsSteps!
                                    .data
                                    .lessons[index];
                                if (index.isOdd) {
                                  return lessonsToolTip(
                                    left: data.label.split(":").first,
                                    isCompleted: data.completed,
                                    onTap: () {
                                      context.go(
                                        "/home/ExcersisesPage/ExcerciseByCatgQAPage",
                                        extra: {
                                          "q": data.questions,
                                          "labelTitle": widget.labelTitle,
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  return lessonsToolTip(
                                    right: data.label.split(":").first,
                                    isCompleted: data.completed,
                                    onTap: () {
                                      context.go(
                                        "/home/ExcersisesPage/ExcerciseByCatgQAPage",
                                        extra: {
                                          "q": data.questions,
                                          "labelTitle": widget.labelTitle,
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget lessonsToolTip({
    String left = "",
    String right = "",
    bool isCompleted = false,
    Function? onTap,
  }) {
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left box
          if (left.isNotEmpty)
            InkWell(
              onTap: () {
                if (onTap != null) {
                  onTap();
                }
              },
              child: Container(
                width: w * 0.35,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: isCompleted
                        ? [
                            Color.fromARGB(255, 223, 255, 201),
                            Color.fromARGB(255, 200, 255, 155),
                          ]
                        : [
                            Color.fromARGB(255, 255, 204, 201),
                            Color.fromARGB(255, 255, 155, 155),
                          ],
                  ),
                ),
                child: Center(
                  child: Text(
                    left,
                    style: TextStyle(
                      color: isCompleted ? Colors.green : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          else
            SizedBox(width: w * 0.35),

          // Blue dot in the middle
          Stack(
            alignment: Alignment.center,
            children: [
              // vertical line
              SizedBox(
                height: 70,
                child: VerticalDivider(
                  color: isCompleted
                      ? Colors.blueAccent
                      : Colors.blue.withOpacity(0.4),
                  thickness: 1,
                  width: 2,
                ),
              ),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.blueAccent
                      : Colors.blue.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          // Right box
          if (right.isNotEmpty)
            InkWell(
              onTap: () {
                if (onTap != null) {
                  onTap();
                }
              },
              child: Container(
                width: w * 0.35,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: isCompleted
                        ? [
                            Color.fromARGB(255, 223, 255, 201),
                            Color.fromARGB(255, 200, 255, 155),
                          ]
                        : [
                            Color.fromARGB(255, 255, 204, 201),
                            Color.fromARGB(255, 255, 155, 155),
                          ],
                  ),
                ),
                child: Center(
                  child: Text(
                    right,
                    style: TextStyle(
                      color: isCompleted ? Colors.green : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          else
            SizedBox(width: w * 0.35),
        ],
      ),
    );
  }
}
