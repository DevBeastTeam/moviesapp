import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../controllers/quiz_controller.dart';
import 'tests_quiz_page.dart';

class TestsListComponent extends StatefulWidget {
  const TestsListComponent({super.key});

  @override
  State<TestsListComponent> createState() => _TestsListComponent();
}

class _TestsListComponent extends State<TestsListComponent> {
  final QuizController quizController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Obx(() {
          if (quizController.quizzes.isEmpty) {
            return const Center(
              child: Text(
                "No quizzes available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var quiz in quizController.quizzes)
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 6,
                  ),
                  child: Stack(
                    children: [
                      // Image.asset(
                      //   'assets/images/backgrounds/bg_cell.png',
                      //   color: Colors.grey.withOpacity(0.6),
                      // ),
                      GestureDetector(
                        onTap: () async {
                          EasyLoading.show();
                          await quizController.startQuiz(quiz.id);
                          EasyLoading.dismiss();
                          if (context.mounted) {
                            Get.to(() => const TestsQuizPage());
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color:
                                quizController.selectedType.value ==
                                    'examination'
                                ? Colors.white
                                : const Color(0xFF1F334F),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quiz.title,
                                style: TextStyle(
                                  color:
                                      quizController.selectedType.value ==
                                          'examination'
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Column 1: Duration
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${quiz.duration ?? 0} min',
                                          style: TextStyle(
                                            color:
                                                quizController
                                                        .selectedType
                                                        .value ==
                                                    'examination'
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Duration',
                                          style: TextStyle(
                                            color:
                                                quizController
                                                        .selectedType
                                                        .value ==
                                                    'examination'
                                                ? Colors.grey
                                                : Colors.white70,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Column 2: Best Score (Replacing Date as we don't have it)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${quiz.bestTotalScore ?? 0}',
                                          style: TextStyle(
                                            color:
                                                quizController
                                                        .selectedType
                                                        .value ==
                                                    'examination'
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Best score',
                                          style: TextStyle(
                                            color:
                                                quizController
                                                        .selectedType
                                                        .value ==
                                                    'examination'
                                                ? Colors.grey
                                                : Colors.white70,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Column 3: Total Attempts
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${quiz.totalAttempts ?? 0}',
                                          style: TextStyle(
                                            color:
                                                quizController
                                                        .selectedType
                                                        .value ==
                                                    'examination'
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Total attemps',
                                          style: TextStyle(
                                            color:
                                                quizController
                                                        .selectedType
                                                        .value ==
                                                    'examination'
                                                ? Colors.grey
                                                : Colors.white70,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Column 4: Last Score
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${quiz.lastTotalScore ?? 0}',
                                          style: TextStyle(
                                            color:
                                                quizController
                                                        .selectedType
                                                        .value ==
                                                    'examination'
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Last score',
                                          style: TextStyle(
                                            color:
                                                quizController
                                                        .selectedType
                                                        .value ==
                                                    'examination'
                                                ? Colors.grey
                                                : Colors.white70,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
