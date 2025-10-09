// import 'package:edutainment/constants/appimages.dart';
// import 'package:edutainment/models/excLessonsStepsModel.dart';
// import 'package:edutainment/widgets/emptyWIdget.dart';
// import 'package:edutainment/widgets/ui/default_scaffold.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../../providers/exercisesVm.dart';
// import '../../widgets/header_bar/custom_header_bar.dart';
// import '../../widgets/loaders/dotloader.dart';

// class ExcerciseByCatgQAPage extends ConsumerStatefulWidget {
//   final String labelTitle;
//   const ExcerciseByCatgQAPage({super.key, this.labelTitle = ''});

//   @override
//   ConsumerState<ExcerciseByCatgQAPage> createState() =>
//       _ExcerciseByCatgQAPageState();
// }

// class _ExcerciseByCatgQAPageState extends ConsumerState<ExcerciseByCatgQAPage> {
//   @override
//   Widget build(BuildContext context) {
//     var p = ref.watch(excerVm);
//     var t = Theme.of(context).textTheme;
//     var h = MediaQuery.of(context).size.height;
//     var w = MediaQuery.of(context).size.width;

//     // Get the extra data passed from GoRouter
//     final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
//     Question? questions = extra?['q'] ?? null;

//     return DefaultScaffold(
//       currentPage: '/ExcersisesPage/ExcerciseByCatgQAPage',
//       child:
//           (questions == null)
//           ? EmptyWidget(paddingTop: h * 0.35)
//           : Column(
//               children: [
//                 CustomHeaderBar(
//                   onBack: () async {
//                     // context.pop();
//                     // Get.back();
//                     Navigator.pop(context);
//                   },
//                   centerTitle: false,
//                   title: widget.labelTitle,
//                 ),
//                 Column(
//                   children: [
//                     ///////////////
//                     Container(
//                       height: 90,
//                       width: MediaQuery.of(context).size.width * 0.9,
//                       decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(15)),
//                         gradient: LinearGradient(
//                           colors: [
//                             Color.fromARGB(255, 255, 210, 206),
//                             Color.fromARGB(255, 255, 156, 156),
//                           ],
//                         ),
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Text(
//                           '${questions.label.toString().split(":").first}  \n Time ${questions.toString()} \n Question 1/4',
//                           style: TextStyle(
//                             color: Colors.redAccent,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     Image.asset(AppImages.video1),
//                     const SizedBox(height: 30),
//                     const Text(
//                       '....she going to the worresturaent after work ',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     const SizedBox(height: 100),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.85,
//                       decoration: const BoxDecoration(color: Colors.white),
//                       child: const Padding(
//                         padding: EdgeInsets.all(15),
//                         child: Center(
//                           child: Text(
//                             'Answer A',
//                             style: TextStyle(color: Colors.blue),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.85,
//                       decoration: const BoxDecoration(color: Colors.white),
//                       child: const Padding(
//                         padding: EdgeInsets.all(15),
//                         child: Center(
//                           child: Text(
//                             'Answer B',
//                             style: TextStyle(color: Colors.blue),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.85,
//                       decoration: const BoxDecoration(color: Colors.white),
//                       child: const Padding(
//                         padding: EdgeInsets.all(15),
//                         child: Center(
//                           child: Text(
//                             'Answer C',
//                             style: TextStyle(color: Colors.blue),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.85,
//                       decoration: const BoxDecoration(color: Colors.white),
//                       child: const Padding(
//                         padding: EdgeInsets.all(15),
//                         child: Center(
//                           child: Text(
//                             'Answer D',
//                             style: TextStyle(color: Colors.blue),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//     );
//   }
// }
import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/models/excLessonsStepsModel.dart';
import 'package:edutainment/widgets/emptyWIdget.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/exercisesVm.dart';
import '../../widgets/header_bar/custom_header_bar.dart';
import '../../widgets/loaders/dotloader.dart';

class ExcerciseByCatgQAPage extends ConsumerStatefulWidget {
  final String labelTitle;
  const ExcerciseByCatgQAPage({super.key, this.labelTitle = ''});

  @override
  ConsumerState<ExcerciseByCatgQAPage> createState() =>
      _ExcerciseByCatgQAPageState();
}

class _ExcerciseByCatgQAPageState extends ConsumerState<ExcerciseByCatgQAPage> {
  int _currentQuestionIndex = 0;
  int _remainingTime = 0;
  Timer? _timer;
  String? _selectedAnswer;
  bool _isAnswerCorrect = false;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    // Start the timer for the first question when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final questions = extra?['q'] as List<Question>?;
    if (questions == null || questions.isEmpty) return;

    final currentQuestion = questions[_currentQuestionIndex];
    _remainingTime = currentQuestion.time;

    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        _handleNextQuestion();
      }
    });
  }

  void _handleAnswerSelection(Answer answer) {
    setState(() {
      _selectedAnswer = answer.reference;
      _isAnswerCorrect = answer.isAnswer;
      _showFeedback = true;
      _timer?.cancel(); // Stop the timer when an answer is selected-
      // update answer on backend
      ref.watch(excerVm).submitExcercisesAnswerF(context, answerId: answer.id.toString());
    });

    // Automatically move to the next question after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      _handleNextQuestion();
    });
  }

  void _handleNextQuestion() {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final questions = extra?['q'] as List<Question>?;
    if (questions == null || questions.isEmpty) return;

    setState(() {
      _showFeedback = false;
      _selectedAnswer = null;
      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
        _startTimer();
      } else {
        // Handle end of quiz (e.g., navigate back or show results)
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(excerVm);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    // Get the questions list passed from GoRouter
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    String labelTitle = extra?['labelTitle'] ?? widget.labelTitle;
    final questions = extra?['q'] as List<Question>?;

    if (questions == null || questions.isEmpty) {
      return DefaultScaffold(
        currentPage: '/home/ExcersisesPage/ExcerciseByCatgQAPage',
        child: EmptyWidget(paddingTop: h * 0.35),
      );
    }

    final question = questions[_currentQuestionIndex];

    return DefaultScaffold(
      currentPage: '/home/ExcersisesPage/ExcerciseByCatgQAPage',
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            CustomHeaderBar(
              onBack: () {
                Navigator.pop(context);
              },
              centerTitle: false,
              title: labelTitle,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Question Header
                  Container(
                    // height: 130,
                    width: w * 0.9,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 210, 206),
                          Color.fromARGB(255, 255, 156, 156),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        '${question.label}\nTime: $_remainingTime s\nQuestion ${_currentQuestionIndex + 1}/${questions.length}',
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Placeholder for media (image/video)
                  Opacity(
                    opacity: 0.5,
                    child: DottedBorder(
                      options: RectDottedBorderOptions(
                        dashPattern: [10, 5],
                        strokeWidth: 2,
                        color: Colors.grey.shade800,
                        padding: EdgeInsets.all(16),
                        gradient: LinearGradient(
                          begin:Alignment.bottomCenter,
                          end:Alignment.topCenter,
                          colors: [
                          Colors.blue.shade900, 
                          Colors.grey, 
                          Colors.grey, 
                          // Colors.red.shade900, 
                        ], tileMode: TileMode.decal),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        child: Image.asset(
                          AppImages.unavailable,
                          height: 70,
                          // width: 70,
                          opacity: AlwaysStoppedAnimation(0.4),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Feedback Section
                  if (_showFeedback)
                    Text(
                      _isAnswerCorrect ? 'Correct!' : 'Incorrect!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _isAnswerCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Answer Options
                  ...question.answers.map((answer) {
                    bool isSelected = _selectedAnswer == answer.reference;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: GestureDetector(
                        onTap: _showFeedback
                            ? null
                            : () => _handleAnswerSelection(answer),
                        child: Container(
                          width: w * 0.85,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (_isAnswerCorrect
                                      ? Colors.green[100]
                                      : Colors.red[100])
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? (_isAnswerCorrect ? Colors.green : Colors.red)
                                  : Colors.grey,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                answer.label,
                                style: TextStyle(
                                  color: isSelected ? Colors.black : Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  // Next Button (optional, since we auto-advance after feedback)
                  if (_showFeedback)
                    ElevatedButton(
                      onPressed: _handleNextQuestion,
                      child: const Text('Next Question'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
