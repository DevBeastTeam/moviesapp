import '../core/api_helper.dart';

Future<dynamic> getRandomQuestion() async {
  var baseApi = ApiHelper();
  var response = await baseApi.get('/questions/random', null);
  return response;
}

Future<dynamic> saveRandomQuestion(questionId, options, ctx) async {
  var baseApi = ApiHelper();
  var response =
      await baseApi.post('/questions/$questionId/save', options, ctx);
  return response;
}
