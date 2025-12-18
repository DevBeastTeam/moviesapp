import 'package:edutainment/widgets/card_3d.dart';

import '../movies/movies_page.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';

import '../../utils/movies.dart';
import '../../utils/screen_utils.dart';
import '../../theme/colors.dart';
import '../../utils/boxes.dart';
import '../../widgets/ui/default_scaffold.dart';
import 'profile/badges.dart';
import 'profile/buttons.dart';
import 'profile/header.dart';
import 'profile/progress.dart';
import 'profile/statistics.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  // final dynamic userData = userBox.get('data');
  final dynamic statisticsData = statisticsBox.get('data');
  final dynamic badgesData = badgesBox.get('data');
  final dynamic historyBadgesData = badgesBox.get('history');
  final dynamic statusGroupMovies = moviesBox.get('statusGroupMovies');

  @override
  void initState() {
    super.initState();
    lastVideo();
  }

  var pausedMovie = <dynamic>[];
  lastVideo() {
    if (statusGroupMovies['paused'] != null) {
      var dummyPausedMovies = [...statusGroupMovies['paused']];
      if (dummyPausedMovies.isNotEmpty) {
        pausedMovie.add(
          dummyPausedMovies.first,
          // dummyPausedMovies.sublist(
          //   0,
          //   0 + 10 > dummyPausedMovies.length
          //       ? dummyPausedMovies.length
          //       : 0 + 10,
          // ),
        );
      }
    }
    // for use
    // buildMovieFrame(
    //  movie: pausedMovie.first, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtils(context);
    final userCtrl = Get.find<UserController>();

    return PopScope(
      canPop: false,
      // onPopInvoked: (v) async{
      //   return Futur;
      // },
      child: DefaultScaffold(
        currentPage: 'profile',
        hideBottomBar: false,
        // (screen.isTablet && screen.isLandscape) ||
        // (screen.isPhone && screen.isLandscape),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            child: SafeArea(
              child: screen.isTablet && screen.isLandscape
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Obx(() => ProfileHeader(user: userCtrl.userData)),
                              Obx(
                                () => ProfileProgress(user: userCtrl.userData),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Obx(
                                () => ProfileStatistics(
                                  user: userCtrl.userData,
                                  statistics: statisticsData,
                                ),
                              ),
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
                              InkWell(
                                onTap: () => Get.to(() => const MoviesPage()),
                                child: Card3D(
                                  margin: const EdgeInsets.only(
                                    top: 5,
                                    left: 5,
                                    right: 5,
                                    bottom: 5,
                                  ),
                                  child: Container(
                                    // margin: const EdgeInsets.only(
                                    //   top: 5,
                                    //   left: 5,
                                    //   right: 5,
                                    //   bottom: 5,
                                    // ),
                                    // padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: ColorsPallet.borderCardBgColor,
                                      borderRadius: BorderRadius.circular(32),
                                      // border: Border.all(
                                      //   width: 1,
                                      //   color: ColorsPallet.borderCardBorderColor,
                                      // ),
                                    ),
                                    width: screen.width * 0.46,
                                    height: screen.height * 0.35,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        pausedMovie.isNotEmpty
                                            ? buildMovieFrame(
                                                movie: pausedMovie.first,
                                                context: context,
                                                fullSize: true,
                                                showPlayerLogo: true,
                                              )
                                            : Image.asset(
                                                AppImages.playerlight,
                                                width: 100,
                                              ),
                                        SizedBox(height: 10),
                                        Text("Continue Watching"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : screen.isTablet && !screen.isLandscape
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() => ProfileHeader(user: userCtrl.userData)),
                          Obx(() => ProfileProgress(user: userCtrl.userData)),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //   ],
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Obx(
                                () => ProfileStatistics(
                                  user: userCtrl.userData,
                                  statistics: statisticsData,
                                ),
                              ),

                              Column(
                                children: [
                                  const ProfileButtons(),
                                  ProfileBadges(
                                    badges: badgesData,
                                    historyBadges: historyBadgesData,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          InkWell(
                            onTap: () => Get.to(() => const MoviesPage()),
                            child: Card3D(
                              margin: const EdgeInsets.only(
                                top: 5,
                                left: 5,
                                right: 5,
                                bottom: 5,
                              ),
                              child: Container(
                                // margin: const EdgeInsets.only(
                                //   top: 5,
                                //   left: 5,
                                //   right: 5,
                                //   bottom: 5,
                                // ),
                                // padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: ColorsPallet.borderCardBgColor,
                                  borderRadius: BorderRadius.circular(32),
                                  // border: Border.all(
                                  //   width: 1,
                                  //   color: ColorsPallet.borderCardBorderColor,
                                  // ),
                                ),
                                width: screen.width * 0.93,
                                height: screen.height * 0.47,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    pausedMovie.isNotEmpty
                                        ? buildMovieFrame(
                                            movie: pausedMovie.first,
                                            context: context,
                                            fullSize: true,
                                            showPlayerLogo: true,
                                          )
                                        : Image.asset(
                                            AppImages.playerlight,
                                            width: 100,
                                          ),
                                    SizedBox(height: 10),
                                    Text("Continue Watching"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          // if (screen.isLandscape && screen.isPhone)
                          //   Column(
                          //     children: [
                          //       TopBarWidget(paddingLeft: 10),
                          //       ProfileHeader(user: userData),
                          //       const SizedBox(height: 8),
                          //       Row(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Expanded(
                          //             child: Column(
                          //               children: [
                          //                 ProfileProgress(user: userData),
                          //                 const SizedBox(height: 8),
                          //                 ProfileBadges(
                          //                   badges: badgesData,
                          //                   historyBadges: historyBadgesData,
                          //                 ),
                          //                 InkWell(
                          //                   onTap: () => Get.to(() => const MoviesPage()),
                          //                   child: Container(
                          //                     margin: const EdgeInsets.only(
                          //                       top: 5,
                          //                       left: 5,
                          //                       right: 5,
                          //                       bottom: 5,
                          //                     ),
                          //                     padding: const EdgeInsets.all(10),
                          //                     decoration: BoxDecoration(
                          //                       color: ColorsPallet
                          //                           .borderCardBgColor,
                          //                       borderRadius:
                          //                           BorderRadius.circular(32),
                          //                       border: Border.all(
                          //                         width: 1,
                          //                         color: ColorsPallet
                          //                             .borderCardBorderColor,
                          //                       ),
                          //                     ),
                          //                     height: screen.height * 0.6,
                          //                     width: screen.width * 0.42,
                          //                     child: Column(
                          //                       mainAxisSize: MainAxisSize.min,
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.center,
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.center,
                          //                       children: [
                          //                         pausedMovie.isNotEmpty
                          //                             ? buildMovieFrame(
                          //                                 ref: ref,

                          //                                 movie:
                          //                                     pausedMovie.first,
                          //                                 context: context,
                          //                                 fullSize: true,
                          //                                 showPlayerLogo: true,
                          //                               )
                          //                             : Image.asset(
                          //                                 AppImages.playerlight,
                          //                                 width: 20,
                          //                               ),
                          //                         SizedBox(height: 10),
                          //                         Text("Continue Watching"),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //           const SizedBox(width: 8),
                          //           Expanded(
                          //             child: Column(
                          //               children: [
                          //                 ProfileStatistics(
                          //                   user: userData,
                          //                   statistics: statisticsData,
                          //                 ),
                          //                 const SizedBox(height: 8),
                          //                 const ProfileButtons(),
                          //               ],
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   )
                          // else
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(() => ProfileHeader(user: userCtrl.userData)),
                              const SizedBox(height: 8),
                              Obx(
                                () => ProfileProgress(user: userCtrl.userData),
                              ),
                              const SizedBox(height: 8),
                              const ProfileButtons(),
                              const SizedBox(height: 8),
                              Obx(
                                () => ProfileStatistics(
                                  user: userCtrl.userData,
                                  statistics: statisticsData,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ProfileBadges(
                                badges: badgesData,
                                historyBadges: historyBadgesData,
                              ),
                              InkWell(
                                onTap: () => Get.to(() => const MoviesPage()),
                                child: Card3D(
                                  // margin: const EdgeInsets.only(
                                  //   top: 5,
                                  //   left: 5,
                                  //   right: 5,
                                  //   bottom: 5,
                                  // ),
                                  child: Container(
                                    // margin: const EdgeInsets.only(
                                    //   top: 5,
                                    //   left: 5,
                                    //   right: 5,
                                    //   bottom: 5,
                                    // ),
                                    // padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: ColorsPallet.borderCardBgColor,
                                      borderRadius: BorderRadius.circular(32),
                                      // border: Border.all(
                                      //   width: 1,
                                      //   color:
                                      //       ColorsPallet.borderCardBorderColor,
                                      // ),
                                    ),
                                    height: screen.height * 0.3,
                                    width: screen.width * 0.84,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        pausedMovie.isNotEmpty
                                            ? buildMovieFrame(
                                                movie: pausedMovie.first,
                                                context: context,
                                                fullSize: true,
                                                showPlayerLogo: true,
                                              )
                                            : Image.asset(
                                                AppImages.playerlight,
                                                width: 40,
                                              ),
                                        Spacer(),
                                        Text("Continue Watching"),
                                        SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                ),
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
