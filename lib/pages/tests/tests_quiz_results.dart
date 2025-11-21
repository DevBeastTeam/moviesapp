import 'tests_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/loader.dart';
import '../../theme/colors.dart';
import '../../utils/boxes.dart';
import '../../utils/utils.dart';
import '../quiz/results/result_page.dart';

class TestsQuizResultsPage extends StatefulWidget {
  const TestsQuizResultsPage({super.key});

  @override
  State<TestsQuizResultsPage> createState() => _TestsQuizResultsPage();
}

class _TestsQuizResultsPage extends State<TestsQuizResultsPage> {
  @override
  Widget build(BuildContext context) {
    final dynamic quizData = quizBox.get('currentQuiz');
    final dynamic quizSession = quizBox.get('quizSession');
    final int totalCorrectAnswer = quizBox.get('totalCorrectAnswer');
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
            child: QuizResultPage(
              quiz: quizData,
              session: quizSession,
              correctAnswers: totalCorrectAnswer,
              fnRedirectButton: () async {
                await fetchQuizz(
                  getIn(quizData, 'QuizCategory'),
                  getIn(quizData, 'type'),
                );
                if (context.mounted) {
                  Get.to(() => const TestsPage());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
