import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/constants/screenssize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/colors.dart';
import '../../utils/assets/assets_icons.dart';
import '../../utils/boxes.dart';
import '../../utils/movies.dart';
import '../../utils/utils.dart';
import '../../widgets/ui/custom_submit_button.dart';
import '../../widgets/ui/default_scaffold.dart';
import 'widgets/tabButtonWidget.dart';

class MoviesPage extends ConsumerStatefulWidget {
  const MoviesPage({super.key});

  @override
  ConsumerState<MoviesPage> createState() => _MoviesPage();
}

class _MoviesPage extends ConsumerState<MoviesPage> {
  final dynamic subjects = moviesBox.get('subjects');
  final dynamic groupMovies = moviesBox.get('groupMovies');
  final dynamic statusGroupMovies = moviesBox.get('statusGroupMovies');
  final dynamic movieTags = moviesBox.get('tags');

  dynamic featuredMovie;

  late String currentSubject = 'all';
  late String currentSubjectRef = 'all';

  var movies = <dynamic>[];
  var pausedMovies = <dynamic>[];
  var watchedMovies = <dynamic>[];
  List<Map<String, dynamic>> moviesByTag = [];

  bool isOrientationLandscape = false;

  void updateMovies() {
    moviesByTag = [];
    var localmoviesByTag = <String, List<dynamic>>{};
    final moviesRefs = <String>[];
    dynamic movieToFeature;

    if (currentSubjectRef == 'all') {
      if (groupMovies.isNotEmpty) {
        for (final key in groupMovies.keys) {
          final movies = groupMovies[key];
          if (movies is List && movies.isNotEmpty) {
            movieToFeature = movies.first;
            break;
          }
        }
      }
      groupMovies.forEach((key, value) {
        value.forEach((movie) {
          movie['tags'].forEach((tag) {
            if (!localmoviesByTag.containsKey(tag)) {
              localmoviesByTag[tag] = [movie];
            } else {
              localmoviesByTag[tag]!.add(movie);
            }
          });
        });
      });
    } else {
      if (groupMovies[currentSubjectRef] != null &&
          groupMovies[currentSubjectRef]!.isNotEmpty) {
        movieToFeature = groupMovies[currentSubjectRef]!.first;
      }
      if (groupMovies[currentSubjectRef] != null) {
        groupMovies[currentSubjectRef]!.forEach((movie) {
          moviesRefs.add(movie['_id']);
          movie!['tags']!.forEach((tag) {
            if (!localmoviesByTag.containsKey(tag)) {
              localmoviesByTag[tag] = [movie];
            } else {
              localmoviesByTag[tag]!.add(movie);
            }
          });
        });
      }
    }

    // if landsacpe chunkSize to 5 else 4
    // isOrientationLandscape = Get.context!.isLandscape;
    final chunkSize = isOrientationLandscape ? 10 : 4;
    final maxMoviesPerTag = 36; // Maximum 36 movies per tag
    localmoviesByTag.forEach((key, value) {
      var dummyMovies = <dynamic>[];
      for (var i = 0; i < value.length; i += chunkSize) {
        dummyMovies.add(
          value
              .sublist(
                i,
                i + chunkSize > value.length ? value.length : i + chunkSize,
              )
              .take(maxMoviesPerTag)
              .toList(), // Limit to maxMoviesPerTag
        );
      }
      localmoviesByTag[key] = dummyMovies;
    });

    localmoviesByTag.forEach((key, value) {
      var tagTitle = '';
      for (var tag in movieTags) {
        if (tag['reference'] == key && tag['enabled'] == true) {
          tagTitle = tag['label'];
          break;
        }
      }
      if (tagTitle.isNotEmpty) {
        moviesByTag.add({'tag': key, 'title': tagTitle, 'movies': value});
      }
    });

    var dummyPausedMovies = <dynamic>[];
    var dummyWatchedMovies = <dynamic>[];

    if (currentSubjectRef == 'all') {
      if (statusGroupMovies['paused'] != null) {
        dummyPausedMovies = [
          ...statusGroupMovies['paused'],
        ].take(maxMoviesPerTag).toList();
      }
      if (statusGroupMovies['ended'] != null) {
        dummyWatchedMovies = [
          ...statusGroupMovies['ended'],
        ].take(maxMoviesPerTag).toList();
      }
    } else {
      if (statusGroupMovies['paused'] != null) {
        for (var movie in statusGroupMovies['paused']) {
          if (movie['Subject']['reference'] == currentSubjectRef) {
            dummyPausedMovies.add(
              movie,
            ); // No need to take here, will be done below
          }
        } // No need to take here, will be done below
      }
      if (statusGroupMovies['ended'] != null) {
        for (var movie in statusGroupMovies['ended']) {
          if (movie['Subject']['reference'] == currentSubjectRef) {
            dummyWatchedMovies.add(movie);
          }
        }
      }
    }

    setState(() {
      featuredMovie = movieToFeature;
    });

    pausedMovies.clear();
    watchedMovies.clear();
    setState(() {
      for (var i = 0; i < dummyPausedMovies.length; i += chunkSize) {
        pausedMovies.add(
          dummyPausedMovies
              .sublist(i, math.min(i + chunkSize, dummyPausedMovies.length))
              .take(maxMoviesPerTag)
              .toList(),
        );
      }
      for (var i = 0; i < dummyWatchedMovies.length; i += chunkSize) {
        watchedMovies.add(
          dummyWatchedMovies
              .sublist(i, math.min(i + chunkSize, dummyWatchedMovies.length))
              .take(maxMoviesPerTag)
              .toList(),
        );
      }
    });
  }

  @override
  void initState() {
    updateMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: 'movies',
      // hideBottomBar: Screen.isTablet(context) || Screen.isLandscape(context),
      hideBottomBar: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          // mainAxisAlignment: MairnAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen.isTablet(context) || Screen.isLandscape(context)
            //     ? TopBarWidget(paddingLeft: 0)
            //     : Padding(
            //         padding: const EdgeInsets.symmetric(
            //           vertical: 0,
            //           horizontal: 4.0,
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             // AssetsImage.defaultIcon.toImage(width: 24),
            //             Image.asset(AppImages.playerlight, width: 24),
            //             const SizedBox(width: 4),
            //             Padding(
            //               padding: const EdgeInsets.only(bottom: 4.0),
            //               child: Text(
            //                 'E-DUTAINMENT',
            //                 style: TextStyle(
            //                   fontFamily: 'Football Attack',
            //                   color: Colors.white,
            //                   fontWeight: Theme.of(
            //                     context,
            //                   ).textTheme.titleLarge?.fontWeight!,
            //                   fontSize: 20,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            // const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  AppImages.playerlight,
                  width: Screen.isTablet(context)
                      ? Screen.width(context) * 0.07
                      : Screen.width(context) * 0.12,
                ),
                Container(
                  height: 47,
                  width: Screen.isTablet(context)
                      ? Screen.width(context) * 0.8
                      : Screen.width(context) * 0.85,
                  decoration: BoxDecoration(
                    color: ColorsPallet.filmsTabBgColor,
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
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
                              isActive: currentSubject == 'all',
                              onTap: () {
                                setState(() {
                                  currentSubject = 'all';
                                  currentSubjectRef = 'all';
                                });
                                updateMovies();
                              },
                            ),

                            for (var subject in subjects)
                              FilmTabBtnWidget(
                                label: subject['label'].replaceAll(
                                  'videos',
                                  '',
                                ),
                                isActive:
                                    currentSubject.toLowerCase() ==
                                    subject['_id'].toString().toLowerCase(),
                                onTap: () {
                                  setState(() {
                                    currentSubject = subject['_id'];
                                    currentSubjectRef = subject['reference'];
                                  });
                                  updateMovies();
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

            Container(
              height: Screen.isPhone(context) ? 5 : 20,
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.bottomCenter,
                //   end: Alignment.topCenter,
                //   // stops: const [0.0, 0.3, 0.8, 1.0],
                //   colors: [
                //     Colors.black,
                //     Colors.black54,
                //     Colors.black38,
                //     Colors.black26,
                //     Colors.black12,
                //     Colors.transparent,
                //     // ColorsPallet.darkBlue.withOpacity(0.7),
                //   ],
                // ),
              ),
            ),
            // SizedBox(height: 8),
            if (featuredMovie != null)
              OrientationBuilder(
                builder: (context, orientation) {
                  final isLandScape = orientation == Orientation.landscape;
                  final screenHeight = MediaQuery.of(context).size.height;
                  final screenWidth = MediaQuery.of(context).size.width;
                  final movie = featuredMovie;
                  final imageUrl = getIn(movie, 'picture', '');

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
                      // margin: const EdgeInsets.symmetric(vertical: 12),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await movieFetchAndRedirect(movie, context);
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
                          // Positioned(
                          //   top: 0,
                          //   left: 0,
                          //   right: 0,
                          //   child: Container(
                          //     height: Screen.isPhone(context) ? 10 : 10,
                          //     decoration: BoxDecoration(
                          //       gradient: LinearGradient(
                          //         begin: Alignment.topCenter,
                          //         end: Alignment.bottomCenter,
                          //         stops: const [1.0, 0.8, 0.3, 0.0],
                          //         colors: [
                          //           // ColorsPallet.darkBlue.withOpacity(0.9),
                          //           Colors.black,
                          //           Colors.black38,
                          //           Colors.transparent,
                          //           Colors.transparent,
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  // stops: const [0.0, 0.3, 0.8, 1.0],
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
                            bottom: 30,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: CustomSubmitButton(
                                width:
                                    (MediaQuery.of(context).size.width * .5 >
                                        200
                                    ? 200
                                    : MediaQuery.of(context).size.width * .5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      EdutainmentIcons.playEdutainment,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 3),
                                      child: Text(
                                        'PLAY NOW',
                                        // '${imageUrl}',
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
                                  await movieFetchAndRedirect(movie, context);
                                },
                              ),
                            ),
                          ),
                          // Text("$featuredMovie"),
                        ],
                      ),
                    ),
                  );
                },
              ),

            Container(
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // stops: const [0.0, 0.3, 0.8, 1.0],
                  colors: [
                    Colors.black,
                    Colors.black54,
                    Colors.black38,
                    Colors.black26,
                    Colors.black12,
                    Colors.transparent,
                    // ColorsPallet.darkBlue.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pausedMovies.isNotEmpty)
                    const Text(
                      'Continue Watching',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  for (var moviesList in pausedMovies)
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
                                  movie: movie,
                                  context: context,
                                  ref: ref,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (watchedMovies.isNotEmpty)
                    const Text(
                      'Already Watched',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  for (var moviesList in watchedMovies)
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
                                  ref: ref,
                                  movie: movie,
                                  context: context,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  for (var tag in moviesByTag)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          tag['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        for (var moviesList in tag['movies'])
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
                                        ref: ref,
                                        movie: movie,
                                        context: context,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  // const Text('All Films',
                  //     style: TextStyle(
                  //         fontSize: 18, fontWeight: FontWeight.bold)),
                  // for (var moviesList in movies)
                  //   Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         SingleChildScrollView(
                  //             physics: const BouncingScrollPhysics(),
                  //             scrollDirection: Axis.horizontal,
                  //             child: Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.center,
                  //                 crossAxisAlignment:
                  //                     CrossAxisAlignment.center,
                  //                 children: [
                  //                   for (var movie in moviesList)
                  //                     buildMovieFrame(
                  //                         movie: movie, context: context),
                  //                 ]))
                  //       ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
