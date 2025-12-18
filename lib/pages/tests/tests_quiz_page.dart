import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/constants/screenssize.dart';
import 'package:edutainment/widgets/card_3d.dart';
import 'package:edutainment/widgets/emptyWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../controllers/quiz_controller.dart';
import '../../theme/colors.dart';
import '../../utils/assets/assets_icons.dart';
import '../../utils/utils.dart';
import '../../widgets/ui/custom_submit_button.dart';
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

          if (quizController.quizzes.isEmpty) {
            return Center(child: EmptyWidget(text: 'No quizzes available'));
          }

          if (!_quizStarted) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome To",
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.playerlight, width: 35),
                        Text(
                          "E-Dutainment",
                          style: TextStyle(
                            fontSize: 27,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Football Attack',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Ready to develop your English skills ?",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: Image.asset(AppImages.forestgumpwave),
                    ),

                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: Screen.isPhone(context)
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              width:
                                  Screen.width(context) *
                                  (Screen.isPhone(context) ? 0.15 : 0.1),
                              AppImages.pass,
                            ),
                            Text("Take the\ntest"),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                width:
                                    Screen.width(context) *
                                    (Screen.isPhone(context) ? 0.15 : 0.1),
                                AppImages.mp4,
                              ),
                              Text("Watch film\nand videos"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                width:
                                    Screen.width(context) *
                                    (Screen.isPhone(context) ? 0.15 : 0.1),
                                AppImages.qa,
                              ),
                              Text("Answer the\nquestions"),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Image.asset(
                              width:
                                  Screen.width(context) *
                                  (Screen.isPhone(context) ? 0.15 : 0.1),
                              AppImages.puzzles,
                            ),
                            Text("Have fun"),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                    Center(
                      child: CustomSubmitButton(
                        width: (MediaQuery.of(context).size.width * .5 > 200
                            ? 200
                            : MediaQuery.of(context).size.width * .5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(EdutainmentIcons.playEdutainment),
                            Container(
                              margin: const EdgeInsets.only(left: 3),
                              child: Text(
                                'START NOW',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: Theme.of(
                                    context,
                                  ).textTheme.titleLarge!.fontSize!,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          setState(() {
                            _quizStarted = true;
                          });
                        },
                      ),
                    ),

                    // const Spacer(),
                    // Container(
                    //   padding: const EdgeInsets.all(24),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(20),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black.withOpacity(0.1),
                    //         blurRadius: 10,
                    //         offset: const Offset(0, 5),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Text(
                    //         quiz.title,
                    //         textAlign: TextAlign.center,
                    //         style: const TextStyle(
                    //           fontSize: 24,
                    //           fontWeight: FontWeight.bold,
                    //           color: ColorsPallet.darkBlue,
                    //         ),
                    //       ),
                    //       const SizedBox(height: 20),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //         children: [
                    //           _buildInfoItem(
                    //             Icons.timer,
                    //             '${quiz.duration ?? 0} min',
                    //             'Duration',
                    //           ),
                    //           _buildInfoItem(
                    //             Icons.quiz,
                    //             '${quiz.questions?.length ?? 0}',
                    //             'Questions',
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(height: 30),
                    //       PrimaryButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             _quizStarted = true;
                    //           });
                    //         },
                    //         text: 'Start Quiz',
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // const Spacer(),
                    // TextButton(
                    //   onPressed: () => Get.back(),
                    //   child: const Text(
                    //     'Cancel',
                    //     style: TextStyle(color: Colors.white70),
                    //   ),
                    // ),
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
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        // side: BorderSide(color: Color(0XFF3087DE), width: 2),
                      ),
                      backgroundColor: Color(0XFF0B2845),
                      child: Card3D(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: Icon(
                                  Icons.question_mark_rounded,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "You're done!",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "The test is completed",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 25),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0XFF0E3358),
                                        Color.fromARGB(255, 6, 23, 39),
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: const Text(
                                    'Let`s Check My Result',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(20),
                                    ),
                                    side: BorderSide(color: Colors.white),
                                  ),
                                  child: const Text(
                                    '               Cancel               ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
