import 'package:edutainment/constants/screenssize.dart';

import 'falscarddetails.dart';
import 'package:edutainment/widgets/emptyWIdget.dart';
import 'package:edutainment/widgets/loaders/dotloader.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_widgets/widgets/tiktok.dart';
import '../../controllers/flashcards_controller.dart';
import '../../controllers/navigation_args_controller.dart';

import '../../utils/toast.dart';
import '../../widgets/flashcardslisttile.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class FlashCardsListPage extends StatefulWidget {
  const FlashCardsListPage({super.key});

  @override
  State<FlashCardsListPage> createState() => FlashCardsListsPageState();
}

class FlashCardsListsPageState extends State<FlashCardsListPage> {
  List<bool> openedCards = List.generate(10, (index) => false);
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<FlashCardsController>().getFlashCards(
        context,
        loadingFor: "getflash",
        refresh: true,
      );
    });
  }

  Widget _buildSubjectListView(
    FlashCardsController p,
    TextTheme t,
    bool isTablet,
    bool isLandscape,
  ) {
    return Obx(
      () => p.flashCardsList.isEmpty
          ? EmptyWidget(paddingTop: 2)
          : SizedBox(
              height: 30,
              child: ListView.builder(
                itemCount: p.flashCardsList.first.subjects.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  var flashSubject = p.flashCardsList.first.subjects[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Opacity(
                      opacity: flashSubject.enabled ? 1 : 0.5,
                      child: InkWell(
                        onTap: () async {
                          if (flashSubject.enabled == true) {
                            p.setSelectSubject(flashSubject.id);
                            p.getFlashCardMoviesListBySubjectId(
                              context,
                              subjectId: flashSubject.id,
                              loadingFor: "movies",
                            );
                          } else {
                            showToast('This subject is not enabled');
                          }
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.blue),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4,
                            ),
                            child: Center(
                              child: Text(
                                flashSubject.label ?? "Empty",
                                style: t.labelSmall!.copyWith(
                                  color: flashSubject.id == p.selectedSubject
                                      ? Colors.blue
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var t = Theme.of(context).textTheme;

    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isTablet = mediaQuery.size.shortestSide >= 600;

    final p = Get.find<FlashCardsController>();

    return DefaultScaffold(
      currentPage: '/home/fc',
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              CustomHeaderBar(
                onBack: () {
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                centerTitle: false,
                title: 'FLASHCARDS',
                trailing: Obx(
                  () => (isTablet || isLandscape)
                      ? p.loadingFor == "getflash"
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.3,
                                  ),
                                  child: DotLoader(),
                                ),
                              )
                            : p.flashCardsList.isEmpty
                            ? (isTablet || isLandscape)
                                  ? Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.02,
                                        ),
                                        child: Text(
                                          "No Subjects",
                                          style: TextStyle(
                                            color: Colors.yellow.withOpacity(
                                              0.4,
                                            ),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    )
                                  : EmptyWidget(text: "Empty")
                            : _buildSubjectListView(p, t, isTablet, isLandscape)
                      : SizedBox.fromSize(),
                ),
              ),
              Obx(
                () => p.loadingFor == "getflash" || p.loadingFor == "movies"
                    ? QuickTikTokLoader()
                    : SizedBox.shrink(),
              ),

              // Debug info
              Obx(
                () => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Debug: ${p.flashCardsList.length} lists, ${p.flashCardsList.isNotEmpty ? p.flashCardsList.first.movies.length : 0} movies, Loading: ${p.loadingFor}',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      if (p.flashCardsList.isNotEmpty)
                        Text(
                          'Subjects: ${p.flashCardsList.first.subjects.length}, Selected: ${p.selectedSubject}',
                          style: TextStyle(fontSize: 10, color: Colors.blue),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Only show subjects if NOT tablet and NOT landscape
              if (!isTablet && !isLandscape)
                _buildSubjectListView(p, t, isTablet, isLandscape),

              if (!isTablet && !isLandscape) const SizedBox(height: 20),

              Obx(
                () => p.flashCardsList.isEmpty
                    ? EmptyWidget(paddingTop: 30, text: "No Data")
                    : p.flashCardsList.first.movies.isEmpty
                    ? Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "No movies available for selected subject",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: p.flashCardsList.first.movies.map((item) {
                              if (p.flashCardsList.first.movies.length <= 1) {
                                return FlashCardsTileWidget(
                                  item: item,
                                  onTap: () {
                                    final navCtrl =
                                        Get.find<NavigationArgsController>();
                                    navCtrl.flashCardMovie = item;
                                    navCtrl.flashCardSubjectId =
                                        p.selectedSubject;
                                    Get.to(() => const FlashCardDetailsPage());
                                  },
                                );
                              }

                              // Calculate width based on screen orientation and device type
                              final double itemWidth;
                              if (isTablet) {
                                // For tablets, always show 2 items per row
                                itemWidth = mediaQuery.size.width * 0.45;
                              } else {
                                // For phones, show 2 items in landscape, 1 in portrait
                                itemWidth = isLandscape
                                    ? mediaQuery.size.width * 0.45
                                    : mediaQuery.size.width;
                              }

                              return SizedBox(
                                width: itemWidth,
                                child: FlashCardsTileWidget(
                                  item: item,
                                  onTap: () {
                                    final navCtrl =
                                        Get.find<NavigationArgsController>();
                                    navCtrl.flashCardMovie = item;
                                    navCtrl.flashCardSubjectId =
                                        p.selectedSubject;
                                    Get.to(() => const FlashCardDetailsPage());
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
