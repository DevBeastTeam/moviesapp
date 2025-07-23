import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutainment/icons/icons_light.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/colors.dart';
import '../../../utils/utils.dart';
import '../../../widgets/indicators/custom_progress_bar.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      padding: const EdgeInsets.all(24),
      width: MediaQuery.of(context).size.width,
      // constraints: const BoxConstraints(maxHeight: 225),
      decoration: BoxDecoration(
        color: ColorsPallet.darkComponentBackground,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0.0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // context.go('/start');
                context.go('/home/settings');
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
                      gradient: const LinearGradient(colors: ColorsPallet.blb),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
