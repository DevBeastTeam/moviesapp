import 'dart:async';

// import 'package:better_player_plus/better_player.dart';
import 'package:better_player/src/controls/better_player_clickable_widget.dart';
import 'package:better_player/src/core/better_player_utils.dart';
import 'package:better_player/src/video_player/video_player.dart';
import 'package:better_player/better_player.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:edutainment/pages/movies/widgets/custom_video_progress_bar.dart';
import 'package:edutainment/utils/assets/assets_icons.dart';
import 'package:flutter/material.dart';

class CustomControlsWidget extends StatefulWidget {
  final BetterPlayerController? controller;
  final Function(bool visbility)? onControlsVisibilityChanged;
  final Function()? onFullScreenPressed;
  final List<Duration> stops;
  final bool isInLandScapeMode;

  const CustomControlsWidget({
    super.key,
    this.controller,
    this.onControlsVisibilityChanged,
    this.onFullScreenPressed,
    this.isInLandScapeMode = false,
    this.stops = const [],
  });

  @override
  _CustomControlsWidgetState createState() => _CustomControlsWidgetState();
}

class _CustomControlsWidgetState extends State<CustomControlsWidget> {
  ///Min. time of buffered video to hide loading timer (in milliseconds)
  static const int _bufferingInterval = 20000;

  VideoPlayerValue? _latestValue;
  BetterPlayerController? _betterPlayerController;
  bool _wasLoading = false;
  VideoPlayerController? _controller;

  Timer? _controlsTimer;
  bool _controlsVisible = true;

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    if (_controlsVisible) {
      _controlsTimer = Timer(const Duration(seconds: 3), () {
        if (widget.controller?.isPlaying() ?? false) {
          setState(() {
            _controlsVisible = false;
          });
        }
        if (mounted) {
          widget.onControlsVisibilityChanged?.call(_controlsVisible);
        }
      });
    }
  }

  bool isVideoFinished(VideoPlayerValue? videoPlayerValue) {
    return videoPlayerValue?.position != null &&
        videoPlayerValue?.duration != null &&
        videoPlayerValue!.position.inMilliseconds != 0 &&
        videoPlayerValue.duration!.inMilliseconds != 0 &&
        videoPlayerValue.position >= videoPlayerValue.duration!;
  }

  void _updateState() {
    if (mounted) {
      setState(() {
        _latestValue = _controller!.value;
        if (isVideoFinished(_latestValue) &&
            _betterPlayerController?.isLiveStream() == false) {
          // changePlayerControlsNotVisible(false);
          _resetControlsTimer();
        }
      });
      // if (!controlsNotVisible ||
      //     isVideoFinished(_controller!.value) ||
      //     _wasLoading ||
      //     isLoading(_controller!.value)) {
      //
      // }
    }
  }

  ///Latest value can be null
  bool isLoading(VideoPlayerValue? latestValue) {
    if (latestValue != null) {
      if (!latestValue.isPlaying && latestValue.duration == null) {
        return true;
      }

      final position = latestValue.position;

      Duration? bufferedEndPosition;
      if (latestValue.buffered.isNotEmpty == true) {
        bufferedEndPosition = latestValue.buffered.last.end;
      }

      if (bufferedEndPosition != null) {
        final difference = bufferedEndPosition - position;

        if (latestValue.isPlaying &&
            latestValue.isBuffering &&
            difference.inMilliseconds < _bufferingInterval) {
          return true;
        }
      }
    }
    return false;
  }

  void _initialize() {
    widget.controller?.videoPlayerController?.addListener(_updateState);
    _updateState();
  }

  @override
  void initState() {
    super.initState();
    _betterPlayerController = widget.controller;
    _controller = _betterPlayerController!.videoPlayerController;
    _initialize();
  }

  @override
  void didChangeDependencies() {
    final oldController = _betterPlayerController;
    _betterPlayerController = BetterPlayerController.of(context);
    _controller = _betterPlayerController!.videoPlayerController;
    _latestValue = _controller!.value;

    if (oldController != _betterPlayerController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  void _dispose() {
    _controller?.removeListener(_updateState);
  }

  @override
  Widget build(BuildContext context) {
    _wasLoading = isLoading(_latestValue);
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var iconScalingFactor = 1.0;
          if (constraints.maxHeight < 300) {
            iconScalingFactor = 0.6;
          } else if (constraints.maxHeight < 400) {
            iconScalingFactor = 0.75;
          }

          return GestureDetector(
            onTap: () {
              setState(() {
                _controlsVisible = !_controlsVisible;
              });
              _resetControlsTimer();
            },
            onVerticalDragUpdate: (_) {
              _resetControlsTimer();
            },
            onHorizontalDragUpdate: (_) {
              _resetControlsTimer();
            },
            child: !_controlsVisible
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.1),
                  )
                : _wasLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                var videoDuration = await widget
                                    .controller!
                                    .videoPlayerController!
                                    .position;
                                setState(() {
                                  if (widget.controller!.isPlaying()!) {
                                    var rewindDuration = Duration(
                                      seconds: (videoDuration!.inSeconds - 10),
                                    );
                                    if (rewindDuration <
                                        widget
                                            .controller!
                                            .videoPlayerController!
                                            .value
                                            .duration!) {
                                      widget.controller!.seekTo(
                                        const Duration(seconds: 0),
                                      );
                                    } else {
                                      widget.controller!.seekTo(rewindDuration);
                                    }
                                  }
                                });
                              },
                              child: Icon(
                                Icons.replay_10_rounded,
                                color: Colors.white,
                                size: 40 * iconScalingFactor,
                              ),
                            ),
                            const SizedBox(width: 40),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (widget.controller!.isPlaying()!) {
                                    widget.controller!.pause();
                                  } else {
                                    widget.controller!.play();
                                  }
                                });
                                _resetControlsTimer();
                              },
                              child: Icon(
                                widget.controller!.isPlaying()!
                                    ? Icons.pause
                                    : EdutainmentIcons.playEdutainment,
                                color: Colors.white,
                                size: 80 * iconScalingFactor,
                              ),
                            ),
                            const SizedBox(width: 40),
                            InkWell(
                              onTap: () async {
                                var videoDuration = await widget
                                    .controller!
                                    .videoPlayerController!
                                    .position;
                                setState(() {
                                  if (widget.controller!.isPlaying()!) {
                                    var forwardDuration = Duration(
                                      seconds: (videoDuration!.inSeconds + 10),
                                    );
                                    if (forwardDuration >
                                        widget
                                            .controller!
                                            .videoPlayerController!
                                            .value
                                            .duration!) {
                                      widget.controller!.seekTo(
                                        const Duration(seconds: 0),
                                      );
                                      widget.controller!.pause();
                                    } else {
                                      widget.controller!.seekTo(
                                        forwardDuration,
                                      );
                                    }
                                  }
                                });
                              },
                              child: Icon(
                                Icons.forward_10_rounded,
                                color: Colors.white,
                                size: 40 * iconScalingFactor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 10,
                        right: 10,
                        child: SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  _showSpeedChooserWidget();
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.slow_motion_video_outlined,
                                      color: Colors.white,
                                      size: 28,
                                      weight: 300,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.controller!.videoPlayerController!.value.speed}x',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildPosition(),
                                    SizedBox(
                                      height: 24,
                                      child: CustomVideoProgressBar(
                                        widget
                                            .controller!
                                            .videoPlayerController,
                                        widget.controller,
                                        onDragStart: () {
                                          widget.onControlsVisibilityChanged!(
                                            false,
                                          );
                                        },
                                        onDragEnd: () {
                                          widget.onControlsVisibilityChanged!(
                                            true,
                                          );
                                        },
                                        colors: BetterPlayerProgressColors(
                                          playedColor: Colors.white,
                                          handleColor: Colors.white,
                                          bufferedColor: Colors.white70,
                                          backgroundColor: Colors.white60,
                                        ),
                                        stops: widget.stops,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () async {
                                  _showSubtitlesSelectionWidget();
                                },
                                child: const Icon(
                                  Icons.subtitles_outlined,
                                  color: Colors.white,
                                  size: 28,
                                  weight: 100,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 10,
                        child: IconButton(
                          onPressed: () {
                            widget.onFullScreenPressed?.call();
                          },
                          icon: Icon(
                            widget.isInLandScapeMode
                                ? Icons.fullscreen_exit_rounded
                                : Icons.fullscreen,
                            color: Colors.white,
                            size: 28 * (iconScalingFactor + 0.2),
                            weight: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  void _showSpeedChooserWidget() {
    _showMaterialBottomSheet([
      _buildSpeedRow(0.25),
      _buildSpeedRow(0.5),
      _buildSpeedRow(0.75),
      _buildSpeedRow(1.0),
      _buildSpeedRow(1.25),
      _buildSpeedRow(1.5),
      _buildSpeedRow(1.75),
      _buildSpeedRow(2.0),
    ]);
  }

  Widget _buildSpeedRow(double value) {
    final isSelected =
        widget.controller!.videoPlayerController!.value.speed == value;

    return BetterPlayerMaterialClickableWidget(
      onTap: () {
        Navigator.of(context).pop();
        widget.controller!.setSpeed(value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            SizedBox(width: isSelected ? 8 : 16),
            Visibility(
              visible: isSelected,
              child: const Icon(Icons.check_outlined),
            ),
            const SizedBox(width: 16),
            Text(
              '$value x',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.black
                    : Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubtitlesSelectionWidget() {
    final subtitles = List.of(
      widget.controller!.betterPlayerSubtitlesSourceList,
    );
    final noneSubtitlesElementExists =
        subtitles.firstWhereOrNull(
          (source) => source.type == BetterPlayerSubtitlesSourceType.none,
        ) !=
        null;
    if (!noneSubtitlesElementExists) {
      subtitles.add(
        BetterPlayerSubtitlesSource(type: BetterPlayerSubtitlesSourceType.none),
      );
    }

    subtitles.removeWhere(
      (element) => !(element.name ?? '').toLowerCase().contains('english'),
    );

    _showMaterialBottomSheet(
      subtitles.map((source) => _buildSubtitlesSourceRow(source)).toList(),
    );
  }

  Widget _buildSubtitlesSourceRow(BetterPlayerSubtitlesSource subtitlesSource) {
    final selectedSourceType = widget.controller!.betterPlayerSubtitlesSource;
    final isSelected =
        (subtitlesSource == selectedSourceType) ||
        (subtitlesSource.type == BetterPlayerSubtitlesSourceType.none &&
            subtitlesSource.type == selectedSourceType!.type);

    return BetterPlayerMaterialClickableWidget(
      onTap: () {
        Navigator.of(context).pop();
        if (isSelected) {
          widget.controller!.setupSubtitleSource(BetterPlayerSubtitlesSource());
        } else {
          widget.controller!.setupSubtitleSource(subtitlesSource);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            SizedBox(width: isSelected ? 8 : 16),
            Visibility(
              visible: isSelected,
              child: const Icon(Icons.check_outlined, color: Colors.black),
            ),
            const SizedBox(width: 16),
            Text(
              subtitlesSource.type == BetterPlayerSubtitlesSourceType.none
                  ? widget.controller!.translations.generalNone
                  : subtitlesSource.name ??
                        widget.controller!.translations.generalDefault,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Colors.black
                    : Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosition() {
    var latestValue = widget.controller?.videoPlayerController?.value;
    final position = latestValue != null ? latestValue.position : Duration.zero;
    final duration = latestValue != null && latestValue.duration != null
        ? latestValue.duration!
        : Duration.zero;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          BetterPlayerUtils.formatDuration(position),
          style: const TextStyle(
            fontSize: 10.0,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
        Text(
          BetterPlayerUtils.formatDuration(duration),
          style: const TextStyle(
            fontSize: 10.0,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  void _showMaterialBottomSheet(List<Widget> children) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      useRootNavigator:
          widget.controller?.betterPlayerConfiguration.useRootNavigator ??
          false,
      builder: (context) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Column(children: children),
            ),
          ),
        );
      },
    );
  }
}
