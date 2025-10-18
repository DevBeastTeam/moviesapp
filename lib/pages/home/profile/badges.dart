import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/assets/assets_icons.dart';
import '../../../utils/utils.dart';
import '../../../widgets/ui/custom_button.dart';

class ProfileBadges extends StatefulWidget {
  const ProfileBadges({
    super.key,
    required this.badges,
    required this.historyBadges,
  });

  final dynamic badges;
  final dynamic historyBadges;

  @override
  State<ProfileBadges> createState() => ProfileBadgesState();
}

class ProfileBadgesState extends State<ProfileBadges> {
  bool showMine = true;

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtils(context);

    if (screen.isTablet && screen.isLandscape) {
      return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        padding: const EdgeInsets.all(10),
        width: screen.width * 0.3,
        height: screen.width * 0.3,
        decoration: BoxDecoration(
          color: ColorsPallet.darkComponentBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  splashColor: Colors.white.withOpacity(.1),
                  highlightColor: Colors.white.withOpacity(.09),
                  onPressed: () => setState(() => showMine = true),
                  child: Container(
                    decoration: !showMine
                        ? null
                        : const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: ColorsPallet.blueAccent,
                                width: 2,
                              ),
                            ),
                          ),
                    child: const Text(
                      'MINE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                CustomButton(
                  splashColor: Colors.white.withOpacity(.1),
                  highlightColor: Colors.white.withOpacity(.09),
                  onPressed: () => setState(() => showMine = false),
                  child: Container(
                    decoration: showMine
                        ? null
                        : const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: ColorsPallet.blueAccent,
                                width: 2,
                              ),
                            ),
                          ),
                    child: const Text(
                      'TO UNLOCK',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 150,
              child: GridView.count(
                primary: false,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 3,
                children: [
                  if (showMine)
                    for (var history in widget.historyBadges)
                      if (history['Badge'] != null)
                        _buildComponent(badge: history['Badge']),
                  if (!showMine)
                    for (var badge in widget.badges)
                      _buildComponent(badge: badge),
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (screen.isTablet && !screen.isLandscape) {
      return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        padding: const EdgeInsets.all(10),
        width: screen.width * 0.43,
        height: screen.width * 0.43,
        decoration: BoxDecoration(
          color: ColorsPallet.darkComponentBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  splashColor: Colors.white.withOpacity(.1),
                  highlightColor: Colors.white.withOpacity(.09),
                  onPressed: () => setState(() => showMine = true),
                  child: Container(
                    decoration: !showMine
                        ? null
                        : const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: ColorsPallet.blueAccent,
                                width: 2,
                              ),
                            ),
                          ),
                    child: const Text(
                      'MINE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                CustomButton(
                  splashColor: Colors.white.withOpacity(.1),
                  highlightColor: Colors.white.withOpacity(.09),
                  onPressed: () => setState(() => showMine = false),
                  child: Container(
                    decoration: showMine
                        ? null
                        : const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: ColorsPallet.blueAccent,
                                width: 2,
                              ),
                            ),
                          ),
                    child: const Text(
                      'TO UNLOCK',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 150,
              child: GridView.count(
                primary: false,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 3,
                children: [
                  if (showMine)
                    for (var history in widget.historyBadges)
                      if (history['Badge'] != null)
                        _buildComponent(badge: history['Badge']),
                  if (!showMine)
                    for (var badge in widget.badges)
                      _buildComponent(badge: badge),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      margin: screen.isLandscape
          ? const EdgeInsets.all(8)
          : const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      padding: const EdgeInsets.all(16),
      width: 450,
      decoration: BoxDecoration(
        color: ColorsPallet.darkComponentBackground,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                splashColor: Colors.white.withOpacity(.1),
                highlightColor: Colors.white.withOpacity(.09),
                onPressed: () => setState(() => showMine = true),
                child: Container(
                  decoration: !showMine
                      ? null
                      : const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: ColorsPallet.blueAccent,
                              width: 2,
                            ),
                          ),
                        ),
                  child: const Text(
                    'MINE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              CustomButton(
                splashColor: Colors.white.withOpacity(.1),
                highlightColor: Colors.white.withOpacity(.09),
                onPressed: () => setState(() => showMine = false),
                child: Container(
                  decoration: showMine
                      ? null
                      : const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: ColorsPallet.blueAccent,
                              width: 2,
                            ),
                          ),
                        ),
                  child: const Text(
                    'TO UNLOCK',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screen.isLandscape && screen.isPhone ? 150 : 200,
            child: GridView.count(
              primary: false,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 3,
              children: [
                if (showMine)
                  for (var history in widget.historyBadges)
                    if (history['Badge'] != null)
                      _buildComponent(badge: history['Badge']),
                if (!showMine)
                  for (var badge in widget.badges)
                    _buildComponent(badge: badge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponent({required badge}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(128),
        child: SizedBox.fromSize(
          size: const Size(64, 64),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: getIn(badge, 'picture', ''),
                imageBuilder: (context, imageProvider) => Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      // fit: BoxFit.contain,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              if (!showMine)
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        spreadRadius: 64,
                        blurRadius: 64,
                      ),
                    ],
                  ),
                  child: const Icon(EdutainmentIcons.lock, size: 24),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
