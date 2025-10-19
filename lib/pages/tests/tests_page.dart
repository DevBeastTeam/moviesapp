import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import '../../constants/screenssize.dart';
import '../../core/loader.dart';
import '../../theme/colors.dart';
import '../../utils/boxes.dart';
import '../../widgets/top_bar/topBar.dart';
import '../../widgets/ui/default_scaffold.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({super.key});

  @override
  State<TestsPage> createState() => _TestsPage();
}

class _TestsPage extends State<TestsPage> {
  final dynamic quizCategories = quizBox.get('quizCategories') ?? [];

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: 'tests',
      hideBottomBar: Screen.isTablet(context) || Screen.isLandscape(context),
      child: Column(
        children: [
          Screen.isTablet(context) || Screen.isLandscape(context)
              ? TopBarWidget(paddingLeft: 0)
              : SizedBox.shrink(),
          AppBar(
            leading: null,
            centerTitle: true,
            title: const Text(
              'Quiz',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            backgroundColor: ColorsPallet.darkBlue,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var category in quizCategories)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        // padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: ColorsPallet.blueComponent,
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () async {
                            EasyLoading.show();
                            await fetchQuizz(category['_id'], 'training');
                            EasyLoading.dismiss();
                            if (context.mounted) {
                              context.go('/tests/base');
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 12),
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 8,
                            ),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  category['label'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                const Text(
                                  'Open',
                                  style: TextStyle(
                                    color: ColorsPallet.blueComponent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    // for (var category in quizCategories)
                    //   Container(
                    //     margin: const EdgeInsets.all(20),
                    //     color: ColorsPallet.darkComponentBackground,
                    //     child: Column(
                    //       children: [
                    //         Container(
                    //           padding: const EdgeInsets.only(top: 20),
                    //           child: Text(
                    //             category['label'],
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontWeight: Theme.of(context)
                    //                     .textTheme
                    //                     .titleMedium
                    //                     ?.fontWeight!,
                    //                 fontSize: Theme.of(context)
                    //                     .textTheme
                    //                     .titleMedium!
                    //                     .fontSize!),
                    //           ),
                    //         ),
                    //         Container(
                    //           color: ColorsPallet.blueComponent,
                    //           margin: const EdgeInsets.only(top: 20),
                    //           padding:
                    //               const EdgeInsets.only(top: 20, bottom: 20),
                    //           child: Row(
                    //             children: [
                    //               Expanded(
                    //                 child: GestureDetector(
                    //                   behavior: HitTestBehavior.translucent,
                    //                   onTap: () async {
                    //                     await fetchQuizz(
                    //                         category['_id'], 'training');
                    //                     if (context.mounted) {
                    //                       context.go('/tests/list');
                    //                     }
                    //                   },
                    //                   child: const Center(
                    //                     child: Text('TRAINING'),
                    //                   ),
                    //                 ),
                    //               ),
                    //               Expanded(
                    //                 child: GestureDetector(
                    //                   behavior: HitTestBehavior.translucent,
                    //                   onTap: () async {
                    //                     await fetchQuizz(
                    //                         category['_id'], 'examination');
                    //                     if (context.mounted) {
                    //                       context.go('/tests/list');
                    //                     }
                    //                   },
                    //                   child: const Center(
                    //                     child: Text('EXAM'),
                    //                   ),
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
