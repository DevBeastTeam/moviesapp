import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    bool isTablet = w > 450 ? true : false;
    final userData = ref.watch(userProvider);
    return PopScope(
      canPop: false,
      // onPopInvoked: (v) async{
      //   return Futur;
      // },
      child: DefaultScaffold(
        currentPage: 'profile',
        hideBottomBar: isTablet,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: isTablet
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: w * 0.05),
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
                            TextButton(onPressed: () {
                              context.go("/movies");
                            }, child: Text("FILMS")),
                            TextButton(onPressed: () {
                              context.go("/tests");
                            }, child: Text("TEST")),
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
                                height: w * 0.3,
                                width: w * 0.3,
                                child: Image.asset(AppImages.playerlight, width: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProfileHeader(user: userData),
                        ProfileProgress(user: userData),
                        ProfileStatistics(
                          user: userData,
                          statistics: statisticsData,
                        ),
                        const ProfileButtons(),
                        ProfileBadges(
                          badges: badgesData,
                          historyBadges: historyBadgesData,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
