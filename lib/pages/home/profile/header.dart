import 'package:edutainment/widgets/card_3d.dart';

import '../../flashcards/flashcardslist.dart';
import 'profile_settings_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutainment/icons/icons_light.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/appimages.dart';
import '../../../utils/screen_utils.dart';
import '../../../theme/colors.dart';
import '../../../utils/utils.dart';
import '../../../widgets/indicators/custom_progress_bar.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtils(context);

    if (screen.isTablet && screen.isLandscape) {
      return Card3D(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        child: Container(
          // margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
          padding: const EdgeInsets.all(10),
          width: screen.width * 0.35,
          height: screen.height * 0.3,
          // constraints: const BoxConstraints(maxHeight: 225),
          decoration: BoxDecoration(
            color: ColorsPallet.borderCardBgColor,
            borderRadius: BorderRadius.circular(32),
            // border: Border.all(
            //   width: 1,
            //   color: ColorsPallet.borderCardBorderColor,
            // ),
          ),

          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          // context.go('/start');
                          Get.to(() => const ProfileSettingsPage());
                        },
                        child: const Icon(AppIconsLight.gear, size: 18),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const FlashCardsListPage());
                        },
                        child: Image.asset(
                          AppImages.flashcardsblue,
                          width: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${getIn(user, 'name.given_name', '')}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Text(
                            getIn(user, 'Level.label', ''),
                            style: const TextStyle(
                              shadows: [
                                Shadow(
                                  color: ColorsPallet.shadow,
                                  blurRadius: 16,
                                ),
                              ],
                              color: ColorsPallet.blueComponent,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(128),
                        child: CachedNetworkImage(
                          imageUrl: getIn(user, 'Level.picture', ''),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                // fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            '${getIn(user, 'score', 0)}/${getIn(user, 'Level.score.max', 0)}'
                            '',
                          ),
                        ),
                        CustomProgressBar(
                          height: 10,
                          width: MediaQuery.of(context).size.width,
                          value:
                              getIn(user, 'score', 0) /
                              getIn(user, 'Level.score.max', 0),
                          radius: 16,
                          backgroundColor: ColorsPallet.blue,
                          accentColor: ColorsPallet.blueAccent,
                          gradient: const LinearGradient(
                            colors: ColorsPallet.blb,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      );
    }
    if (screen.isTablet && !screen.isLandscape) {
      return Card3D(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        child: Container(
          // margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
          padding: const EdgeInsets.all(10),
          width: screen.width * 1,
          // height: screen.height * 0.28,
          // constraints: const BoxConstraints(maxHeight: 225),
          decoration: BoxDecoration(
            color: ColorsPallet.borderCardBgColor,
            borderRadius: BorderRadius.circular(32),
            // border: Border.all(
            //   width: 1,
            //   color: ColorsPallet.borderCardBorderColor,
            // ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          // context.go('/start');
                          Get.to(() => const ProfileSettingsPage());
                        },
                        child: const Icon(AppIconsLight.gear, size: 18),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const FlashCardsListPage());
                        },
                        child: Image.asset(
                          AppImages.flashcardsblue,
                          width: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(128),
                        child: CachedNetworkImage(
                          imageUrl: getIn(user, 'Level.picture', ''),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                // fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${getIn(user, 'name.given_name', '')}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      Text(
                        getIn(user, 'Level.label', ''),
                        style: const TextStyle(
                          shadows: [
                            Shadow(color: ColorsPallet.shadow, blurRadius: 16),
                          ],
                          color: ColorsPallet.blueComponent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            '${getIn(user, 'score', 0)}/${getIn(user, 'Level.score.max', 0)}'
                            '',
                          ),
                        ),
                        CustomProgressBar(
                          height: 10,
                          width: MediaQuery.of(context).size.width,
                          value:
                              getIn(user, 'score', 0) /
                              getIn(user, 'Level.score.max', 0),
                          radius: 16,
                          backgroundColor: ColorsPallet.blue,
                          accentColor: ColorsPallet.blueAccent,
                          gradient: const LinearGradient(
                            colors: ColorsPallet.blb,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Card3D(
        margin: screen.isLandscape
            ? const EdgeInsets.all(8)
            : const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
        child: Container(
          // margin: screen.isLandscape
          //     ? const EdgeInsets.all(8)
          //     : const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
          padding: const EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          // constraints: const BoxConstraints(maxHeight: 225),
          decoration: BoxDecoration(
            color: ColorsPallet.borderCardBgColor,
            borderRadius: BorderRadius.circular(32),

            // border: Border.all(
            //   width: 1,
            //   color: ColorsPallet.borderCardBorderColor,
            // ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0.0,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    // context.go('/start');
                    Get.to(() => const ProfileSettingsPage());
                  },
                  child: const Icon(AppIconsLight.gear, size: 18),
                ), //Icon
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(128),
                        child: CachedNetworkImage(
                          imageUrl: getIn(user, 'Level.picture', ''),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 85,
                            width: 85,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                // fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getIn(user, 'Level.label', ''),
                              style: const TextStyle(
                                shadows: [
                                  Shadow(
                                    color: ColorsPallet.shadow,
                                    blurRadius: 16,
                                  ),
                                ],
                                color: ColorsPallet.blueComponent,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const FlashCardsListPage());
                              },
                              child: Image.asset(
                                AppImages.flashcardsblue,
                                width: 30,
                                color: Colors.white,
                              ),
                            ),
                            // Image.network('name')
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${getIn(user, 'name.given_name', '')}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            '${getIn(user, 'score', 0)}/${getIn(user, 'Level.score.max', 0)}'
                            '',
                          ),
                        ),
                        CustomProgressBar(
                          height: 20,
                          width: MediaQuery.of(context).size.width,
                          value:
                              getIn(user, 'score', 0) /
                              getIn(user, 'Level.score.max', 0),
                          radius: 16,
                          backgroundColor: ColorsPallet.blue,
                          accentColor: ColorsPallet.blueAccent,
                          gradient: const LinearGradient(
                            colors: ColorsPallet.blb,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
