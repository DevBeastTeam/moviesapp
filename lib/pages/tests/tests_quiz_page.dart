import 'tests_quiz_results.dart';
import 'tests_base_page.dart';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../theme/colors.dart';
import '../../utils/boxes.dart';
import '../../utils/quizz.dart';
import '../../utils/utils.dart';
import '../../widgets/ui/primary_button.dart';
import '../quiz/quiz_page.dart';

class TestsQuizPage extends StatefulWidget {
  const TestsQuizPage({super.key});

  @override
  State<TestsQuizPage> createState() => _TestsQuizPage();
}

class _TestsQuizPage extends State<TestsQuizPage> {
  @override
  Widget build(BuildContext context) {
    final dynamic quizData = quizBox.get('currentQuiz');

    print(jsonEncode(quizData));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.bottomLeft,
            colors: ColorsPallet.bdb,
          ),
        ),
        child: QuizPage(
          backFn: () {
            Get.to(() => const TestsBasePage());
          },
          quiz: quizData,
          onFinish: (answers) async {
            EasyLoading.show();
            var saveQuery = await saveQuizAnswers(quizData['_id'], answers);
            EasyLoading.dismiss();
            if (getIn(saveQuery, 'success') == false) {
              if (context.mounted) {
                await AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  title: 'Error',
                  desc:
                      'Une erreur est survenue, veuillez réessayer ulterierement ou contacter le support si le problème persiste.',
                  btnOkOnPress: () {},
                  btnOk: PrimaryButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    text: 'Close',
                  ),
                ).show();
              }
            } else if (context.mounted) {
              bool res = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("You're done!"),
                    content: const Text('The test is completed'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Let's check my results"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
              if (res == true) {
                Get.to(() => const TestsQuizResultsPage());
              } else {
                Get.to(() => const TestsBasePage());
              }
            }
          },
        ),
      ),
    );
  }
}
