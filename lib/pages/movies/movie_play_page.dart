import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/api_helper.dart';
import '../../utils/boxes.dart';
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
  final dynamic movie = moviesBox.get('movie');
  final dynamic historyMovie = moviesBox.get('historyMovie');
  int startTime = 0;

  @override
  void initState() {
    if (historyMovie != null && historyMovie.length > 0) {
      final status = getIn(historyMovie[0], 'status');
      if (status == 'paused') {
        startTime = getIn(historyMovie[0], 'time');
      }
    }
    super.initState();
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
    var baseApi = ApiHelper();
    // var response = await baseApi.get('https://api.npoint.io/4f2d4c19f1da5a387032', null);
    // var response = await baseApi.get('https://api.npoint.io/b6000476ff8de4c02e8c', null);
    var response = await baseApi.get('/movies/$id/questions', null);
    return response['questions'];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: 'movies/movie/player',
      hideBottomBar: true,
      child: SafeArea(
        child: FutureBuilder(
          future: fetchMoviePlay(getIn(movie, '_id')),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var result = snapshot.data;
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
