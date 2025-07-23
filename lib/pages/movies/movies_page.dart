import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutainment/utils/assets/assets_images.dart';
import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../utils/assets/assets_icons.dart';
import '../../utils/boxes.dart';
import '../../utils/movies.dart';
import '../../utils/utils.dart';
import '../../widgets/ui/custom_submit_button.dart';
import '../../widgets/ui/default_scaffold.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPage();
}

class _MoviesPage extends State<MoviesPage> {
  final dynamic subjects = moviesBox.get('subjects');
  final dynamic groupMovies = moviesBox.get('groupMovies');
  final dynamic statusGroupMovies = moviesBox.get('statusGroupMovies');
  final dynamic movieHeaders = moviesBox.get('movieHeaders');
  final dynamic movieTags = moviesBox.get('tags');

  dynamic currentHeaderMobile;
  dynamic currentHeaderWeb;

  late String currentSubject = '63f0ba743c2816767892cf1e';
  late String currentSubjectRef = 'entertainment';

  var movies = <dynamic>[];
  var pausedMovies = <dynamic>[];
  var watchedMovies = <dynamic>[];
  List<Map<String, dynamic>> moviesByTag = [];

  bool isOrientationLandscape = false;

  void updateMovies() {
    moviesByTag = [];
    var localmoviesByTag = <String, List<dynamic>>{};
    final moviesRefs = <String>[];

    if (currentSubjectRef == 'all') {
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

    // if landsacpe chunkSize to 5 else 4
    // isOrientationLandscape = Get.context!.isLandscape;
    final chunkSize = isOrientationLandscape ? 10 : 4;

    localmoviesByTag.forEach((key, value) {
      var dummyMovies = <dynamic>[];
      for (var i = 0; i < value.length; i += chunkSize) {
        dummyMovies.add(
          value.sublist(
            i,
            i + chunkSize > value.length ? value.length : i + chunkSize,
          ),
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
        dummyPausedMovies = [...statusGroupMovies['paused']];
      }
      if (statusGroupMovies['ended'] != null) {
        dummyWatchedMovies = [...statusGroupMovies['ended']];
      }
    } else {
      if (statusGroupMovies['paused'] != null) {
        for (var movie in statusGroupMovies['paused']) {
          if (movie['Subject']['reference'] == currentSubjectRef) {
            dummyPausedMovies.add(movie);
          }
        }
      }
      if (statusGroupMovies['ended'] != null) {
        for (var movie in statusGroupMovies['ended']) {
          if (movie['Subject']['reference'] == currentSubjectRef) {
            dummyWatchedMovies.add(movie);
          }
        }
      }
    }

    final filteredMovieHeadersMobile = movieHeaders
        .where((movieHeaderMobile) => movieHeaderMobile['type'] == 'mobile')
        .toList();

    final filteredMovieHeadersWeb = movieHeaders
        .where((movie) => movie['type'] == 'web')
        .toList();
    final randomHeaderMobile = filteredMovieHeadersMobile.length > 0
        ? filteredMovieHeadersMobile[math.Random().nextInt(
            filteredMovieHeadersMobile.length,
          )]
        : null;
    final randomHeaderWeb = filteredMovieHeadersWeb.length > 0
        ? filteredMovieHeadersWeb[math.Random().nextInt(
            filteredMovieHeadersWeb.length,
          )]
        : null;

    setState(() {
      currentHeaderMobile = randomHeaderMobile;
      currentHeaderWeb = randomHeaderWeb;
    });

    pausedMovies.clear();
    watchedMovies.clear();
    setState(() {
      for (var i = 0; i < dummyPausedMovies.length; i += chunkSize) {
        pausedMovies.add(
          dummyPausedMovies.sublist(
            i,
            i + chunkSize > dummyPausedMovies.length
                ? dummyPausedMovies.length
                : i + chunkSize,
          ),
        );
      }
      for (var i = 0; i < dummyWatchedMovies.length; i += chunkSize) {
        watchedMovies.add(
          dummyWatchedMovies.sublist(
            i,
            i + chunkSize > dummyWatchedMovies.length
                ? dummyWatchedMovies.length
                : i + chunkSize,
          ),
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          // mainAxisAlignment: MairnAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AssetsImage.defaultIcon.toImage(width: 24),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'E-DUTAINMENT',
                      style: TextStyle(
                        fontFamily: 'Football Attack',
                        color: Colors.white,
                        fontWeight: Theme.of(
                          context,
                        ).textTheme.titleLarge?.fontWeight!,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var subject in subjects)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: currentSubject == subject['_id']
                                ? ColorsPallet.blueAccent
                                : Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              // if(currentSubject == subject['_id']) {
                              //   currentSubject = 'all';
                              //   currentSubjectRef = 'all';
                              // } else {
                              currentSubject = subject['_id'];
                              currentSubjectRef = subject['reference'];
                              // }
                            });
                            updateMovies();
                          },
                          child: Center(
                            child: Text(
                              subject['label'].replaceAll('videos', ''),
                              style: TextStyle(
                                fontSize: 12,
                                color: currentSubject == subject['_id']
                                    ? ColorsPallet.blueAccent
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (currentHeaderWeb != null && currentHeaderMobile != null)
              OrientationBuilder(
                builder: (context, orientation) {
                  final isLandScape = orientation == Orientation.landscape;
                  final movie = isLandScape
                      ? currentHeaderWeb
                      : currentHeaderMobile;
                  final imageUrl = getIn(movie, 'picture', '');
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: GestureDetector(
                          onTap: () async {
                            await movieFetchAndRedirect(
                              getIn(movie, 'Movie'),
                              context,
                            );
                          },
                          child: AspectRatio(
                            aspectRatio: isLandScape ? 16 / 9 : 0.72,
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [CircularProgressIndicator()],
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
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
                              stops: const [0.0, 0.3, 0.8, 1.0],
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(.2),
                                Colors.black,
                                Colors.black,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 16,
                        right: 16,
                        child: Center(
                          child: CustomSubmitButton(
                            width: (MediaQuery.of(context).size.width * .5 > 200
                                ? 200
                                : MediaQuery.of(context).size.width * .5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(EdutainmentIcons.playEdutainment),
                                Container(
                                  margin: const EdgeInsets.only(left: 4),
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
                                getIn(movie, 'Movie'),
                                context,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
                                buildMovieFrame(movie: movie, context: context),
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
                                buildMovieFrame(movie: movie, context: context),
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
