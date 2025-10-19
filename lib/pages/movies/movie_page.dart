import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutainment/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:humanize_duration/humanize_duration.dart';

import '../../utils/assets/assets_icons.dart';
import '../../utils/boxes.dart';
import '../../utils/movies.dart';
import '../../utils/utils.dart';
import '../../widgets/header_bar/custom_header_bar.dart';
import '../../widgets/ui/default_scaffold.dart';

class MoviePage extends ConsumerStatefulWidget {
  const MoviePage({super.key});

  @override
  ConsumerState<MoviePage> createState() => _MoviePage();
}

class _MoviePage extends ConsumerState<MoviePage> {
  final dynamic movie = moviesBox.get('movie');
  final dynamic historyMovie = moviesBox.get('historyMovie');

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: 'movies/movie',
      child: Column(
        children: [
          CustomHeaderBar(
            onBack: () async {
              // await fetchMovies();
              await moviesBox.put('movie', null);
              if (context.mounted) {
                context.pop();
              }
            },
            centerTitle: false,
            title: 'Films',
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 16, top: 12),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              getIn(movie, 'label'),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    context.go('/movies/movie/player');
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: getIn(movie, 'picture', ''),
                        imageBuilder: (context, imageProvider) => Container(
                          height: 184,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => SizedBox(
                          height: 184,
                          width: MediaQuery.of(context).size.width,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [CircularProgressIndicator()],
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      const Icon(EdutainmentIcons.playEdutainment, size: 100),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    humanizeDuration(
                      Duration(seconds: getIn(movie, 'duration', 0)),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorsPallet.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(getIn(movie, 'description')),
                        ),
                        if (getIn(movie, 'badgeToUnlock', null) != null)
                          const SizedBox(height: 8),
                        if (getIn(movie, 'badgeToUnlock', null) != null)
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Watch this film and unlock this badge !',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: ColorsPallet.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CachedNetworkImage(
                                  imageUrl: getIn(
                                    movie,
                                    'badgeToUnlock.picture',
                                    '',
                                  ),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        height: 64,
                                        width: 64,
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
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                '  Watch This Film and unlock this badge!',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge!.copyWith(color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              context.go('/home/fc');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Badge(
                  child: Icon(
                    Icons.splitscreen_sharp,
                    size: 17,
                    color: Colors.grey,
                  ),
                ),
                Text('  View FlashCards'),
              ],
            ),
          ),
          const SizedBox(height: 30),
          if (getIn(movie, 'similarMovies', []).isNotEmpty)
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Similar movies', style: TextStyle(fontSize: 16)),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (var movie in getIn(movie, 'similarMovies', []))
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
            ),
        ],
      ),
    );
  }
}
