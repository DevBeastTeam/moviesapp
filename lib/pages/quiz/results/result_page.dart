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
    var answers = getIn(questionFound, 'Question.answers', []);
    // Handle case where answers might be null or empty
    var correctAnswer = (answers is List && answers.isNotEmpty)
        ? answers.firstWhere(
            (element) => element['is_answer'] == true,
            orElse: () => null,
          )
        : null;

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
                            '${getIn(correctAnswer, 'label') ?? 'N/A'}',
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
          borderRadius: BorderRadius.circular(8),
          color: getIn(questionFound['quizSessionAnswer'], 'is_answer', false)
              ? const Color(0xFF5DBAAA) // Teal for correct
              : const Color(0xFFFF5733), // Red/orange for incorrect
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = getIn(widget.quiz, 'questions', []).length;
    final totalPoints = getIn(widget.session, 'total_score', '0');

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
          child: Column(
            children: [
              // Header with stats
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('$totalQuestions', 'Questions'),
                    _buildStatColumn(
                      '${widget.correctAnswers}',
                      'Correct answers',
                    ),
                    _buildStatColumn('$totalPoints', 'Points'),
                  ],
                ),
              ),
              // Grid of questions
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A4F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                    itemCount: totalQuestions,
                    itemBuilder: (context, index) => _buildAnswerResult(index),
                  ),
                ),
              ),
              // Close button
              Container(
                margin: const EdgeInsets.all(16),
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
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: ColorsPallet.darkBlue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
