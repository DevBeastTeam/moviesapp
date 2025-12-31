import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/movies_controller.dart';
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

  // Cache the future so it doesn't re-execute on orientation changes
  late Future<List<dynamic>>? _questionsFuture;

  // Cache the built widget to prevent recreation on orientation changes
  Widget? _playerWidget;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Allow all orientations for the movie player
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

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

      // Initialize the cached future once in initState
      _questionsFuture = controller.getMovieQuestions(getIn(movie, '_id'));

      // Load data and build player widget once
      _loadPlayerWidget();
    } else {
      _questionsFuture = null;
      _isLoading = false;
    }
  }

  Future<void> _loadPlayerWidget() async {
    final movie = controller.selectedMovie.value;
    if (_questionsFuture != null && movie != null) {
      try {
        final questions = await _questionsFuture!;
        if (mounted) {
          setState(() {
            _playerWidget = MoviePlayer(
              movie: movie,
              questions: questions,
              startAt: startTime,
            );
            _isLoading = false;
          });
        }
      } catch (e) {
        debugPrint('❌ Error loading questions: $e');
        if (mounted) {
          setState(() {
            _playerWidget = MoviePlayer(
              movie: movie,
              questions: [],
              startAt: startTime,
            );
            _isLoading = false;
          });
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
      child: _isLoading
          ? Center(
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                child: const DoubleCircularProgressIndicator(),
              ),
            )
          : _playerWidget ??
                MoviePlayer(movie: movie, questions: [], startAt: startTime),
    );
  }
}
