import 'tests_quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../core/loader.dart';
import '../../icons/icons_light.dart';
import '../../theme/colors.dart';
import '../../utils/boxes.dart';
import '../../utils/utils.dart';

class TestsListComponent extends StatefulWidget {
  const TestsListComponent({super.key});

  @override
  State<TestsListComponent> createState() => _TestsListComponent();
}

class _TestsListComponent extends State<TestsListComponent> {
  final dynamic quizz = quizBox.get('quizz') ?? [];
  final dynamic quizCategory = quizBox.get('quizCategory');
  final dynamic quizType = quizBox.get('type');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var quiz in quizz)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/backgrounds/bg_cell.png',
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    GestureDetector(
                      onTap: () async {
                        EasyLoading.show();
                        await cleanQuiz();
                        await fetchQuizStart(quiz['_id']);
                        EasyLoading.dismiss();
                        if (context.mounted) {
                          Get.to(() => const TestsQuizPage());
                        }
                      },
                      child: Container(
                        // margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:
                              (quizType == 'training'
                                      ? ColorsPallet.blueAccent
                                      : Colors.red.withOpacity(0.7))
                                  .withOpacity(.8),
                          borderRadius: BorderRadius.circular(6),
                        ),
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
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(AppIconsLight.chevronRight),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 6),
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
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Duration',
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                            '${getIn(quiz, 'totalAttempts', 0)}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Total Attempts',
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Last Attempts',
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${getIn(quiz, 'bestTotalScore', 0)}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          'Best score',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 10),
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
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
