import '../utils/boxes.dart';
import '../utils/utils.dart';
import 'api_helper.dart';
import 'hive.dart';

Future<void> initHive() async {
  final hiveHelper = HiveHelper();
  await hiveHelper.closeBoxes();
  await hiveHelper.init();
}

Future<void> saveSawEntryPage() async {
  var baseApi = ApiHelper();
  await baseApi.post('/users/saw-entry-page', null, {});
  return;
}

Future<void> fetchBadges() async {
  var baseApi = ApiHelper();
  var response = await baseApi.get('/badges/list', null);
  await badgesBox.put('data', getIn(response, 'badges'));
  return;
}

Future<void> fetchQuizCategories() async {
  var baseApi = ApiHelper();
  var response = await baseApi.get('/quizz/categories/list', null);
  await quizBox.put('quizCategories', getIn(response, 'categories'));
  return;
}

Future<void> fetchQuizz(category, type) async {
  var baseApi = ApiHelper();
  var response =
      await baseApi.get('/quizz/categories/$category/$type/list', null);
  await quizBox.put('quizz', getIn(response, 'quizz'));
  await quizBox.put('quizCategory', getIn(response, 'quizCategory'));
  await quizBox.put('type', getIn(response, 'type'));
  return;
}

Future<void> fetchQuizStart(id) async {
  var baseApi = ApiHelper();
  var response = await baseApi.get('/quizz/$id/start', null);
  await quizBox.put('currentQuiz', getIn(response, 'quiz'));
  return;
}

Future<dynamic> fetchQuizResults(id, session) async {
  var baseApi = ApiHelper();
  var response = await baseApi.get('/quizz/$id/results/$session', {});

  return response;
}

Future<void> cleanQuiz() async {
  await quizBox.put('currentQuiz', null);
  await quizBox.put('quizSession', null);
  await quizBox.put('totalCorrectAnswer', null);
  return;
}

Future<void> fetchEntryQuiz() async {
  var baseApi = ApiHelper();
  var response = await baseApi.get('/quizz/entry-quiz', null);
  await quizBox.put('entryQuiz', getIn(response, 'entryQuiz'));
  return;
}

Future<dynamic> fetchEntryQuizResults() async {
  var baseApi = ApiHelper();
  var response = await baseApi.get('/quizz/entry-quiz/results', null);
  return response;
}

Future<void> fetchMovies() async {
  var baseApi = ApiHelper();
  var response = await baseApi.get('/movies/list', null);
  await moviesBox.put('groupMovies', getIn(response, 'groupMovies'));
  await moviesBox.put(
      'statusGroupMovies', getIn(response, 'statusGroupMovies'));
  await moviesBox.put('movieHeaders', getIn(response, 'movieHeaders'));
  await moviesBox.put('subjects', getIn(response, 'subjects'));
  await moviesBox.put('tags', getIn(response, 'tags'));
  return;
}

Future<dynamic> fetchMovie(id) async {
  var baseApi = ApiHelper();
  var response = await baseApi.get('/movies/$id', null);
  return response;
}

Future<void> fetchUser() async {
  var baseApi = ApiHelper();
  var response = await baseApi.get('/auth/me', null);
  await userBox.put('data', getIn(response, 'user'));
  await statisticsBox.put('data', getIn(response, 'statistics'));
  await badgesBox.put('history', getIn(response, 'historyBadges'));
  return;
}
