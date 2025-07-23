import 'package:better_player/better_player.dart';
import 'package:edutainment/utils/assets/assets_icons.dart';
import 'package:flutter/material.dart';

class SimpleCustomPlayerControls extends StatelessWidget {
  const SimpleCustomPlayerControls({required this.controller, super.key});

  final BetterPlayerController controller;

  void _onTap() {
    controller.setControlsVisibility(true);
    if (controller.isPlaying()!) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void _controlVisibility() {
    controller.setControlsVisibility(true);
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (controller.isPlaying()!) {
        controller.setControlsVisibility(false);
      } else {
        controller.setControlsVisibility(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _controlVisibility,
      child: StreamBuilder(
        initialData: false,
        stream: controller.controlsVisibilityStream,
        builder: (context, snapshot) {
          return Stack(
            children: [
              Visibility(
                visible: snapshot.data!,
                child: Positioned(
                  child: Center(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: _onTap,
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: controller.isPlaying()!
                            ? const Icon(
                                Icons.pause,
                                color: Colors.white,
                                size: 60,
                              )
                            : const Icon(
                                EdutainmentIcons.playEdutainment,
                                color: Colors.white,
                                size: 60,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
