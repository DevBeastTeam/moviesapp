import '../core/api_helper.dart';
import '../core/loader.dart';
import 'boxes.dart';
import 'utils.dart';

Future<dynamic> saveEntryQuizAnswers(answers) async {
  var baseApi = ApiHelper();
  var response =
      await baseApi.post('/quizz/entry-quiz/save', {'answers': answers}, null);
  return response;
}

Future<dynamic> saveQuizAnswers(id, answers) async {
  var baseApi = ApiHelper();
  var response =
      await baseApi.post('/quizz/$id/save', {'answers': answers}, null);

  var quizSessionResult =
      await fetchQuizResults(id, getIn(response, 'quizSession._id'));
  await quizBox.put('quizSession', getIn(quizSessionResult, 'quizSession'));
  await quizBox.put('currentQuiz', getIn(quizSessionResult, 'quiz'));
  await quizBox.put(
      'totalCorrectAnswer', getIn(quizSessionResult, 'totalCorrectAnswer'));

  return response;
}
