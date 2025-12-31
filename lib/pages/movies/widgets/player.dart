import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:edutainment/controllers/movies_controller.dart';
import 'package:edutainment/pages/movies/widgets/custom_controls.dart';
import 'package:edutainment/pages/quiz/questions/answers/answer.dart';
import 'package:edutainment/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../utils/questions.dart';
import '../../../utils/utils.dart';
import '../../../widgets/card_3d.dart';
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

class _MoviePlayer extends State<MoviePlayer>
    with AutomaticKeepAliveClientMixin {
  late BetterPlayerController? _betterPlayerController;

  bool isInLandScapeMode = false;
  bool _targetLandscape = false;

  late String questionChoice = '';
  bool _hasHandledError =
      false; // Prevent error handler from running multiple times
  bool _isDisposing = false;

  late List tempQuestions = [];
  int nextQuestionIndex = 0;

  late List<Duration> stops = [];

  late bool showQuestion = false;
  bool completedAllQuestions = false;
  late dynamic currentQuestion;
  String selectedRadioOption = '';
  int progressSeconds = 0;
  Timer? _countdownTimer; // Timer for smooth countdown updates

  String previousType = '';
  final MoviesController _moviesController = Get.find<MoviesController>();
  void Function(BetterPlayerEvent)? _playerEventListener;

  @override
  bool get wantKeepAlive => true;

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

  void _handlePlayerEvent(BetterPlayerEvent event) {
    if (_isDisposing || !mounted) return;

    // Check if widget tree is locked
    if (WidgetsBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      // Defer processing until after current frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_isDisposing) {
          _handlePlayerEvent(event);
        }
      });
      return;
    }

    // Handle playback errors (404, network errors, etc.)
    if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
      // Only handle error once to prevent infinite loop
      if (_hasHandledError) return;
      _hasHandledError = true;

      debugPrint('❌ Video playback error: ${event.parameters}');
      debugPrint(
        '❌ Error type: Response code 404 - Video file not found on server',
      );

      // Remove the actual listener, not an empty one
      if (_playerEventListener != null) {
        _betterPlayerController?.removeEventsListener(_playerEventListener!);
        _playerEventListener = null;
      }

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

        // Force a rebuild to update the timer
        if (mounted) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_isDisposing) {
              setState(() {
                progressSeconds = progress.inSeconds;
              });
            }
          });
        }

        if (questionChoice == 'during' && tempQuestions.isNotEmpty) {
          // Check if we should show a new question
          if (showQuestion == false) {
            var q = tempQuestions[0];
            int questionStart = int.tryParse('${q['start']}') ?? 0;

            if (progress.inSeconds >= questionStart) {
              debugPrint(
                '🎯 MATCH: Showing question "${q['label']}" at ${progress.inSeconds}s',
              );
              if (mounted) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_isDisposing) {
                    setState(() {
                      showQuestion = true;
                      currentQuestion = q;
                    });
                  }
                });
              }
            }
          } else {
            // We are currently showing a question. Check if it's time to hide it.
            int questionEnd = int.tryParse('${currentQuestion['end']}') ?? 0;

            if (progress.inSeconds >= questionEnd) {
              debugPrint(
                '✅ FINISHED: Hiding question at ${progress.inSeconds}s',
              );
              final questionId = getIn(currentQuestion, '_id');
              if (mounted) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_isDisposing) {
                    setState(() {
                      showQuestion = false;
                      currentQuestion = null;
                      selectedRadioOption = '';
                    });
                  }
                });
              }
              // Remove the finished question from the list
              tempQuestions.removeWhere(
                (item) => '${item['_id']}' == '$questionId',
              );
            }
          }

          // Safety check: if video jumped ahead past multiple questions,
          // remove those that are already in the past
          if (!showQuestion && tempQuestions.isNotEmpty) {
            int nextStart = int.tryParse('${tempQuestions[0]['start']}') ?? 0;
            if (progress.inSeconds > nextStart + 5) {
              // 5s grace period
              debugPrint(
                '⏩ SKIPPING: Removing passed question "${tempQuestions[0]['label']}"',
              );
              if (mounted) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_isDisposing) {
                    setState(() {
                      tempQuestions.removeAt(0);
                    });
                  }
                });
              }
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
        if (mounted) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_isDisposing) {
              setState(() {
                showQuestion = true;
                currentQuestion = tempQuestions[0];
              });
            }
          });
        }
      }
    }
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
        // Prevent Better Player from managing orientation - we handle it ourselves
        fullScreenByDefault: false,
        deviceOrientationsOnFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
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
            );
          },
        ),
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );

    // Store the event listener as a member variable for proper lifecycle management
    _playerEventListener = _handlePlayerEvent;
    _betterPlayerController?.addEventsListener(_playerEventListener!);

    if (questionChoice == '') {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        bool res = await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                // side: BorderSide(color: Color(0XFF3087DE), width: 2),
              ),
              backgroundColor: Color(0XFF0B2845),
              child: Card3D(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.question_mark_rounded,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "I want to answer questions:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0XFF0E3358),
                                Color.fromARGB(255, 6, 23, 39),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: const Text(
                            '    While watching    ',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(20),
                            ),
                            side: BorderSide(color: Colors.white),
                          ),
                          child: const Text(
                            'Once the film is over',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
        if (res == true) {
          debugPrint('🔔 User selected: DURING (while watching)');
          setState(() {
            questionChoice = 'during';
          });
        } else {
          debugPrint('🔔 User selected: ENDING (once film is over)');
          setState(() {
            questionChoice = 'ending';
          });
        }
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
    setState(() {
      _targetLandscape = !_targetLandscape;
    });

    // Always allow all orientations so the device can naturally rotate
    // The _targetLandscape flag is used for UI logic (transform fallback)
    // but we don't force restrict orientations anymore to prevent auto-rotation back
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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

    // Allow all orientations for automatic rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Start a timer to update the countdown every second for smooth display
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && questionChoice == 'during' && !showQuestion) {
        setState(() {
          // This will trigger a rebuild to update the countdown display
        });
      }
    });
  }

  @override
  void dispose() {
    _isDisposing = true;

    // Cancel the countdown timer
    _countdownTimer?.cancel();

    // Remove event listener before disposing controller
    if (_playerEventListener != null) {
      _betterPlayerController?.removeEventsListener(_playerEventListener!);
      _playerEventListener = null;
    }

    // Send paused event without awaiting to avoid async dispose
    sendPlayerEvent('paused').catchError((e) {
      debugPrint('Error sending paused event on dispose: $e');
    });

    _betterPlayerController?.dispose();

    // Reset to portrait and restore system UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Restore normal system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

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
    super.build(context); // Required by AutomaticKeepAliveClientMixin
    return OrientationBuilder(
      builder: (context, orientation) {
        // Automatically detect device orientation
        final bool nativeLandscape = orientation == Orientation.landscape;

        // We want landscape if the device is actually in landscape
        // OR if the user explicitly requested landscape mode (transform fallback)
        final bool effectiveLandscape = nativeLandscape || _targetLandscape;

        // Perform side effects after build to avoid issues
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (effectiveLandscape) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          } else {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          }
        });

        // Determine if we need to force rotation (transform)
        // This happens if user wants landscape but device stays in portrait
        final bool forceTransform = _targetLandscape && !nativeLandscape;

        Widget content = _buildScaffoldContent(context, effectiveLandscape);

        if (forceTransform) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: RotatedBox(
                quarterTurns: 1,
                child: SizedBox(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.height,
                  child: MediaQuery(
                    data: MediaQueryData(
                      // Essential overrides for rotation:
                      size: Size(
                        MediaQuery.of(context).size.height,
                        MediaQuery.of(context).size.width,
                      ),

                      // Copy rest from context:
                      devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
                      textScaler: TextScaler.linear(
                        MediaQuery.of(context).textScaleFactor,
                      ),
                      platformBrightness: MediaQuery.of(
                        context,
                      ).platformBrightness,
                      padding: MediaQuery.of(context).padding,
                      viewInsets: MediaQuery.of(context).viewInsets,
                      systemGestureInsets: MediaQuery.of(
                        context,
                      ).systemGestureInsets,
                      viewPadding: MediaQuery.of(context).viewPadding,
                      alwaysUse24HourFormat: MediaQuery.of(
                        context,
                      ).alwaysUse24HourFormat,
                      accessibleNavigation: MediaQuery.of(
                        context,
                      ).accessibleNavigation,
                      invertColors: MediaQuery.of(context).invertColors,
                      disableAnimations: MediaQuery.of(
                        context,
                      ).disableAnimations,
                      boldText: MediaQuery.of(context).boldText,
                    ),
                    child: content,
                  ),
                ),
              ),
            ),
          );
        }

        return content;
      },
    );
  }

  Widget _buildScaffoldContent(BuildContext context, bool isLandscape) {
    // Get screen dimensions (safe to use context here as it will be wrapped if transformed)
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main content
          SizedBox(
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header - only in portrait/compact mode
                if (!isLandscape)
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
                  flex: isLandscape ? 1 : 0,
                  key: const Key('betterPlayer'),
                  child: Center(
                    child: Container(
                      color: Colors.black,
                      child: _betterPlayerController == null
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                // Create BetterPlayer widget once with stable key
                                final playerWidget = BetterPlayer(
                                  key: const ValueKey('better_player'),
                                  controller: _betterPlayerController!,
                                );

                                // Wrap in appropriate layout based on orientation
                                return isLandscape
                                    ? SizedBox(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: playerWidget,
                                      )
                                    : AspectRatio(
                                        aspectRatio:
                                            _betterPlayerController
                                                ?.getAspectRatio() ??
                                            16 / 9,
                                        child: playerWidget,
                                      );
                              },
                            ),
                    ),
                  ),
                ),

                // Portrait mode content below video
                if (!isLandscape) ...[
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
          if (isLandscape)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                // Wrap with SafeArea to avoid notch if native
                child: SafeArea(
                  child: IconButton(
                    onPressed: () {
                      // If forced landscape, just toggle back
                      if (_targetLandscape) {
                        onTappedFullScreen();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
            ),

          // Landscape mode - Question overlay on top of video
          if (isLandscape && showQuestion && currentQuestion != null)
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
          if (isLandscape &&
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
      ),
    );
  }

  Widget buildNextQuestionCounter() {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    var progress = Duration(seconds: progressSeconds);
    var start = Duration(
      seconds: tempQuestions.isNotEmpty
          ? (int.tryParse('${tempQuestions[0]['start']}') ?? 0)
          : 0,
    );
    var diff = start - progress;

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
              'Number of questions matching your level for this content: ${widget.questions.length} ',
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
                          ? ColorsPallet.blueAccent
                          : Colors.white, // Upcoming - Faded
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
