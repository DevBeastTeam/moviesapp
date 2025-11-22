import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/movies_controller.dart';
import '../../core/api_helper.dart';
import '../../utils/utils.dart';
import '../../widgets/indicators/double_circular_progress_indicator.dart';
import '../../widgets/ui/default_scaffold.dart';
import 'widgets/player.dart';

class MoviePlayPage extends StatefulWidget {
  const MoviePlayPage({super.key});

  @override
  State<MoviePlayPage> createState() => _MoviePlayPage();
}

class _MoviePlayPage extends State<MoviePlayPage> {
  final MoviesController controller = Get.find<MoviesController>();
  int startTime = 0;

  @override
  void initState() {
    super.initState();

    // Get movie from controller
    final movie = controller.selectedMovie.value;

    // Check if there's history data
    if (movie != null) {
      final historyMovie = getIn(movie, 'historyMovie');
      if (historyMovie != null &&
          historyMovie is List &&
          historyMovie.isNotEmpty) {
        final status = getIn(historyMovie[0], 'status');
        if (status == 'paused') {
          startTime = getIn(historyMovie[0], 'time', 0);
        }
      }
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<dynamic> fetchMoviePlay(id) async {
    try {
      var baseApi = ApiHelper();
      // var response = await baseApi.get('https://api.npoint.io/4f2d4c19f1da5a387032', null);
      // var response = await baseApi.get('https://api.npoint.io/b6000476ff8de4c02e8c', null);
      var response = await baseApi.get('/movies/$id/questions', null);

      if (response != null && response['questions'] != null) {
        return response['questions'];
      }

      // Return empty array if no questions found
      debugPrint('⚠️ No questions found for movie $id');
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching movie questions: $e');
      // Return empty array on error so the movie can still play
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = controller.selectedMovie.value;

    // Show error if movie is null
    if (movie == null) {
      return DefaultScaffold(
        currentPage: 'movies/movie/player',
        hideBottomBar: true,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Movie not found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please select a movie to play',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DefaultScaffold(
      currentPage: 'movies/movie/player',
      hideBottomBar: true,
      child: SafeArea(
        child: FutureBuilder(
          future: fetchMoviePlay(getIn(movie, '_id')),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              debugPrint('❌ FutureBuilder error: ${snapshot.error}');
              // Still show player with empty questions on error
              return MoviePlayer(
                movie: movie,
                questions: [],
                startAt: startTime,
              );
            }

            if (snapshot.hasData) {
              var result = snapshot.data ?? [];
              return MoviePlayer(
                movie: movie,
                questions: result,
                startAt: startTime,
              );
            } else {
              return Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: const DoubleCircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
