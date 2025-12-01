import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/constants/toats.dart';
import 'package:edutainment/widgets/emptyWidget.dart';
import 'package:edutainment/widgets/loaders/dotloader.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import '../../constants/screenssize.dart';
import '../../controllers/flashcards_controller.dart';
import '../../controllers/navigation_args_controller.dart';
import '../../widgets/flashcardslisttile.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class FlashCardDetailsPage extends StatefulWidget {
  const FlashCardDetailsPage({super.key});

  @override
  State<FlashCardDetailsPage> createState() => FlashCardDetailsPageState();
}

class FlashCardDetailsPageState extends State<FlashCardDetailsPage> {
  final PageController pageController = PageController();
  bool isPage2 = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    // Access extra data from GoRouterState
    final navCtrl = Get.find<NavigationArgsController>();
    final movie = navCtrl.flashCardMovie;
    final subjectId = navCtrl.flashCardSubjectId;

    if (movie == null) {
      return const Scaffold(
        body: Center(child: Text("Should Pass Extra Data")),
      );
    }

    List levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

    return Obx(() {
      final p = Get.find<FlashCardsController>();

      return DefaultScaffold(
        currentPage: '/home/fc/fcdetails',
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomHeaderBar(
                onBack: () => Navigator.pop(context),
                centerTitle: false,
                title: 'FLASHCARDS DETAILS',
              ),

              p.loadingFor == "leveldetails"
                  ? QuickTikTokLoader()
                  : SizedBox.shrink(),

              // Level Selection and Image (same as original)
              if (isTablet || isLandscape)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                        height: isTablet ? h * 0.08 : h * 0.12,
                        width: w * 0.53,
                        child: ListView.builder(
                          itemCount: levels.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  final navCtrl =
                                      Get.find<NavigationArgsController>();
                                  navCtrl.flashCardLevelId = levels[index]
                                      .toLowerCase();
                                  navCtrl.flashCardMovie = movie;
                                  p.getFlashCardDetailsByIds(
                                    context,
                                    movieId: navCtrl.flashCardMovie!.id,
                                    levelId: navCtrl.flashCardLevelId,
                                    loadingFor: 'leveldetails',
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    // color:
                                    //     p.selectedLevel ==
                                    //         levels[index].toLowerCase()
                                    //     ? Colors.blue
                                    //     : Colors.white,
                                    gradient:
                                        navCtrl.flashCardLevelId
                                                .toLowerCase() ==
                                            levels[index].toLowerCase()
                                        ? LinearGradient(
                                            colors: [
                                              Colors.deepOrange,
                                              Colors.orange,
                                            ],
                                          )
                                        : LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.white,
                                            ],
                                          ),
                                    borderRadius: BorderRadius.circular(6),
                                    // border: Border.all(color: Colors.blue),
                                  ),
                                  height: 52,
                                  width: 52,
                                  child: Center(
                                    child: Text(
                                      '${levels[index]}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            navCtrl.flashCardLevelId
                                                    .toLowerCase() ==
                                                levels[index].toLowerCase()
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: w * 0.4,
                      height: isTablet ? h * 0.08 : h * 0.12,
                      child: FlashCardsTileWidget(
                        item: movie,
                        isSelected: true,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

              if (!isTablet && !isLandscape)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: h * 0.07,
                    child: ListView.builder(
                      itemCount: levels.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              final navCtrl =
                                  Get.find<NavigationArgsController>();
                              navCtrl.flashCardLevelId = levels[index]
                                  .toLowerCase();
                              navCtrl.flashCardMovie = movie;

                              p.getFlashCardDetailsByIds(
                                context,
                                movieId: navCtrl.flashCardMovie!.id,
                                levelId: navCtrl.flashCardLevelId,
                                loadingFor: 'Leveldetails',
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                // color:
                                //     p.selectedLevel ==
                                //         levels[index].toLowerCase()
                                //     ? Colors.blue
                                //     : Colors.white,
                                gradient:
                                    navCtrl.flashCardLevelId.toLowerCase() ==
                                        levels[index].toLowerCase()
                                    ? LinearGradient(
                                        colors: [
                                          Colors.deepOrange,
                                          Colors.orange,
                                        ],
                                      )
                                    : LinearGradient(
                                        colors: [Colors.white, Colors.white],
                                      ),
                                borderRadius: BorderRadius.circular(6),
                                // border: Border.all(color: Colors.blue),
                              ),
                              height: 52,
                              width: 52,
                              child: Center(
                                child: Text(
                                  levels[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color:
                                        navCtrl.flashCardLevelId
                                                .toLowerCase() ==
                                            levels[index].toLowerCase()
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              if (!isTablet && !isLandscape) const SizedBox(height: 10),

              if (!isTablet && !isLandscape)
                FlashCardsTileWidget(
                  item: movie,
                  isSelected: true,
                  onTap: () {},
                ),

              const SizedBox(height: 20),

              // Flashcard Content Box (Swipeable with Arrow Buttons)
              p.loadingFor == "details"
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: h * 0.3),
                        child: const DotLoader(),
                      ),
                    )
                  : p.flashCardsDetailsList.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(bottom: h * 0.15),
                      child: EmptyWidget(paddingTop: 20),
                    )
                  : Row(
                      mainAxisAlignment: isTablet || isLandscape
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        // Previous Button
                        if (isTablet || isLandscape)
                          LeftRightArrow(
                            onTap: () {
                              if (pageController.page! > 0) {
                                pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              } else {
                                toast(context, msg: 'Reached the beginning');
                              }
                            },
                            icon: Icons.arrow_back_ios,
                          ),

                        // Swipeable Cards
                        Container(
                          height: isTablet || isLandscape ? h * 0.7 : h * 0.45,
                          width: isTablet || isLandscape ? w * 0.6 : w * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            // gradient: const LinearGradient(
                            //   colors: [Colors.orange, Colors.deepOrangeAccent],
                            // ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: p.flashCardsDetailsList.length,
                            onPageChanged: (int page) {
                              setState(() {
                                isPage2 = false; // Reset page2 on swipe
                              });
                            },
                            itemBuilder: (context, index) {
                              final item = p.flashCardsDetailsList[index];
                              return Padding(
                                padding: const EdgeInsets.all(2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 12,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child:
                                          item.movie.description.length > 200 &&
                                              isPage2
                                          ? CachedNetworkImage(
                                              imageUrl: item.movie.picture,
                                              progressIndicatorBuilder:
                                                  (context, url, progress) =>
                                                      const DotLoader(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                        AppImages.noimg,
                                                      ),
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  item.movie.label,
                                                  style: t.titleMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  item.movie.description,
                                                  textAlign: TextAlign.center,
                                                  style: t.labelMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                ),
                                                const SizedBox(height: 6),
                                                CachedNetworkImage(
                                                  imageUrl: item.movie.picture,
                                                  progressIndicatorBuilder:
                                                      (
                                                        context,
                                                        url,
                                                        progress,
                                                      ) => const DotLoader(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                            AppImages.noimg,
                                                          ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Next Button
                        if (isTablet || isLandscape)
                          LeftRightArrow(
                            onTap: () {
                              if (pageController.page! <
                                  p.flashCardsDetailsList.length - 1) {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              } else {
                                toast(context, msg: 'Reached the end');
                              }
                            },
                            icon: Icons.arrow_forward_ios,
                          ),
                      ],
                    ),

              const SizedBox(height: 20),

              // Mobile Arrow Buttons
              if (!isTablet && !isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LeftRightArrow(
                      onTap: () {
                        if (pageController.page! > 0) {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          toast(context, msg: 'Reached the beginning');
                        }
                      },
                      icon: Icons.arrow_back_ios,
                    ),
                    SizedBox(width: Screen.width(context) * 0.1),
                    LeftRightArrow(
                      onTap: () {
                        if (pageController.page! <
                            p.flashCardsDetailsList.length - 1) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          toast(context, msg: 'Reached the end');
                        }
                      },
                      icon: Icons.arrow_forward_ios,
                    ),
                  ],
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}

class LeftRightArrow extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const LeftRightArrow({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.deepOrangeAccent],
          ),
        ),
        height: 50,
        width: 50,
        child: Icon(icon),
      ),
    );
  }
}
