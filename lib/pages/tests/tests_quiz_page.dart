import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../controllers/quiz_controller.dart';
import '../../theme/colors.dart';
import '../../utils/utils.dart';
import '../../widgets/ui/primary_button.dart';
import '../quiz/quiz_page.dart';
import 'tests_base_page.dart';
import 'tests_quiz_results.dart';

class TestsQuizPage extends StatefulWidget {
  const TestsQuizPage({super.key});

  @override
  State<TestsQuizPage> createState() => _TestsQuizPage();
}

class _TestsQuizPage extends State<TestsQuizPage> {
  final QuizController quizController = Get.find();
  bool _quizStarted = false;

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
        child: Obx(() {
          final quiz = quizController.currentQuiz.value;
          if (quiz == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_quizStarted) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            quiz.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ColorsPallet.darkBlue,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildInfoItem(
                                Icons.timer,
                                '${quiz.duration ?? 0} min',
                                'Duration',
                              ),
                              _buildInfoItem(
                                Icons.quiz,
                                '${quiz.questions?.length ?? 0}',
                                'Questions',
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          PrimaryButton(
                            onPressed: () {
                              setState(() {
                                _quizStarted = true;
                              });
                            },
                            text: 'Start Quiz',
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // QuizPage expects a Map, so we convert the model to Json
          final quizData = quiz.toJson();
          // print(jsonEncode(quizData));

          return QuizPage(
            backFn: () {
              // If back is pressed during quiz, maybe confirm or just go back to start?
              // For now, let's go back to the previous screen (TestsBasePage)
              Get.back();
            },
            quiz: quizData,
            onFinish: (answers) async {
              EasyLoading.show();
              // Ensure answers is Map<String, dynamic>
              final Map<String, dynamic> typedAnswers =
                  Map<String, dynamic>.from(answers);
              var saveQuery = await quizController.saveQuiz(
                quiz.id,
                typedAnswers,
              );
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
          );
        }),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: ColorsPallet.blueAccent, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
