import 'package:edutainment/core/loader.dart';
import 'package:edutainment/utils/boxes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../theme/colors.dart';
import '../../widgets/indicators/double_circular_progress_indicator.dart';
import '../quiz/results/result_page.dart';

class EntryQuizResultsPage extends StatefulWidget {
  const EntryQuizResultsPage({super.key});

  @override
  State<EntryQuizResultsPage> createState() => _EntryQuizResultsPage();
}

class _EntryQuizResultsPage extends State<EntryQuizResultsPage> {
  final dynamic entryQuiz = quizBox.get('entryQuiz');

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
            child: FutureBuilder(
              future: fetchEntryQuizResults(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var result = snapshot.data;
                  return QuizResultPage(
                    quiz: result['entryQuiz'],
                    session: result['entryQuizSession'],
                    correctAnswers: result['totalCorrectAnswer'],
                    fnRedirectButton: () {
                      context.go('/home');
                    },
                  );
                } else {
                  return Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: const DoubleCircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
