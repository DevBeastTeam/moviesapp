import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/api_helper.dart';
import '../models/movie_model.dart';
import '../utils/utils.dart';

class MoviesController extends GetxController {
  final ApiHelper _api = ApiHelper();

  // State variables
  var subjects = <MovieSubject>[].obs;
  var tags = <MovieTag>[].obs;
  var groupMovies = <String, List<Movie>>{}.obs;
  var statusGroupMovies = <String, List<Movie>>{}.obs;

  // UI State
  var currentSubject = 'all'.obs;
  var currentSubjectRef = 'all'.obs;
  var featuredMovie = Rxn<Movie>();
  var selectedMovie = Rxn<Map<String, dynamic>>();

  // Processed lists for UI
  var moviesByTag = <Map<String, dynamic>>[].obs;
  var pausedMovies = <Movie>[].obs; // Flat list
  var watchedMovies = <Movie>[].obs; // Flat list

  var isLoading = false.obs;
  var isMovieLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  // GET /movies/list
  Future<void> fetchMovies() async {
    try {
      isLoading.value = true;
      final response = await _api.get('/movies/list', null);

      if (response != null) {
        // Parse Subjects
        final subjectsData = getIn(response, 'subjects', []) ?? [];
        subjects.value = (subjectsData as List)
            .map((e) => MovieSubject.fromJson(e))
            .toList();

        // Parse Tags
        final tagsData = getIn(response, 'tags', []) ?? [];
        tags.value = (tagsData as List)
            .map((e) => MovieTag.fromJson(e))
            .toList();

        // Parse Group Movies
        final groupMoviesData = getIn(response, 'groupMovies', {}) ?? {};
        final Map<String, List<Movie>> parsedGroupMovies = {};
        groupMoviesData.forEach((key, value) {
          if (value is List) {
            parsedGroupMovies[key] = value
                .map((e) => Movie.fromJson(e))
                .toList();
          }
        });
        groupMovies.value = parsedGroupMovies;

        // Parse Status Group Movies
        final statusGroupMoviesData =
            getIn(response, 'statusGroupMovies', {}) ?? {};
        final Map<String, List<Movie>> parsedStatusGroupMovies = {};
        statusGroupMoviesData.forEach((key, value) {
          if (value is List) {
            parsedStatusGroupMovies[key] = value
                .map((e) => Movie.fromJson(e))
                .toList();
          }
        });
        statusGroupMovies.value = parsedStatusGroupMovies;

        updateMoviesList();
      }
    } catch (e) {
      print('Error fetching movies: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // GET /movies/{id}
  Future<dynamic> fetchMovieDetails(String id) async {
    try {
      isMovieLoading.value = true;
      final response = await _api.get('/movies/$id', null);
      return response;
    } catch (e) {
      print('Error fetching movie details: $e');
      return null;
    } finally {
      isMovieLoading.value = false;
    }
  }

  // GET /movies/{id}/questions
  Future<List<dynamic>> getMovieQuestions(String movieId) async {
    try {
      debugPrint('📡 Fetching questions for movie: $movieId');
      final response = await _api.get('/movies/$movieId/questions', null);

      if (response != null && response['questions'] != null) {
        debugPrint('✅ Got ${response['questions'].length} questions');
        return response['questions'] as List<dynamic>;
      }

      debugPrint('⚠️ No questions found for movie $movieId');
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching movie questions: $e');
      return [];
    }
  }

  // POST /movies/{id}/history
  Future<bool> updateMovieHistory(
    String movieId, {
    required String status, // 'paused', 'ended', 'playing'
    required int time, // Time in seconds
  }) async {
    try {
      debugPrint('📡 Updating movie history: $movieId - $status at ${time}s');

      final data = {'status': status, 'time': time};

      final response = await _api.post('/movies/$movieId/history', data, null);

      if (response != null) {
        debugPrint('✅ Movie history updated successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ Error updating movie history: $e');
      return false;
    }
  }

  // GET /movies/{movieId}/subjects
  Future<dynamic> getMovieSubjects(String movieId) async {
    try {
      debugPrint('📡 Fetching subjects for movie: $movieId');
      final response = await _api.get('/movies/$movieId/subjects', null);

      if (response != null) {
        debugPrint('✅ Got movie subjects');
        return response;
      }

      debugPrint('⚠️ No subjects found for movie $movieId');
      return null;
    } catch (e) {
      debugPrint('❌ Error fetching movie subjects: $e');
      return null;
    }
  }

  // Logic to filter and organize movies based on current subject
  void updateMoviesList() {
    moviesByTag.clear();
    var localMoviesByTag = <String, List<Movie>>{};
    Movie? movieToFeature;

    // Filter Group Movies
    if (currentSubjectRef.value == 'all') {
      if (groupMovies.isNotEmpty) {
        for (final key in groupMovies.keys) {
          final movies = groupMovies[key];
          if (movies != null && movies.isNotEmpty) {
            movieToFeature = movies.first;
            break;
          }
        }
      }
      groupMovies.forEach((key, value) {
        for (var movie in value) {
          if (movie.tags != null) {
            for (var tag in movie.tags!) {
              if (!localMoviesByTag.containsKey(tag)) {
                localMoviesByTag[tag] = [movie];
              } else {
                localMoviesByTag[tag]!.add(movie);
              }
            }
          }
        }
      });
    } else {
      final ref = currentSubjectRef.value;
      if (groupMovies[ref] != null && groupMovies[ref]!.isNotEmpty) {
        movieToFeature = groupMovies[ref]!.first;
      }
      if (groupMovies[ref] != null) {
        for (var movie in groupMovies[ref]!) {
          if (movie.tags != null) {
            for (var tag in movie.tags!) {
              if (!localMoviesByTag.containsKey(tag)) {
                localMoviesByTag[tag] = [movie];
              } else {
                localMoviesByTag[tag]!.add(movie);
              }
            }
          }
        }
      }
    }

    featuredMovie.value = movieToFeature;

    // Chunking and limiting
    // We will expose the full list (or limited by maxMoviesPerTag) and let the UI handle chunking for responsiveness.
    final maxMoviesPerTag = 36;

    localMoviesByTag.forEach((key, value) {
      var tagTitle = '';
      for (var tag in tags) {
        if (tag.reference == key && tag.enabled == true) {
          tagTitle = tag.label;
          break;
        }
      }

      if (tagTitle.isNotEmpty) {
        // Limit to maxMoviesPerTag but don't chunk here
        var limitedMovies = value.take(maxMoviesPerTag).toList();

        moviesByTag.add({
          'tag': key,
          'title': tagTitle,
          'movies': limitedMovies, // List<Movie>
        });
      }
    });

    // Paused and Watched
    var dummyPausedMovies = <Movie>[];
    var dummyWatchedMovies = <Movie>[];

    if (currentSubjectRef.value == 'all') {
      if (statusGroupMovies['paused'] != null) {
        dummyPausedMovies = statusGroupMovies['paused']!
            .take(maxMoviesPerTag)
            .toList();
      }
      if (statusGroupMovies['ended'] != null) {
        dummyWatchedMovies = statusGroupMovies['ended']!
            .take(maxMoviesPerTag)
            .toList();
      }
    } else {
      final ref = currentSubjectRef.value;
      if (statusGroupMovies['paused'] != null) {
        dummyPausedMovies = statusGroupMovies['paused']!
            .where((m) => m.subject?.reference == ref)
            .take(maxMoviesPerTag)
            .toList();
      }
      if (statusGroupMovies['ended'] != null) {
        dummyWatchedMovies = statusGroupMovies['ended']!
            .where((m) => m.subject?.reference == ref)
            .take(maxMoviesPerTag)
            .toList();
      }
    }

    // Update observables with flat lists
    pausedMovies.value = dummyPausedMovies;
    watchedMovies.value = dummyWatchedMovies;
  }

  void setSubject(String id, String ref) {
    currentSubject.value = id;
    currentSubjectRef.value = ref;
    updateMoviesList();
  }

  // Legacy method support if needed, or we can remove/update
  final _loadingFor = "".obs;
  String get loadingFor => _loadingFor.value;
  void setLoadingF([String name = ""]) {
    _loadingFor.value = name;
  }

  void getMovieByIdF(
    BuildContext context, {
    String movieId = '',
    String loadingFor = '',
    bool isRefresh = false,
  }) async {
    // This seems to be for exercises, keeping it for now but it might be better placed in ExercisesController?
    // Or if it's used by movie widgets.
    try {
      setLoadingF(loadingFor);
      var data = await _api.get('/movies/$movieId/subjects', context);
      log('👉 movieById: $data');
      // ... existing logic ...
    } catch (e, st) {
      log('💥 try catch when: getMovieByIdF Error: $e, st:$st');
    } finally {
      setLoadingF();
    }
  }
}
