import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:better_player/better_player.dart';
import 'package:edutainment/core/api_helper.dart';
import 'package:edutainment/pages/movies/widgets/custom_controls.dart';
import 'package:edutainment/pages/quiz/questions/answers/answer.dart';
import 'package:edutainment/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../utils/questions.dart';
import '../../../utils/utils.dart';
import '../../../widgets/header_bar/custom_header_bar.dart';
import '../../../widgets/ui/primary_button.dart';

class MoviePlayer extends StatefulWidget {
  const MoviePlayer({
    super.key,
    required this.movie,
    required this.questions,
    this.startAt = 0,
  });

  final dynamic movie;
  final List questions;
  final int startAt;

  @override
  State<MoviePlayer> createState() => _MoviePlayer();
}

class _MoviePlayer extends State<MoviePlayer> {
  late BetterPlayerController? _betterPlayerController;

  bool isInLandScapeMode = false;

  late String questionChoice = '';

  late List tempQuestions = [];
  int nextQuestionIndex = 0;

  late List<Duration> stops = [];

  late bool showQuestion = false;
  bool completedAllQuestions = false;
  late dynamic currentQuestion;
  String selectedRadioOption = '';
  int progressSeconds = 0;

  String previousType = '';

  Future<void> sendPlayerEvent(String type) async {
    if (previousType == 'ended') {
      return;
    }
    previousType = type;
    final event = {
      'status': type,
      'time':
          _betterPlayerController
              ?.videoPlayerController
              ?.value
              .position
              .inSeconds ??
          0,
    };
    final id = getIn(widget.movie, '_id');
    var baseApi = ApiHelper();
    await baseApi.post('/movies/$id/history', event, null);
  }

  void setupPlayer() {
    // for (var question in tempQuestions) {
    //   stops.add(Duration(seconds: question['start']));
    // }
    final betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      getIn(widget.movie, 'm3u8_link'),
      videoFormat: BetterPlayerVideoFormat.hls,
      drmConfiguration: Platform.isIOS
          ? BetterPlayerDrmConfiguration(
              drmType: BetterPlayerDrmType.fairplay,
              certificateUrl: 'https://fairplay.swankmp.net/fairplay.cer',
              licenseUrl: 'https://fairplay.swankmp.net/api/v1/license',
              headers: {'SWANKPORTAL': 'de236319-cabd-4102-b240-98d92ec0db3a'},
            )
          : BetterPlayerDrmConfiguration(
              drmType: BetterPlayerDrmType.widevine,
              licenseUrl: 'https://wvlsmod.swankmp.net/moddrm_proxy/proxy',
              headers: {'SWANKPORTAL': 'de236319-cabd-4102-b240-98d92ec0db3a'},
            ),
    );
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        startAt: Duration(seconds: widget.startAt),
        autoPlay: false,
        autoDispose: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          playerTheme: BetterPlayerTheme.custom,
          controlsHideTime: const Duration(seconds: 3),
          customControlsBuilder: (controller, onPlayerVisibilityChanged) {
            return CustomControlsWidget(
              controller: controller,
              onControlsVisibilityChanged: onPlayerVisibilityChanged,
              stops: stops,
              onFullScreenPressed: () {
                onTappedFullScreen();
              },
              isInLandScapeMode: isInLandScapeMode,
            );
          },
        ),
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );

    _betterPlayerController?.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
        final Duration? progress = event.parameters?['progress'];
        final Duration? duration = event.parameters?['duration'];
        if (progress != null && duration != null) {
          if (progress.inSeconds > (duration.inSeconds * .9)) {
            sendPlayerEvent('ended');
          }

          setState(() {
            progressSeconds = progress.inSeconds;
          });
          if (questionChoice == 'during' && tempQuestions.isNotEmpty) {
            if (showQuestion == false) {
              var q = tempQuestions[0];
              if (progress.inSeconds == int.parse('${q['start']}')) {
                // q['answers'].shuffle();
                setState(() {
                  showQuestion = true;
                  currentQuestion = q;
                });
                // _betterPlayerController?.pause();
              }
            } else {
              // check for end and remove the question
              var q = tempQuestions[0];
              if (progress.inSeconds >= int.parse('${q['end']}')) {
                setState(() {
                  showQuestion = false;
                  currentQuestion = null;
                  selectedRadioOption = '';
                });
                tempQuestions.removeWhere(
                  (item) =>
                      '${item['_id']}' == '${getIn(currentQuestion, '_id')}',
                );
              }
            }
          }
        }
      }
      if (event.betterPlayerEventType == BetterPlayerEventType.pause) {
        sendPlayerEvent('paused');
      }
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        if (isInLandScapeMode) {
          onTappedFullScreen();
        }
        if (questionChoice == 'ending' && tempQuestions.isNotEmpty) {
          setState(() {
            showQuestion = true;
            currentQuestion = tempQuestions[0];
          });
        }
      }
    });

    if (questionChoice == '') {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dismissOnTouchOutside: false,
          dialogType: DialogType.question,
          body: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Text(
                  'I want to answer questions :',
                  style: TextStyle(fontSize: 18),
                ),
                const Divider(height: 15, color: Colors.transparent),
                PrimaryButton(
                  onPressed: () {
                    setState(() {
                      questionChoice = 'during';
                    });
                    Navigator.of(context).pop();
                  },
                  text: 'While watching (if possible)',
                ),
                const Divider(height: 15, color: Colors.transparent),
                PrimaryButton(
                  onPressed: () {
                    setState(() {
                      questionChoice = 'ending';
                    });
                    Navigator.of(context).pop();
                    onTappedFullScreen();
                  },
                  text: 'Once the film is over',
                ),
              ],
            ),
          ),
        ).show();
      });
    }
  }

  void onOptionSelected(value, answer) async {
    setState(() {
      selectedRadioOption = value;
      tempQuestions.removeWhere(
        (item) => '${item['_id']}' == '${getIn(currentQuestion, '_id')}',
      );
    });

    var saveOptions = {
      'answers': [getIn(answer, '_id')],
    };

    await saveRandomQuestion(
      getIn(currentQuestion, '_id'),
      saveOptions,
      context,
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (questionChoice == 'ending') {
        if (tempQuestions.isEmpty) {
          setState(() {
            showQuestion = false;
            currentQuestion = null;
            selectedRadioOption = '';
            completedAllQuestions = true;
          });
        } else {
          setState(() {
            showQuestion = true;
            currentQuestion = tempQuestions[0];
            selectedRadioOption = '';
          });
        }
      } else {
        setState(() {
          showQuestion = false;
          currentQuestion = null;
          selectedRadioOption = '';
          _betterPlayerController?.play();
        });
        if (tempQuestions.isEmpty) {
          setState(() {
            completedAllQuestions = true;
          });
        }
      }
    });
  }

  void onTappedFullScreen() {
    if (isInLandScapeMode) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      setState(() {
        isInLandScapeMode = false;
      });
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      setState(() {
        isInLandScapeMode = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tempQuestions = widget.questions.toList();
    tempQuestions.sort((a, b) {
      return a['start'] - b['start'];
    });
    _betterPlayerController = null;
    currentQuestion = null;
    setupPlayer();
  }

  @override
  void dispose() async {
    await sendPlayerEvent('paused');
    _betterPlayerController?.dispose();
    // reset to portrait
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Widget movieQuestionBuilder() {
    List questionAnswers = getIn(currentQuestion, 'answers', []);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          if (!isInLandScapeMode) const SizedBox(height: 32),
          if (!isInLandScapeMode)
            Align(
              alignment: Alignment.center,
              child: Text(
                currentQuestion['label'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          if (!isInLandScapeMode) const SizedBox(height: 32),
          if (!isInLandScapeMode) const SizedBox(height: 12),
          MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: isInLandScapeMode ? 2 : 1,
            mainAxisSpacing: isInLandScapeMode ? 8 : 12,
            crossAxisSpacing: isInLandScapeMode ? 8 : 12,
            itemCount: questionAnswers.length,
            itemBuilder: (context, index) {
              final currentAnswer = questionAnswers[index];
              return Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      onOptionSelected(currentAnswer['answer'], currentAnswer);
                    },
                    child: AnswerContent(
                      active:
                          currentAnswer != null &&
                          currentAnswer['answer'] == selectedRadioOption,
                      answer: questionAnswers[index],
                      answerIndex: index,
                      isInLandScapeMode: isInLandScapeMode,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isInLandScapeMode)
                CustomHeaderBar(
                  onBack: () async {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  centerTitle: false,
                  titleStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  title: getIn(widget.movie, 'label'),
                ),
              if (isInLandScapeMode && showQuestion) const SizedBox(height: 38),
              if (isInLandScapeMode && showQuestion)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 24,
                  ),
                  child: Text(
                    currentQuestion['label'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Expanded(
                flex: isInLandScapeMode ? 1 : 0,
                key: const Key('betterPlayer'),
                child: Center(
                  child: Container(
                    color: Colors.black,
                    child: AspectRatio(
                      aspectRatio:
                          _betterPlayerController?.getAspectRatio() ?? 16 / 9,
                      child: _betterPlayerController == null
                          ? const Center(child: CircularProgressIndicator())
                          : BetterPlayer(controller: _betterPlayerController!),
                    ),
                  ),
                ),
              ),
              if (isInLandScapeMode && showQuestion && currentQuestion != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: movieQuestionBuilder(),
                ),
              if (!isInLandScapeMode &&
                  tempQuestions.isEmpty &&
                  completedAllQuestions)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(child: buildNoMoreQuestions()),
                  ),
                ),
              if (!isInLandScapeMode && currentQuestion == null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    child: Center(child: buildNextQuestionCounter()),
                  ),
                ),
              if (!isInLandScapeMode && showQuestion && currentQuestion != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  child: Center(child: movieQuestionBuilder()),
                ),
            ],
          ),
        ),
        if (isInLandScapeMode)
          Positioned(
            top: 8,
            left: 8,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
      ],
    );
  }

  Widget buildNextQuestionCounter() {
    var progress = Duration(seconds: progressSeconds);
    var start = Duration(
      seconds: tempQuestions.isNotEmpty ? tempQuestions[0]['start'] : 0,
    );
    var diff = start - progress;
    if (diff.isNegative) {
      // remove the first question
      tempQuestions.removeAt(0);
      start = Duration(
        seconds: tempQuestions.isNotEmpty ? tempQuestions[0]['start'] : 0,
      );
      diff = progress - start;
    }
    // convert to minutes:seconds
    var diffInMins = (diff.inMinutes).abs();
    var diffInSeconds = (diff.inSeconds - (diff.inMinutes * 60)).abs();

    var currentQuestionIndex = widget.questions.length - tempQuestions.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            '${widget.questions.length} questions matching your level are available for this film',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        if (tempQuestions.isNotEmpty && questionChoice == 'during')
          Wrap(
            runSpacing: 4,
            spacing: 6,
            children: [
              for (int i = 0; i < widget.questions.length; i++)
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    color: i < currentQuestionIndex
                        ? ColorsPallet.blueAccent
                        : i == currentQuestionIndex
                        ? Colors.white
                        : Colors.white.withOpacity(.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 64),
        if (tempQuestions.isNotEmpty && questionChoice == 'during')
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "The next questione next question we next question w will appear in ${diffInMins.toString().padLeft(2, '0')}'' ${diffInSeconds.toString().padLeft(2, '0')}'",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget buildNoMoreQuestions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: const Text(
            'That’s all for now! We hope you enjoyed the questions so far. Keep practicing your English and get ready for exciting new questions coming soon!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
