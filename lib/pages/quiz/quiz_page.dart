import 'package:edutainment/utils/utils.dart';
import 'package:edutainment/widgets/ui/primary_button.dart';
import 'package:flutter/material.dart';

import '../../icons/icons_light.dart';
import '../../theme/colors.dart';
import 'questions/question.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({
    super.key,
    required this.quiz,
    required this.onFinish,
    this.backFn,
  });

  final dynamic quiz;
  final Function(dynamic) onFinish;
  final Function? backFn;

  @override
  State<QuizPage> createState() => _QuizPage();
}

class _QuizPage extends State<QuizPage> {
  late int currentQuestion = 0;
  late bool currentQuestionAnswered = false;
  late dynamic answers = {};

  @override
  Widget build(BuildContext context) {
    int totalQuestions = widget.quiz['questions'].length;
    var currentQuestionIndex = currentQuestion + 1;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.bottomLeft,
            colors: ColorsPallet.bdb,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                // height: Get.height - 100,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.red,
                      // padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if (widget.backFn != null)
                                Container(
                                  margin: const EdgeInsets.only(right: 25),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          widget.backFn!();
                                        },
                                        child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Icon(AppIconsLight.arrowLeft),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'LEVELS ',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: Text(
                              //     'Question ${currentQuestion + 1} / ${widget.quiz['questions'].length}',
                              //     style: const TextStyle(fontSize: 24),
                              //   ),
                              // ),
                            ],
                          ),
                          const Divider(height: 20, color: Colors.transparent),
                          Transform.scale(
                            scale: 1.1,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                // color: const Color.fromARGB(255, 249, 217, 215),
                                borderRadius: BorderRadius.circular(0),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    const Color.fromARGB(255, 250, 212, 209),
                                    const Color.fromARGB(255, 255, 139, 131),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "Lessons",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          129,
                                          49,
                                          49,
                                        ),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Questions: ${currentQuestionIndex} / ${totalQuestions}",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          129,
                                          49,
                                          49,
                                        ),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Wrap(
                          //   runSpacing: 4,
                          //   spacing: 6,
                          //   children: [
                          //     for (int i = 0; i < totalQuestions; i++)
                          //       Container(
                          //         height: 3,
                          //         width: 12,
                          //         decoration: BoxDecoration(
                          //           color: i < currentQuestion
                          //               ? ColorsPallet.blueAccent
                          //               : i == currentQuestion
                          //               ? Colors.white
                          //               : Colors.white.withOpacity(.4),
                          //           borderRadius: BorderRadius.circular(4),
                          //         ),
                          //       ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    const Divider(height: 12, color: Colors.transparent),
                    QuestionContent(
                      key: ValueKey(currentQuestion),
                      onSelectAnswer: (answerSelected) {
                        setState(() {
                          var questionId = getIn(
                            widget.quiz['questions'][currentQuestion],
                            '_id',
                          );
                          // Fallback if _id is not found directly (handling potential nested structure)
                          questionId ??= getIn(
                            widget.quiz['questions'][currentQuestion],
                            'Question._id',
                          );
                          answers[questionId] = answerSelected['_id'];
                          currentQuestionAnswered = true;
                        });
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (currentQuestion + 1 <
                              widget.quiz['questions'].length) {
                            setState(() {
                              currentQuestion++;
                              currentQuestionAnswered = false;
                            });
                          }
                        });
                      },
                      question: widget.quiz['questions'][currentQuestion],
                    ),
                    // for (var index = 0;
                    //     index < widget.quiz['questions'].length;
                    //     index++)
                    //   Visibility(
                    //       visible: index == currentQuestion,
                    //       child: QuestionContent(
                    //           onSelectAnswer: (answerSelected) {
                    //             setState(() {
                    //               answers[getIn(
                    //                       widget.quiz['questions'][index],
                    //                       'Question._id')] =
                    //                   answerSelected['_id'];
                    //               currentQuestionAnswered = true;
                    //             });
                    //             Future.delayed(const Duration(milliseconds: 300), () {
                    //               if (currentQuestion + 1 < widget.quiz['questions'].length) {
                    //                 setState(() {
                    //                   currentQuestion++;
                    //                   currentQuestionAnswered = false;
                    //                 });
                    //               }
                    //             });
                    //           },
                    //           question: widget.quiz['questions'][index])),
                  ],
                ),
              ),
              const Divider(height: 10, color: Colors.transparent),
              if (currentQuestionAnswered &&
                  !(currentQuestion + 1 < widget.quiz['questions'].length))
                PrimaryButton(
                  onPressed: () {
                    if (currentQuestion + 1 < widget.quiz['questions'].length) {
                      setState(() {
                        currentQuestion++;
                        currentQuestionAnswered = false;
                      });
                    } else {
                      widget.onFinish(answers);
                    }
                  },
                  text: currentQuestion + 1 < widget.quiz['questions'].length
                      ? 'Next'
                      : 'Finish quiz',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
