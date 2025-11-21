import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edutainment/utils/boxes.dart';
import 'package:edutainment/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'level_page.dart';

import '../../theme/colors.dart';
import '../../utils/quizz.dart';
import '../../widgets/ui/primary_button.dart';
import '../quiz/quiz_page.dart';

class EntryQuizPage extends StatefulWidget {
  const EntryQuizPage({super.key});

  @override
  State<EntryQuizPage> createState() => _EntryQuizPage();
}

class _EntryQuizPage extends State<EntryQuizPage> {
  final dynamic entryQuiz = quizBox.get('entryQuiz');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.bottomLeft,
            colors: ColorsPallet.bdb,
          ),
        ),
        child: QuizPage(
          quiz: entryQuiz,
          onFinish: (answers) async {
            EasyLoading.show();
            var saveQuery = await saveEntryQuizAnswers(answers);
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
            } else {
              if (context.mounted) {
                await fetchData();
                if (context.mounted) {
                  Get.to(() => const EntryQuizLevelPage());
                }
              }
            }
          },
        ),
      ),
    );
  }
}
