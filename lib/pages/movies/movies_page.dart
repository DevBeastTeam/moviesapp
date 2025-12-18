import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/constants/screenssize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/movies_controller.dart';
import '../../models/movie_model.dart';
import '../../theme/colors.dart';
import '../../utils/assets/assets_icons.dart';
import '../../utils/movies.dart';

import '../../widgets/ui/custom_submit_button.dart';
import '../../widgets/ui/default_scaffold.dart';
import 'widgets/tabButtonWidget.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPage();
}

class _MoviesPage extends State<MoviesPage> {
  final MoviesController controller = Get.put(MoviesController());

  @override
  void initState() {
    super.initState();
    // Fetch movies if not already fetched or if needed
    if (controller.groupMovies.isEmpty) {
      controller.fetchMovies();
    } else {
      // Ensure the list is updated based on current selection
      controller.updateMoviesList();
    }
  }

  List<List<Movie>> _chunkMovies(List<Movie> movies, int chunkSize) {
    var chunks = <List<Movie>>[];
    for (var i = 0; i < movies.length; i += chunkSize) {
      chunks.add(
        movies.sublist(i, math.min(i + chunkSize, movies.length)).toList(),
      );
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: 'movies',
      hideBottomBar: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;
          final chunkSize = isLandscape ? 10 : 4;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   AppImages.playerlight,
                  //   width: Screen.isTablet(context)
                  //       ? Screen.width(context) * 0.07
                  //       : Screen.width(context) * 0.12,
                  // ),
                  Container(
                    height: 49,
                    width: Screen.isTablet(context)
                        ? Screen.width(context) * 0.95
                        : Screen.width(context) * 0.95,
                    // ? Screen.width(context) * 0.8
                    // : Screen.width(context) * 0.85,
                    decoration: BoxDecoration(
                      color: ColorsPallet.filmsTabBgColor,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FilmTabBtnWidget(
                                label: "All",
                                isActive:
                                    controller.currentSubject.value == 'all',
                                onTap: () {
                                  controller.setSubject('all', 'all');
                                },
                              ),
                              for (var subject in controller.subjects)
                                FilmTabBtnWidget(
                                  label: subject.label.replaceAll('videos', ''),
                                  isActive:
                                      controller.currentSubject.value
                                          .toLowerCase() ==
                                      subject.id.toString().toLowerCase(),
                                  onTap: () {
                                    controller.setSubject(
                                      subject.id,
                                      subject.reference,
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Container(height: Screen.isPhone(context) ? 5 : 20),

              if (controller.featuredMovie.value != null)
                OrientationBuilder(
                  builder: (context, orientation) {
                    final isLandScape = orientation == Orientation.landscape;
                    final screenHeight = MediaQuery.of(context).size.height;
                    final screenWidth = MediaQuery.of(context).size.width;
                    final movie = controller.featuredMovie.value!;
                    final imageUrl = movie.picture ?? '';

                    final double containerHeight = isLandScape
                        ? screenWidth / (16 / 9)
                        : Screen.isTablet(context)
                        ? Screen.height(context) * 0.6
                        : screenHeight * 0.5;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        height: containerHeight,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await movieFetchAndRedirect(movie.id, context);
                              },
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                placeholder: (context, url) => const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [CircularProgressIndicator()],
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 100,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black38,
                                      Colors.black,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                ),
                                child: Center(
                                  child: CustomSubmitButton(
                                    width:
                                        (MediaQuery.of(context).size.width *
                                                .5 >
                                            200
                                        ? 200
                                        : MediaQuery.of(context).size.width *
                                              .5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          EdutainmentIcons.playEdutainment,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 3,
                                          ),
                                          child: Text(
                                            'PLAY NOW',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: Theme.of(
                                                context,
                                              ).textTheme.titleLarge!.fontSize!,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      await movieFetchAndRedirect(
                                        movie.id,
                                        context,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              Container(
                height: 30,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Colors.black54,
                      Colors.black38,
                      Colors.black26,
                      Colors.black12,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.pausedMovies.isNotEmpty)
                      const Text(
                        'Continue Watching',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    for (var moviesList in _chunkMovies(
                      controller.pausedMovies,
                      chunkSize,
                    ))
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (var movie in moviesList)
                                  buildMovieFrame(
                                    movie: movie.toJson(),
                                    context: context,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (controller.watchedMovies.isNotEmpty)
                      const Text(
                        'Already Watched',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    for (var moviesList in _chunkMovies(
                      controller.watchedMovies,
                      chunkSize,
                    ))
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (var movie in moviesList)
                                  buildMovieFrame(
                                    movie: movie.toJson(),
                                    context: context,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    for (var tagData in controller.moviesByTag)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            tagData['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          for (var moviesList in _chunkMovies(
                            tagData['movies'] as List<Movie>,
                            chunkSize,
                          ))
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      for (var movie in moviesList)
                                        buildMovieFrame(
                                          movie: movie.toJson(),
                                          context: context,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
