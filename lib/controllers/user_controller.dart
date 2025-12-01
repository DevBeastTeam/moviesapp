import 'package:get/get.dart';
import 'package:edutainment/utils/boxes.dart';

class UserController extends GetxController {
  final _userData = Rx<dynamic>(null);
  dynamic get userData => _userData.value;

  final _isLoggedIn = false.obs;
  bool get isLoggedIn => _isLoggedIn.value;

  @override
  void onInit() {
    super.onInit();
    _userData.value = userBox.get('data');
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    final token = userBox.get('token');
    _isLoggedIn.value = token != null && token.toString().isNotEmpty;
  }

  void updateUserData() {
    final dynamic data = userBox.get('data');
    print('------------');
    print('updated state');
    _userData.value = data;
    _checkLoginStatus();
  }

  String? getToken() {
    return userBox.get('token')?.toString();
  }

  Future<void> logout() async {
    await userBox.clear();
    _userData.value = null;
    _isLoggedIn.value = false;
  }
}
