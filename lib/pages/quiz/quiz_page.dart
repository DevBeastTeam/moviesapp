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
                                  'Question ${currentQuestion + 1} / ${widget.quiz['questions'].length}',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20, color: Colors.transparent),
                          Wrap(
                            runSpacing: 4,
                            spacing: 6,
                            children: [
                              for (int i = 0; i < totalQuestions; i++)
                                Container(
                                  height: 3,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    color: i < currentQuestion
                                        ? ColorsPallet.blueAccent
                                        : i == currentQuestion
                                        ? Colors.white
                                        : Colors.white.withOpacity(.4),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 12, color: Colors.transparent),
                    QuestionContent(
                      key: ValueKey(currentQuestion),
                      onSelectAnswer: (answerSelected) {
                        setState(() {
                          answers[getIn(
                                widget.quiz['questions'][currentQuestion],
                                'Question._id',
                              )] =
                              answerSelected['_id'];
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
