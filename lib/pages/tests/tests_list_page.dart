import 'tests_quiz_page.dart';
import 'tests_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/loader.dart';
import '../../icons/icons_light.dart';
import '../../theme/colors.dart';
import '../../utils/boxes.dart';
import '../../utils/utils.dart';
import '../../widgets/header_bar/custom_header_bar.dart';
import '../../widgets/ui/default_scaffold.dart';

class TestsListPage extends StatefulWidget {
  const TestsListPage({super.key});

  @override
  State<TestsListPage> createState() => _TestsListPage();
}

class _TestsListPage extends State<TestsListPage> {
  final dynamic quizz = quizBox.get('quizz') ?? [];
  final dynamic quizCategory = quizBox.get('quizCategory');
  final dynamic quizType = quizBox.get('type');

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: 'tests',
      child: SafeArea(
        child: Column(
          children: [
            // CustomHeaderBar(
            //   onBack: () {
            //     Get.to(() => const TestsPage());
            //   },
            //   title: '${getIn(quizCategory, 'label')} - $quizType',
            // ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var quiz in quizz)
                        Container(
                          margin: const EdgeInsets.all(20),
                          color: quizType == 'training'
                              ? ColorsPallet.blueAccent
                              : Colors.red.withOpacity(0.7),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 20,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        quiz['label'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.fontWeight!,
                                          fontSize: Theme.of(
                                            context,
                                          ).textTheme.titleMedium!.fontSize!,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await cleanQuiz();
                                        await fetchQuizStart(quiz['_id']);
                                        if (context.mounted) {
                                          Get.to(() => const TestsQuizPage());
                                        }
                                      },
                                      child: const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(AppIconsLight.chevronRight),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: quizType == 'training'
                                    ? ColorsPallet.blueComponent
                                    : Colors.red.withOpacity(0.8),
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${getIn(quiz, 'duration')} min.',
                                            ),
                                            const Text('Duration'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            '${getIn(quiz, 'totalAttempts', 0)}',
                                          ),
                                          const Text('Total Attempts'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: quizType == 'training'
                                    ? ColorsPallet.blueComponent
                                    : Colors.red.withOpacity(0.8),
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${getIn(quiz, 'lastTotalScore', 0)}',
                                            ),
                                            const Text('Last Attempts'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            '${getIn(quiz, 'bestTotalScore', 0)}',
                                          ),
                                          const Text('Best score'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
  }
}
