import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edutainment/utils/utils.dart';
import 'package:edutainment/widgets/ui/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/colors.dart';

class QuizResultPage extends StatefulWidget {
  const QuizResultPage({
    super.key,
    required this.quiz,
    this.session,
    required this.correctAnswers,
    required this.fnRedirectButton,
  });

  final dynamic quiz;
  final dynamic session;
  final int correctAnswers;
  final Function() fnRedirectButton;

  @override
  State<QuizResultPage> createState() => _QuizResultPage();
}

class _QuizResultPage extends State<QuizResultPage> {
  Widget _buildAnswerResult(index) {
    var questionFound = getIn(widget.quiz, 'questions', [])[index];
    var correctAnswer = getIn(
      questionFound,
      'Question.answers',
      [],
    ).firstWhere((element) => element['is_answer'] == true);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dismissOnTouchOutside: false,
          dialogType:
              !getIn(questionFound['quizSessionAnswer'], 'is_answer', false)
              ? DialogType.error
              : DialogType.success,
          body: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  getIn(questionFound, 'Question.label'),
                  style: const TextStyle(fontSize: 18),
                ),
                const Divider(height: 15, color: Colors.transparent),
                Table(
                  // defaultColumnWidth: FixedColumnWidth(120.0),
                  border: TableBorder.all(color: Colors.white, width: 1),
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Score',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            '${getIn(questionFound, 'Question.score')}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'My Answer',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            '${getIn(questionFound, 'quizSessionAnswer.answer_label')}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Good Answer',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            '${getIn(correctAnswer, 'label')}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          btnOk: PrimaryButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: false).pop();
            },
            text: 'ok',
          ),
        ).show();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: getIn(questionFound['quizSessionAnswer'], 'is_answer', false)
              ? const Color(0xFF78B29B)
              : const Color(0xffE16C6C),
        ),
        child: Center(
          child: Text('${index + 1}', style: const TextStyle(fontSize: 22)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Final Results',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: ColorsPallet.darkBlue,
        leading: IconButton(
          onPressed: () {
            widget.fnRedirectButton();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: Get.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.bottomLeft,
              colors: ColorsPallet.bdb,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${getIn(widget.quiz, 'questions', []).length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const Text(
                            'Questions',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${widget.correctAnswers}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const Text(
                            'Correct answers',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${getIn(widget.session, 'total_score', '0')}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const Text(
                            'Points',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, color: Colors.transparent),
                Expanded(
                  child: GridView.count(
                    physics: const BouncingScrollPhysics(),
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    crossAxisCount: 5,
                    children: [
                      for (
                        var index = 0;
                        index < getIn(widget.quiz, 'questions', []).length;
                        index++
                      )
                        _buildAnswerResult(index),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: PrimaryButton(
                    onPressed: () {
                      widget.fnRedirectButton();
                    },
                    radius: 25.0,
                    colors: const [
                      ColorsPallet.blueComponent,
                      ColorsPallet.blueComponent,
                    ],
                    text: getIn(widget.quiz, 'entry_quiz', false)
                        ? 'Let\'s go to learn !'
                        : 'Close',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
