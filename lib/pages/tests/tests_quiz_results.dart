import 'package:edutainment/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/quiz_controller.dart';
import '../../utils/utils.dart';
import 'tests_page.dart';

class TestsQuizResultsPage extends StatefulWidget {
  const TestsQuizResultsPage({super.key});

  @override
  State<TestsQuizResultsPage> createState() => _TestsQuizResultsPage();
}

class _TestsQuizResultsPage extends State<TestsQuizResultsPage> {
  final QuizController quizController = Get.find();
  int? selectedQuestionIndex;
  dynamic selectedQuestionData;
  bool? selectedIsCorrect;

  Widget _buildAnswerResult(
    int index,
    dynamic questionFound,
    dynamic quizSession,
    double boxNumberSize,
  ) {
    // Check if the answer is correct - handle nested Question structure
    bool isCorrect = false;

    // The data might be nested under 'Question' key
    var questionData = questionFound['Question'] ?? questionFound;

    // Get the question ID
    var questionId = questionData['_id'] ?? questionFound['_id'];

    // Debug: Print to see the actual structure
    print('=== Question ${index + 1} ===');
    print('Question ID: $questionId');

    // NEW: Check quizSession.answers array - THIS IS WHERE THE CORRECT DATA IS!
    if (quizSession != null && quizSession is Map) {
      var answersArray = quizSession['answers'];
      if (answersArray != null && answersArray is List) {
        // Find the answer for this specific question by matching Question ID
        var matchingAnswer = answersArray.firstWhere(
          (answer) => answer['Question'] == questionId,
          orElse: () => null,
        );

        if (matchingAnswer != null) {
          print('Found matching answer: $matchingAnswer');
          isCorrect = matchingAnswer['is_answer'] == true;
        }
      }
    }

    print('Final isCorrect: $isCorrect');
    print('===================\n');

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          selectedQuestionIndex = index;
          selectedQuestionData = questionFound;
          selectedIsCorrect = isCorrect;
        });
      },
      child: Transform.scale(
        scale: 1.0,
        // scale: selectedQuestionIndex == index ? 1.2 : 1.0,
        child: AspectRatio(
          aspectRatio: 1.0, // Keep boxes square
          child: Container(
            decoration: BoxDecoration(
              // Remove bottom border radius if this box is selected to connect with info card
              borderRadius:
                  //  selectedQuestionIndex == index
                  // ? const BorderRadius.only(
                  //     topLeft: Radius.circular(8),
                  //     topRight: Radius.circular(8),
                  //   )
                  // :
                  BorderRadius.circular(8),
              color: isCorrect
                  ? const Color.fromARGB(
                      255,
                      104,
                      163,
                      106,
                    ) // Green for correct
                  : Color(0xffEE5959), // Red/orange for incorrect
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: boxNumberSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionDetailsInline(bool isTablet) {
    if (selectedQuestionIndex == null || selectedQuestionData == null) {
      return const SizedBox.shrink();
    }

    var questionData = selectedQuestionData['Question'] ?? selectedQuestionData;
    var questionId = questionData['_id'] ?? selectedQuestionData['_id'];

    var answers = getIn(selectedQuestionData, 'Question.answers', []);
    var correctAnswer = (answers is List && answers.isNotEmpty)
        ? answers.firstWhere(
            (element) => element['is_answer'] == true,
            orElse: () => null,
          )
        : null;

    // Get score and user's answer from quizSession
    var quizSession = quizController.quizResult.value?.quizSession;
    var userAnswerData;
    var score = 0;

    if (quizSession != null && quizSession is Map) {
      var answersArray = quizSession['answers'];
      if (answersArray != null && answersArray is List) {
        userAnswerData = answersArray.firstWhere(
          (answer) => answer['Question'] == questionId,
          orElse: () => null,
        );
        if (userAnswerData != null) {
          score = userAnswerData['score'] ?? 0;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: selectedIsCorrect == true
              ? const Color.fromARGB(255, 104, 163, 106) // Green for correct
              : Color(0xffEE5959), // Red for incorrect
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${selectedQuestionIndex! + 1}. ${getIn(selectedQuestionData, 'Question.label', 'What does this mean?')}",
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              getIn(
                selectedQuestionData,
                'Question.text',
                getIn(
                  selectedQuestionData,
                  'Question.label',
                  'Question content',
                ),
              ),
              style: TextStyle(
                fontSize: isTablet ? 22 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            IntrinsicHeight(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Score',
                        style: TextStyle(
                          fontSize: isTablet ? 17 : 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'My answer',
                        style: TextStyle(
                          fontSize: isTablet ? 17 : 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Correct answer',
                        style: TextStyle(
                          fontSize: isTablet ? 17 : 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  VerticalDivider(
                    color: Colors.white.withOpacity(0.7),
                    thickness: 1,
                    width: 1,
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$score',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 11),
                        Text(
                          userAnswerData?['answer_label'] ??
                              getIn(
                                selectedQuestionData,
                                'quizSessionAnswer.answer_label',
                                'N/A',
                              ),
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 11),
                        Text(
                          getIn(correctAnswer, 'label') ??
                              getIn(correctAnswer, 'text') ??
                              'N/A',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive calculations
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final isDesktop = screenWidth >= 1024;

    // Determine grid columns based on screen size
    final gridColumns = isDesktop ? 10 : (isTablet ? 7 : 5);

    // Responsive font sizes
    final headerFontSize = isDesktop ? 35.0 : (isTablet ? 42.0 : 36.0);
    final labelFontSize = isDesktop ? 16.0 : (isTablet ? 15.0 : 14.0);
    final boxNumberSize = isDesktop ? 28.0 : (isTablet ? 26.0 : 24.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1929), // Dark navy background
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Final results',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 22 : 20,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF0A1929),
        leading: IconButton(
          onPressed: () {
            Get.to(() => const TestsPage());
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final result = quizController.quizResult.value;
          if (result == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final quizData =
              result.quiz?.toJson() ??
              quizController.currentQuiz.value?.toJson() ??
              {};
          final quizSession = result.quizSession ?? {};
          final totalCorrectAnswer = result.totalCorrectAnswer ?? 0;
          final questions = getIn(quizData, 'questions', []);
          final totalQuestions = questions.length;
          final totalPoints = getIn(quizSession, 'total_score', '0');

          return Column(
            children: [
              // White header with stats
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 20 : 10,
                  horizontal: 16,
                ),
                decoration: const BoxDecoration(color: ColorsPallet.blueAccent),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$totalQuestions',
                            style: TextStyle(
                              fontSize: headerFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: isTablet ? 10 : 8),
                          Text(
                            'Questions',
                            style: TextStyle(
                              fontSize: labelFontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$totalCorrectAnswer',
                            style: TextStyle(
                              fontSize: headerFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: isTablet ? 10 : 8),
                          Text(
                            'Correct answers',
                            style: TextStyle(
                              fontSize: labelFontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$totalPoints',
                            style: TextStyle(
                              fontSize: headerFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: isTablet ? 10 : 8),
                          Text(
                            'Points',
                            style: TextStyle(
                              fontSize: labelFontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Grid of questions with inline details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 16 : 12),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: (totalQuestions / gridColumns).ceil().toInt(),
                    itemBuilder: (context, rowIndex) {
                      int startIndex = rowIndex * gridColumns;
                      int endIndex =
                          (startIndex + gridColumns).clamp(0, totalQuestions)
                              as int;

                      // Check if selected question is in this row
                      bool hasSelectedInRow =
                          selectedQuestionIndex != null &&
                          selectedQuestionIndex! >= startIndex &&
                          selectedQuestionIndex! < endIndex;

                      return Column(
                        children: [
                          // Row of boxes
                          Row(
                            children: List.generate(gridColumns, (colIndex) {
                              int questionIndex = startIndex + colIndex;
                              if (questionIndex >= totalQuestions) {
                                return const Expanded(child: SizedBox());
                              }

                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(isTablet ? 8 : 6),
                                  child: _buildAnswerResult(
                                    questionIndex,
                                    questions[questionIndex],
                                    quizSession,
                                    boxNumberSize,
                                  ),
                                ),
                              );
                            }),
                          ),
                          // Show details card if a question in this row is selected
                          if (hasSelectedInRow)
                            _buildQuestionDetailsInline(isTablet),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
