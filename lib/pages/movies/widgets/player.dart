import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:better_player/better_player.dart';
import 'package:edutainment/controllers/movies_controller.dart';
import 'package:edutainment/pages/movies/widgets/custom_controls.dart';
import 'package:edutainment/pages/quiz/questions/answers/answer.dart';
import 'package:edutainment/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../utils/questions.dart';
import '../../../utils/utils.dart';
import '../../../widgets/header_bar/custom_header_bar.dart';

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
  bool _hasHandledError =
      false; // Prevent error handler from running multiple times

  late List tempQuestions = [];
  int nextQuestionIndex = 0;

  late List<Duration> stops = [];

  late bool showQuestion = false;
  bool completedAllQuestions = false;
  late dynamic currentQuestion;
  String selectedRadioOption = '';
  int progressSeconds = 0;

  String previousType = '';
  final MoviesController _moviesController = Get.find<MoviesController>();

  Future<void> sendPlayerEvent(String type) async {
    if (previousType == 'ended') {
      return;
    }
    previousType = type;

    final id = getIn(widget.movie, '_id');
    if (id == null || id.toString().isEmpty) {
      debugPrint('⚠️ Cannot send player event: Movie ID is null');
      return;
    }

    final time =
        _betterPlayerController
            ?.videoPlayerController
            ?.value
            .position
            .inSeconds ??
        0;

    // Use controller method instead of direct API call
    await _moviesController.updateMovieHistory(
      id.toString(),
      status: type,
      time: time,
    );
  }

  void setupPlayer() {
    // ===== DEBUG: Print all movie details to console =====
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('🎬 MOVIE DETAILS DEBUG:');
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('📌 Movie ID: ${getIn(widget.movie, '_id')}');
    debugPrint('📌 Label: ${getIn(widget.movie, 'label')}');
    debugPrint('📌 Description: ${getIn(widget.movie, 'description')}');
    debugPrint('📌 Duration: ${getIn(widget.movie, 'duration')}');
    debugPrint('───────────────────────────────────────────────────────────');
    debugPrint('🔗 VIDEO LINKS:');
    debugPrint('   M3U8 (HLS): ${getIn(widget.movie, 'm3u8_link')}');
    debugPrint('   MPD (DASH): ${getIn(widget.movie, 'mpd_link')}');
    debugPrint('───────────────────────────────────────────────────────────');
    debugPrint('🖼️ Picture: ${getIn(widget.movie, 'picture')}');
    debugPrint('📚 Subject: ${getIn(widget.movie, 'Subject')}');
    debugPrint('🏷️ Tags: ${getIn(widget.movie, 'tags')}');
    debugPrint('📅 Created: ${getIn(widget.movie, 'createdAt')}');
    debugPrint('📅 Updated: ${getIn(widget.movie, 'updatedAt')}');
    debugPrint('✅ Enabled: ${getIn(widget.movie, 'enabled')}');
    debugPrint('📋 Reference: ${getIn(widget.movie, 'reference')}');
    debugPrint('👤 Profiles: ${getIn(widget.movie, 'profiles')}');
    debugPrint('───────────────────────────────────────────────────────────');
    debugPrint('📱 Platform: ${Platform.isIOS ? 'iOS' : 'Android'}');
    debugPrint(
      '🎥 Using format: ${Platform.isIOS ? 'HLS (m3u8)' : 'DASH (mpd)'}',
    );
    debugPrint('═══════════════════════════════════════════════════════════');

    // Print full movie object for complete debugging
    debugPrint('📦 FULL MOVIE OBJECT:');
    widget.movie.forEach((key, value) {
      debugPrint('   $key: $value');
    });
    debugPrint('═══════════════════════════════════════════════════════════');
    // ===== END DEBUG =====

    // Select the appropriate video URL based on platform
    // iOS uses HLS (m3u8) for FairPlay DRM
    // Android uses DASH (mpd) for Widevine DRM
    final String? m3u8Link = getIn(widget.movie, 'm3u8_link');
    final String? mpdLink = getIn(widget.movie, 'mpd_link');

    // Determine which URL to use
    String videoUrl;
    BetterPlayerVideoFormat videoFormat;

    if (Platform.isIOS) {
      // iOS: Prefer HLS, fallback to MPD
      if (m3u8Link != null && m3u8Link.isNotEmpty) {
        videoUrl = m3u8Link;
        videoFormat = BetterPlayerVideoFormat.hls;
      } else if (mpdLink != null && mpdLink.isNotEmpty) {
        videoUrl = mpdLink;
        videoFormat = BetterPlayerVideoFormat.dash;
      } else {
        debugPrint('❌ No valid video URL found!');
        videoUrl = '';
        videoFormat = BetterPlayerVideoFormat.hls;
      }
    } else {
      // Android: Prefer DASH (MPD), fallback to HLS
      if (mpdLink != null && mpdLink.isNotEmpty) {
        videoUrl = mpdLink;
        videoFormat = BetterPlayerVideoFormat.dash;
      } else if (m3u8Link != null && m3u8Link.isNotEmpty) {
        videoUrl = m3u8Link;
        videoFormat = BetterPlayerVideoFormat.hls;
      } else {
        debugPrint('❌ No valid video URL found!');
        videoUrl = '';
        videoFormat = BetterPlayerVideoFormat.dash;
      }
    }

    debugPrint('🎬 Selected video URL: $videoUrl');
    debugPrint('🎬 Selected format: $videoFormat');

    // Check if DRM is needed based on URL pattern
    // S3 bucket content (e-dutainment.s3) is NOT DRM protected
    // CloudFront content (swankmp) IS DRM protected
    final bool isDrmProtected =
        videoUrl.contains('swankmp') ||
        videoUrl.contains('cloudfront') ||
        videoUrl.contains('d2cj5ez5n4d4vx');

    debugPrint('🔐 DRM Protected: $isDrmProtected');

    BetterPlayerDrmConfiguration? drmConfig;
    if (isDrmProtected) {
      drmConfig = Platform.isIOS
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
            );
    }

    final betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrl,
      videoFormat: videoFormat,
      drmConfiguration: drmConfig,
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
      // Handle playback errors (404, network errors, etc.)
      if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
        // Only handle error once to prevent infinite loop
        if (_hasHandledError) return;
        _hasHandledError = true;

        debugPrint('❌ Video playback error: ${event.parameters}');
        debugPrint(
          '❌ Error type: Response code 404 - Video file not found on server',
        );

        // Immediately remove listener to prevent more events
        _betterPlayerController?.removeEventsListener((event) {});

        // Safely dispose
        try {
          _betterPlayerController?.pause();
          _betterPlayerController?.dispose();
          _betterPlayerController = null;
        } catch (e) {
          debugPrint('Error disposing player: $e');
        }

        // Show error and navigate back
        if (mounted) {
          EasyLoading.showError(
            'Video not available\nPlease try another movie',
            duration: const Duration(seconds: 2),
          );

          // Navigate back immediately
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }
        return;
      }

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
        // Get screen width for responsive design
        final screenWidth = MediaQuery.of(context).size.width;
        final isTablet = screenWidth >= 600;

        await AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dismissOnTouchOutside: false,
          dialogType: DialogType.noHeader,
          borderSide: BorderSide(width: 1, color: Colors.white),
          body: Container(
            padding: EdgeInsets.all(isTablet ? 32 : 24),
            decoration: BoxDecoration(
              color: const Color(0xFF424242),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Red question mark icon
                Container(
                  width: isTablet ? 100 : 80,
                  height: isTablet ? 100 : 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE53935),
                      width: 4,
                    ),
                  ),
                  child: Icon(
                    Icons.question_mark_rounded,
                    size: isTablet ? 56 : 48,
                    color: const Color(0xFFE53935),
                    weight: 700,
                  ),
                ),
                SizedBox(height: isTablet ? 32 : 24),
                // Title text
                Text(
                  'I want to answer questions:',
                  style: TextStyle(
                    fontSize: isTablet ? 24 : 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isTablet ? 32 : 24),
                // While watching button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade600, width: 2),
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        // const Color(0xFF1A3A52),
                        const Color(0xFF0B2349),
                        const Color(0xFF000000),
                        // const Color.fromARGB(255, 3, 17, 38),
                      ],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          questionChoice = 'during';
                        });
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 24 : 20,
                          horizontal: 16,
                        ),
                        child: Text(
                          'While watching',
                          style: TextStyle(
                            fontSize: isTablet ? 22 : 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 20 : 16),
                // Once the film is over button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade600, width: 2),
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        // const Color(0xFF1A3A52),
                        const Color(0xFF0B2349),
                        const Color(0xFF000000),
                        // const Color.fromARGB(255, 3, 17, 38),
                      ],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          questionChoice = 'ending';
                        });
                        Navigator.of(context).pop();
                        onTappedFullScreen();
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 24 : 20,
                          horizontal: 16,
                        ),
                        child: Text(
                          'Once the film is over',
                          style: TextStyle(
                            fontSize: isTablet ? 22 : 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
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
  void dispose() {
    // Send paused event without awaiting to avoid async dispose
    sendPlayerEvent('paused').catchError((e) {
      debugPrint('Error sending paused event on dispose: $e');
    });

    _betterPlayerController?.dispose();

    // Reset to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  Widget movieQuestionBuilder() {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    List questionAnswers = getIn(currentQuestion, 'answers', []);

    // Determine grid columns based on orientation and device
    int crossAxisCount;
    if (isInLandScapeMode) {
      crossAxisCount = isTablet ? 4 : 2;
    } else {
      crossAxisCount = isTablet ? 2 : 1;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 12,
        vertical: isTablet ? 12 : 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isInLandScapeMode) SizedBox(height: isTablet ? 24 : 16),
          if (!isInLandScapeMode)
            Align(
              alignment: Alignment.center,
              child: Text(
                currentQuestion['label'] ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? 22 : 18,
                ),
              ),
            ),
          if (!isInLandScapeMode) SizedBox(height: isTablet ? 24 : 16),
          MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: isTablet ? 16 : (isInLandScapeMode ? 8 : 12),
            crossAxisSpacing: isTablet ? 16 : (isInLandScapeMode ? 8 : 12),
            itemCount: questionAnswers.length,
            itemBuilder: (context, index) {
              final currentAnswer = questionAnswers[index];
              return GestureDetector(
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
              );
            },
          ),
          SizedBox(height: isTablet ? 16 : 12),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    return Stack(
      children: [
        // Main content
        SizedBox(
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - only in portrait
              if (!isInLandScapeMode)
                CustomHeaderBar(
                  onBack: () async {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  centerTitle: false,
                  titleStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 20 : 16,
                  ),
                  title: getIn(widget.movie, 'label'),
                ),

              // Video player
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
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : BetterPlayer(controller: _betterPlayerController!),
                    ),
                  ),
                ),
              ),

              // Portrait mode content below video
              if (!isInLandScapeMode) ...[
                // No more questions message
                if (tempQuestions.isEmpty && completedAllQuestions)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 20,
                      ),
                      child: Center(child: buildNoMoreQuestions()),
                    ),
                  ),

                // Question counter when no question is showing
                if (currentQuestion == null && !completedAllQuestions)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 12 : 6,
                        horizontal: isTablet ? 24 : 12,
                      ),
                      child: Center(child: buildNextQuestionCounter()),
                    ),
                  ),

                // Question and answers in portrait
                if (showQuestion && currentQuestion != null)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 12 : 6,
                        horizontal: isTablet ? 24 : 12,
                      ),
                      child: Center(child: movieQuestionBuilder()),
                    ),
                  ),
              ],
            ],
          ),
        ),

        // Landscape mode - Back button
        if (isInLandScapeMode)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),

        // Landscape mode - Question overlay on top of video
        if (isInLandScapeMode && showQuestion && currentQuestion != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              constraints: BoxConstraints(maxHeight: screenHeight * 0.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.2, 1.0],
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 40,
                  left: isTablet ? 40 : 20,
                  right: isTablet ? 40 : 20,
                  bottom: isTablet ? 24 : 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Question label
                    Text(
                      currentQuestion['label'] ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 20 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    // Answers
                    movieQuestionBuilder(),
                  ],
                ),
              ),
            ),
          ),

        // Landscape mode - Question counter overlay (when no question showing)
        if (isInLandScapeMode &&
            !showQuestion &&
            currentQuestion == null &&
            questionChoice == 'during')
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: isTablet ? 16 : 12,
                horizontal: isTablet ? 32 : 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
              child: buildNextQuestionCounter(),
            ),
          ),
      ],
    );
  }

  Widget buildNextQuestionCounter() {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    var progress = Duration(seconds: progressSeconds);
    var start = Duration(
      seconds: tempQuestions.isNotEmpty ? tempQuestions[0]['start'] : 0,
    );
    var diff = start - progress;
    if (diff.isNegative && tempQuestions.isNotEmpty) {
      // remove the first question only if list is not empty
      tempQuestions.removeAt(0);
      start = Duration(
        seconds: tempQuestions.isNotEmpty ? tempQuestions[0]['start'] : 0,
      );
      diff = start - progress;
    }

    // Ensure diff is not negative for display
    if (diff.isNegative) {
      diff = Duration.zero;
    }

    // convert to minutes:seconds
    var diffInMins = diff.inMinutes;
    var diffInSeconds = diff.inSeconds - (diff.inMinutes * 60);

    var currentQuestionIndex = widget.questions.length - tempQuestions.length;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 12,
              vertical: isTablet ? 10 : 5,
            ),
            child: Text(
              '${widget.questions.length} questions matching your level are available for this film',
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 22 : 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 8),
          if (tempQuestions.isNotEmpty && questionChoice == 'during')
            Wrap(
              runSpacing: isTablet ? 8 : 4,
              spacing: isTablet ? 10 : 6,
              alignment: WrapAlignment.center,
              children: [
                for (int i = 0; i < widget.questions.length; i++)
                  Container(
                    height: isTablet ? 24 : 16,
                    width: isTablet ? 24 : 16,
                    decoration: BoxDecoration(
                      color: i < currentQuestionIndex
                          ? ColorsPallet
                                .blueAccent // Completed - Blue
                          : i == currentQuestionIndex
                          ? Colors
                                .white // Current - White
                          : Colors.white.withOpacity(.3), // Upcoming - Faded
                      borderRadius: BorderRadius.circular(isTablet ? 6 : 4),
                      border: i == currentQuestionIndex
                          ? Border.all(color: ColorsPallet.blueAccent, width: 2)
                          : null,
                    ),
                  ),
              ],
            ),
          SizedBox(height: isTablet ? 20 : 10),
          if (tempQuestions.isNotEmpty && questionChoice == 'during')
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 32 : 16,
                vertical: isTablet ? 12 : 8,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: ColorsPallet.blueAccent,
                    size: isTablet ? 24 : 20,
                  ),
                  SizedBox(width: isTablet ? 12 : 8),
                  Text(
                    "Next question in ",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: isTablet ? 18 : 14,
                    ),
                  ),
                  Text(
                    "${diffInMins.toString().padLeft(2, '0')}:${diffInSeconds.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: ColorsPallet.blueAccent,
                      fontSize: isTablet ? 22 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          if (tempQuestions.isEmpty && questionChoice == 'during')
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 32 : 16,
                vertical: isTablet ? 12 : 8,
              ),
              decoration: BoxDecoration(
                color: ColorsPallet.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: ColorsPallet.blueAccent,
                    size: isTablet ? 24 : 20,
                  ),
                  SizedBox(width: isTablet ? 12 : 8),
                  Text(
                    "All questions completed!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 18 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildNoMoreQuestions() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.celebration,
          color: ColorsPallet.blueAccent,
          size: isTablet ? 64 : 48,
        ),
        SizedBox(height: isTablet ? 24 : 16),
        Text(
          'That\'s all for now!',
          style: TextStyle(
            color: ColorsPallet.blueAccent,
            fontSize: isTablet ? 28 : 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16),
          child: Text(
            'We hope you enjoyed the questions. Keep practicing and get ready for more!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: isTablet ? 18 : 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
