import 'dart:io';
import 'dart:math' as math;

import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:better_player_plus/better_player_plus.dart';
import 'package:better_player/better_player.dart';

import 'package:edutainment/core/loader.dart';
import 'package:edutainment/pages/quiz/questions/question_dialog.dart';
import 'package:edutainment/controllers/user_controller.dart';
import 'package:edutainment/widgets/ui/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../icons/icons_light.dart';
import '../../theme/colors.dart';
import '../../utils/questions.dart';
import '../../utils/utils.dart';

class FloatingQuestionButton extends StatefulWidget {
  const FloatingQuestionButton({super.key});

  @override
  State<FloatingQuestionButton> createState() =>
      _FloatingQuestionButton();
}

class _FloatingQuestionButton extends State<FloatingQuestionButton> {
  late bool isShown = true;
  late bool hasAnswered = false;

  Future<void> processQuestion(context) async {
    EasyLoading.show();
    var randomQuestion = await getRandomQuestion();
    EasyLoading.dismiss();
    if (randomQuestion == null) {
      setState(() {
        isShown = true;
      });
    } else {
      var questionData = getIn(randomQuestion, 'question', null);
      if (questionData == null) {
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          title: 'Oops..',
          desc: 'No more question available',
          btnOk: PrimaryButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                isShown = true;
              });
            },
            text: 'Close',
          ),
        ).show();
      } else {
        await _showInfoModal();
        var dialog = QuestionDialog(
          question: questionData,
          onSave: (answer) async {
            var saveOptions = {
              'answers': [getIn(answer, '_id')],
            };

            var questionResult = await saveRandomQuestion(
              getIn(questionData, '_id'),
              saveOptions,
              context,
            );

            var isGoodAnswer = getIn(questionResult, 'isGoodAnswer', false);
            if (isGoodAnswer) {
              _showSuccessFailureModal(QuestionResultType.success);
            } else {
              _showSuccessFailureModal(QuestionResultType.failure);
            }

            await fetchUser();
            Get.find<UserController>().update();
          },
        );
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => dialog,
            fullscreenDialog: true,
          ),
        );
        setState(() {
          isShown = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _showInfoModal() async {
    const infoVideoShowThreshold = 0.3;
    final randomValue = math.Random().nextDouble();
    if (randomValue < infoVideoShowThreshold) {
      var dialog = const QuestionSuccessPage(type: QuestionResultType.info);
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => dialog, fullscreenDialog: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isShown
        ? InkWell(
            // behavior: HitTestBehavior.translucent,
            onTap: () async {
              setState(() {
                isShown = false;
              });
              await processQuestion(context);
            },
            borderRadius: BorderRadius.circular(50),
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsPallet.blueComponent,
              ),
              width: 50.0,
              height: 50.0,
              child: const Center(child: Icon(AppIconsLight.question)),
            ),
          )
        : const SizedBox();
  }

  void _showSuccessFailureModal(QuestionResultType type) async {
    var dialog = QuestionSuccessPage(type: type);
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => dialog, fullscreenDialog: true),
    );
  }
}

enum QuestionResultType { success, failure, info }

class QuestionSuccessPage extends StatefulWidget {
  const QuestionSuccessPage({
    super.key,
    this.type = QuestionResultType.success,
  });

  final QuestionResultType type;

  @override
  State<QuestionSuccessPage> createState() => _QuestionSuccessPageState();
}

class _QuestionSuccessPageState extends State<QuestionSuccessPage> {
  final successURL = Platform.isIOS
      ? [
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/a_a_a/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/thank_you_for_your/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/all_right_rocket/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/applause/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/Congratulations_-_TSN/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/i_m_a_fan/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/smart_ambitious/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/TSN-goodjob/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/well_done_1917/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/YES/master.m3u8',
          'https://e-dutainment.s3.eu-west-1.amazonaws.com/bento/Amazing2020/master.m3u8',
          'https://e-dutainment.s3.eu-west-1.amazonaws.com/bento/gump2020/master.m3u8',
          'https://e-dutainment.s3.eu-west-1.amazonaws.com/bento/right2020/master.m3u8',
        ]
      : [
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/a_a_a/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/thank_you_for_your/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/all_right_rocket/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/applause/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/Congratulations_-_TSN/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/i_m_a_fan/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/smart_ambitious/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/TSN-goodjob/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/well_done_1917/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/YES/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/congrats_l_ok_/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/congrats_ok/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/you_re_right/stream.mpd',
        ];

  final failureURL = Platform.isIOS
      ? [
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/NO!/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/what_the_hell_you_doing/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/when_did_you_give_up/master.m3u8',
          'https://e-dutainment.s3.eu-west-1.amazonaws.com/bento/kidding2020/master.m3u8',
        ]
      : [
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/pretty_disappointed_rn/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/what_the_hell_you_doing/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/NO!/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/when_did_you_give_up/stream.mpd',
        ];

  final infosURL = Platform.isIOS
      ? [
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/can_i_ask_you_a_per/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/can_i_ask/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/good_to_go/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/let_me_ask/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/TSN_-_Let_me_ask_you_smth/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/you_know_me/master.m3u8',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/TSN_-_Let_me_ask_you_smth/master.m3u8',
        ]
      : [
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/can_i_ask_you_a_per/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/can_i_ask/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/good_to_go/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/let_me_ask/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/TSN_-_Let_me_ask_you_smth/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/you_know_me/stream.mpd',
          'https://d2cj5ez5n4d4vx.cloudfront.net/bento/TSN_-_Let_me_ask_you_smth/stream.mpd',
        ];

  String videoUrl = '';

  String successTitle = 'Well done !';
  String failureTitle = 'You are wrong...';
  String infoTitle = 'LET\'S PLAY !';
  String successSubtitle = 'Will you raise your level again?';
  String failureSubtitle = 'Will you dare continue ???';
  String infoSubtitle =
      'You can earn points by answering the following challenge';

  BetterPlayerController? _betterPlayerController;
  AudioSource? _audioSource;
  AudioPlayer? _player;

  double successVideoShowThreshold = 0.7;
  double failureVideoShowThreshold = 0.5;

  String failureImageUrl = 'assets/images/questions/failureIMG.png';
  String failureAudioUrl = 'asset:///assets/audio/failure.mp3';
  String successImageUrl = 'assets/images/questions/successIMG.png';
  String successAudioUrl = 'asset:///assets/audio/success.mp3';

  @override
  void initState() {
    super.initState();
    final randomValue = math.Random().nextDouble();

    switch (widget.type) {
      case QuestionResultType.success:
        if (randomValue < successVideoShowThreshold) {
          videoUrl = successURL[math.Random().nextInt(successURL.length)];
          _betterPlayerController = BetterPlayerController(
            const BetterPlayerConfiguration(
              autoPlay: true,
              aspectRatio: 1,
              fit: BoxFit.cover,
              controlsConfiguration: BetterPlayerControlsConfiguration(
                showControls: false,
              ),
            ),
            betterPlayerDataSource: BetterPlayerDataSource.network(
              videoUrl,
              videoFormat: Platform.isIOS
                  ? BetterPlayerVideoFormat.hls
                  : BetterPlayerVideoFormat.dash,
            ),
          );
        } else {
          _audioSource = AudioSource.uri(Uri.parse(successAudioUrl));
          _player = AudioPlayer();
          _player?.setAudioSource(_audioSource!);
          _player?.play();
        }
        break;
      case QuestionResultType.failure:
        if (randomValue < failureVideoShowThreshold) {
          videoUrl = failureURL[math.Random().nextInt(failureURL.length)];
          _betterPlayerController = BetterPlayerController(
            const BetterPlayerConfiguration(
              autoPlay: true,
              aspectRatio: 1,
              fit: BoxFit.cover,
              controlsConfiguration: BetterPlayerControlsConfiguration(
                showControls: false,
              ),
            ),
            betterPlayerDataSource: BetterPlayerDataSource.network(
              videoUrl,
              videoFormat: Platform.isIOS
                  ? BetterPlayerVideoFormat.hls
                  : BetterPlayerVideoFormat.dash,
            ),
          );
        } else {
          _audioSource = AudioSource.uri(Uri.parse(failureAudioUrl));
          _player = AudioPlayer();
          _player?.setAudioSource(_audioSource!);
          _player?.play();
        }
        break;
      case QuestionResultType.info:
        videoUrl = infosURL[math.Random().nextInt(infosURL.length)];
        _betterPlayerController = BetterPlayerController(
          const BetterPlayerConfiguration(
            autoPlay: true,
            aspectRatio: 1,
            fit: BoxFit.cover,
            controlsConfiguration: BetterPlayerControlsConfiguration(
              showControls: false,
            ),
          ),
          betterPlayerDataSource: BetterPlayerDataSource.network(
            videoUrl,
            videoFormat: Platform.isIOS
                ? BetterPlayerVideoFormat.hls
                : BetterPlayerVideoFormat.dash,
          ),
        );
        break;
    }
    if (_betterPlayerController != null) {
      _betterPlayerController!.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(context).pop();
          });
        }
      });
    }
    _player?.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorsPallet.darkBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(color: ColorsPallet.darkBlue),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                color: ColorsPallet.darkBlue,
                child: _buildContent(),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: 240,
                // padding: const EdgeInsets.symmetric(horizontal: 32),
                child: PrimaryButton(
                  colors: const [
                    ColorsPallet.blueComponent,
                    ColorsPallet.blueComponent,
                  ],
                  radius: 25,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: 'Close',
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.type == QuestionResultType.success) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_betterPlayerController != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _betterPlayerController!),
            )
          else
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(successImageUrl),
            ),
          const SizedBox(height: 24),
          Text(
            successTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              successSubtitle,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
    if (widget.type == QuestionResultType.failure) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_betterPlayerController != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _betterPlayerController!),
            )
          else
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(failureImageUrl),
            ),
          const SizedBox(height: 24),
          Text(
            failureTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              failureSubtitle,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
    if (widget.type == QuestionResultType.info) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_betterPlayerController != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _betterPlayerController!),
            ),
          const SizedBox(height: 24),
          Text(
            infoTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              infoSubtitle,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
