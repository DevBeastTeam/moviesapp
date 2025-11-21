import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/quiz_controller.dart';
import '../../theme/colors.dart';
import '../quiz/results/result_page.dart';
import 'tests_page.dart';

class TestsQuizResultsPage extends StatefulWidget {
  const TestsQuizResultsPage({super.key});

  @override
  State<TestsQuizResultsPage> createState() => _TestsQuizResultsPage();
}

class _TestsQuizResultsPage extends State<TestsQuizResultsPage> {
  final QuizController quizController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: Get.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.bottomLeft,
              colors: ColorsPallet.bdb,
            ),
          ),
          child: SafeArea(
            child: Obx(() {
              final result = quizController.quizResult.value;
              if (result == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final quizData =
                  result.quiz?.toJson() ??
                  quizController.currentQuiz.value?.toJson() ??
                  {};
              final quizSession = result.quizSession ?? {};
              final totalCorrectAnswer = result.totalCorrectAnswer ?? 0;

              return QuizResultPage(
                quiz: quizData,
                session: quizSession,
                correctAnswers: totalCorrectAnswer,
                fnRedirectButton: () async {
                  // We can just navigate back to TestsPage
                  if (context.mounted) {
                    Get.to(() => const TestsPage());
                  }
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
