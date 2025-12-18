import 'dart:io';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
// import 'package:better_player_plus/better_player_plus.dart';
import 'package:better_player/better_player.dart';

import 'package:edutainment/core/loader.dart';
import 'package:edutainment/pages/quiz/questions/full_photo_view.dart';
import 'package:edutainment/theme/colors.dart';
import 'package:edutainment/utils/assets/assets_icons.dart';
import 'package:edutainment/utils/utils.dart';
import 'package:edutainment/widgets/card_3d.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../widgets/player/simple_custom_player_controls.dart';
import 'answers/answer.dart';

class QuestionContent extends StatefulWidget {
  const QuestionContent({
    super.key,
    required this.question,
    required this.onSelectAnswer,
  });

  final dynamic question;
  final Function(dynamic) onSelectAnswer;

  @override
  State<QuestionContent> createState() => _QuestionContent();
}

class _QuestionContent extends State<QuestionContent>
    with WidgetsBindingObserver {
  late int? currentAnswer;
  late dynamic questionData;
  bool showImage = false;
  bool showPlayMovie = false;
  bool showAudioPlayer = false;

  final _player = AudioPlayer();

  BetterPlayerController? _betterPlayerController;

  void setupPlayer(movie) {
    final betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      getIn(movie, 'm3u8_link'),
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
        autoPlay: false,
        autoDispose: true,
        startAt: Duration(seconds: questionData['start']),
        controlsConfiguration: BetterPlayerControlsConfiguration(
          playerTheme: BetterPlayerTheme.custom,
          customControlsBuilder: (videoController, onPlayerVisibilityChanged) =>
              SimpleCustomPlayerControls(controller: videoController),
          showControls: true,
          showControlsOnInitialize: true,
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      _betterPlayerController?.setupDataSource(betterPlayerDataSource);
      _betterPlayerController?.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
          final Duration progress = event.parameters!['progress'];
          if (progress.inSeconds >= questionData['end']) {
            _betterPlayerController?.pause();
            _betterPlayerController?.setControlsVisibility(true);
            _betterPlayerController?.seekTo(
              Duration(seconds: questionData['start']),
            );
          }
        }
      });
      Future.delayed(const Duration(seconds: 3), () {
        _betterPlayerController?.setControlsVisibility(true);
      });
    });
    setState(() {});
  }

  void _fetchSingleMovie() async {
    EasyLoading.show();
    var movieFetch = await fetchMovie(questionData['Movie']);
    setupPlayer(movieFetch['movie']);
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    currentAnswer = null;
    questionData = widget.question['Question'] ?? widget.question;
    if (questionData['Movie'] != null && questionData['Movie'] != '') {
      _fetchSingleMovie();
      showPlayMovie = true;
    } else {
      if (questionData['picture'] != null && questionData['picture'] != '') {
        showImage = true;
      }
      if (questionData['audio'] != null && questionData['audio'] != '') {
        showImage = false;
        showAudioPlayer = true;
        _init();
      }
    }
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      },
    );
    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(questionData['audio'])),
      );
    } catch (e) {
      print('Error loading audio source: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _betterPlayerController?.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _betterPlayerController?.dispose();
      _player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    var questionData = widget.question['Question'] ?? widget.question;
    final onlyTwoAnswers = questionData['answers'].length == 2;
    if (questionData == null) {
      return const Text('');
    }
    return Expanded(
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                questionData['label'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (showImage)
            Expanded(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            FullPhotoView(url: questionData['picture']),
                      ),
                    );
                  },
                  child: Image.network(
                    questionData['picture'],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          if (showPlayMovie) Expanded(child: _buildMovieWidget()),
          if (showAudioPlayer) Expanded(child: _buildAudioWidget()),
          Divider(height: onlyTwoAnswers ? 60 : 12, color: Colors.transparent),
          Column(
            children: [
              for (
                var index = 0;
                index < questionData['answers'].length;
                index++
              )
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  // decoration: BoxDecoration(color: ColorsPallet.darkBlue),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        currentAnswer = index;
                      });
                      widget.onSelectAnswer(questionData['answers'][index]);
                    },
                    child: AnswerContent(
                      active: currentAnswer != null && currentAnswer == index,
                      answer: questionData['answers'][index],
                      answerIndex: index,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child:
                    questionData['picture'] == null ||
                        questionData['picture'] == ''
                    ? Container(color: Colors.transparent)
                    : Image.network(
                        questionData['picture'],
                        fit: BoxFit.contain,
                      ),
              ),
              Positioned.fill(
                child: StreamBuilder<PlayerState>(
                  stream: _player.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 64.0,
                          height: 64.0,
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    } else if (playing != true) {
                      return IconButton(
                        icon: const Icon(EdutainmentIcons.playEdutainment),
                        iconSize: 60.0,
                        onPressed: _player.play,
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        icon: const Icon(Icons.pause),
                        iconSize: 60.0,
                        onPressed: _player.pause,
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(Icons.replay),
                        iconSize: 60.0,
                        onPressed: () => _player.seek(Duration.zero),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return SeekBar(
              duration: positionData?.duration ?? Duration.zero,
              position: positionData?.position ?? Duration.zero,
              bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
              onChangeEnd: _player.seek,
            );
          },
        ),
      ],
    );
  }

  Widget _buildMovieWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: _betterPlayerController?.getAspectRatio() ?? 16 / 9,
          child: _betterPlayerController == null
              ? const Center(child: CircularProgressIndicator())
              : BetterPlayer(controller: _betterPlayerController!),
        ),
      ],
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    super.key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(trackHeight: 2.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            activeTrackColor: Colors.blue.shade100,
            inactiveTrackColor: Colors.grey.shade300,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(
                widget.bufferedPosition.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble(),
              ),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(
              _dragValue ?? widget.position.inMilliseconds.toDouble(),
              widget.duration.inMilliseconds.toDouble(),
            ),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
            RegExp(
                  r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$',
                ).firstMatch('$_remaining')?.group(1) ??
                '$_remaining',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}
