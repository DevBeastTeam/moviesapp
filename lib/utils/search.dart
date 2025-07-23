import '../core/api_helper.dart';

Future<dynamic> fetchWord(word) async {
  var baseApi = ApiHelper();
  var response = await baseApi.get('/search', null, body: {'searchq': word});
  return response;
}
