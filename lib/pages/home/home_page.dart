import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/utils.dart';
import '../../utils/screen_utils.dart';
import '../../theme/colors.dart';
import '../../utils/boxes.dart';
import '../../widgets/ui/default_scaffold.dart';
import 'profile/badges.dart';
import 'profile/buttons.dart';
import 'profile/header.dart';
import 'profile/progress.dart';
import 'profile/statistics.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePage();
}

class _HomePage extends ConsumerState<HomePage> {
  // final dynamic userData = userBox.get('data');
  final dynamic statisticsData = statisticsBox.get('data');
  final dynamic badgesData = badgesBox.get('data');
  final dynamic historyBadgesData = badgesBox.get('history');

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtils(context);
    final userData = ref.watch(userProvider);

    return PopScope(
      canPop: false,
      // onPopInvoked: (v) async{
      //   return Futur;
      // },
      child: DefaultScaffold(
        currentPage: 'profile',
        hideBottomBar: screen.isTablet || screen.isLandscape,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            child: SafeArea(
              child: screen.isTablet
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: screen.width * 0.05),
                              Image.asset(AppImages.lion, width: 25),
                              Text(
                                ' E-DUTAINMENT  ',
                                style: TextStyle(
                                  fontFamily: 'Football Attack',
                                  color: Colors.white,
                                  height: 0,
                                  fontWeight: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.fontWeight!,
                                  fontSize: 20,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go("/home");
                                },
                                child: Text("PROFILES"),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go("/movies");
                                },
                                child: Text("FILMS"),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go("/tests");
                                },
                                child: Text("TEST"),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "       Welcome Back, ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Jimmy ",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ProfileHeader(user: userData),
                              ProfileProgress(user: userData),
                              const ProfileButtons(),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ProfileBadges(
                                badges: badgesData,
                                historyBadges: historyBadgesData,
                              ),
                              ProfileStatistics(
                                user: userData,
                                statistics: statisticsData,
                              ),

                              InkWell(
                                onTap: () => context.go("/movies"),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 5,
                                    left: 5,
                                    right: 5,
                                    bottom: 5,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: ColorsPallet.darkComponentBackground,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height: screen.width * 0.3,
                                  width: screen.width * 0.3,
                                  child: Image.asset(
                                    AppImages.playerlight,
                                    width: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Welcome Back, ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "${getIn(userData, 'name.given_name', '')} ",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (screen.isLandscape && screen.isPhone)
                            Column(
                              children: [
                                ProfileHeader(user: userData),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          ProfileProgress(user: userData),
                                          const SizedBox(height: 8),
                                          ProfileBadges(
                                            badges: badgesData,
                                            historyBadges: historyBadgesData,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          ProfileStatistics(
                                            user: userData,
                                            statistics: statisticsData,
                                          ),
                                          const SizedBox(height: 8),
                                          const ProfileButtons(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          else
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ProfileHeader(user: userData),
                                const SizedBox(height: 8),
                                ProfileProgress(user: userData),
                                const SizedBox(height: 8),
                                ProfileStatistics(
                                  user: userData,
                                  statistics: statisticsData,
                                ),
                                const SizedBox(height: 8),
                                const ProfileButtons(),
                                const SizedBox(height: 8),
                                ProfileBadges(
                                  badges: badgesData,
                                  historyBadges: historyBadgesData,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
