import '../core/api_helper.dart';

Future<dynamic> saveUser(data, ctx) async {
  var baseApi = ApiHelper();
  var response = await baseApi.post('/users/edit', data, ctx);
  return response;
}
