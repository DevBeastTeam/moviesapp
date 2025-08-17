import 'package:edutainment/providers/flashCardsVM.dart';
import 'package:edutainment/theme/colors.dart';
import 'package:edutainment/widgets/loaders/dotloader.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/toast.dart';
import '../../widgets/flashcardslisttile.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class FlashCardsListPage extends ConsumerStatefulWidget {
  const FlashCardsListPage({super.key});

  @override
  ConsumerState<FlashCardsListPage> createState() => FlashCardsListsPageState();
}

class FlashCardsListsPageState extends ConsumerState<FlashCardsListPage> {
  List<bool> openedCards = List.generate(10, (index) => false);
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(flashCardsVM).getFlashCards(context, loadingFor: "getflash");
    });
  }

  @override
  Widget build(BuildContext context) {
    var t = Theme.of(context).textTheme;
    var p = ref.watch(flashCardsVM);

    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isTablet =
        mediaQuery.size.shortestSide >= 600; // Common tablet threshold

    return DefaultScaffold(
      currentPage: '/home/fc',
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              CustomHeaderBar(
                onBack: () {
                  if (context.mounted) {
                    context.pop();
                  }
                },
                centerTitle: false,
                title: 'FLASHCARDS',
                trailing: (isTablet || isLandscape)
                    ? p.loadingFor == "getflash"
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.3,
                                ),
                                child: DotLoader(),
                              ),
                            )
                          : p.flashCardsList.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                child: Text(
                                  "No Subjects",
                                  style: TextStyle(
                                    color: Colors.yellow.withOpacity(0.4),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 30,
                              child: ListView.builder(
                                itemCount:
                                    p.flashCardsList.first.subjects.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  var flashSubject =
                                      p.flashCardsList.first.subjects[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Opacity(
                                      opacity: flashSubject.enabled ? 1 : 0.5,
                                      child: InkWell(
                                        onTap: () async {
                                          if (flashSubject.enabled == true) {
                                            p.setSelectSubject(flashSubject.id);
                                            await p
                                                .getFlashCardMoviesListBySubjectId(
                                                  context,
                                                  subjectId: flashSubject.id,
                                                  loadingFor: "movies",
                                                );
                                          } else {
                                            showToast(
                                              'This subject is not enabled',
                                            );
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.blue,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
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
                                                  color:
                                                      flashSubject.id ==
                                                          p.selectedSubject
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
                            )
                    : SizedBox.fromSize(),
              ),

              const SizedBox(height: 20),

              if (!isTablet && !isLandscape)
                p.loadingFor == "getflash"
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.3,
                          ),
                          child: DotLoader(),
                        ),
                      )
                    : p.flashCardsList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: Text(
                            "No Subjects",
                            style: TextStyle(
                              color: Colors.yellow.withOpacity(0.4),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 30,
                        child: ListView.builder(
                          itemCount: p.flashCardsList.first.subjects.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            var flashSubject =
                                p.flashCardsList.first.subjects[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Opacity(
                                opacity: flashSubject.enabled ? 1 : 0.5,
                                child: InkWell(
                                  onTap: () async {
                                    if (flashSubject.enabled == true) {
                                      p.setSelectSubject(flashSubject.id);
                                      await p.getFlashCardMoviesListBySubjectId(
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
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.blue,
                                      ),
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
                                            color:
                                                flashSubject.id ==
                                                    p.selectedSubject
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

              if (!isTablet && !isLandscape) const SizedBox(height: 20),

              p.loadingFor == "getflash"
                  ? SizedBox.shrink()
                  : p.loadingFor == "movies"
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3,
                        ),
                        child: DotLoader(),
                      ),
                    )
                  : p.flashCardsList.first.movies.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3,
                        ),
                        child:
                            Text(
                                  "Empty",
                                  style: TextStyle(
                                    color: Colors.yellow.withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                )
                                .animate(
                                  delay: 1000.ms,
                                  onPlay: (controller) => controller.repeat(),
                                )
                                .shimmer(
                                  duration: 2000.ms,
                                  color: ColorsPallet.darkBlue,
                                ),
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
                                  context.go(
                                    "/home/fc/fcdetails",
                                    extra: {
                                      'movie': item,
                                      'subjectId': p.selectedSubject,
                                    },
                                  );
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
                                  context.go(
                                    "/home/fc/fcdetails",
                                    extra: {
                                      'movie': item,
                                      'subjectId': p.selectedSubject,
                                    },
                                  );
                                },
                              ),
                            );
                          }).toList(),
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
