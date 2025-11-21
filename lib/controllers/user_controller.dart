import 'package:get/get.dart';
import 'package:edutainment/utils/boxes.dart';

class UserController extends GetxController {
  final _userData = Rx<dynamic>(null);
  dynamic get userData => _userData.value;

  @override
  void onInit() {
    super.onInit();
    _userData.value = userBox.get('data');
  }

  void updateUserData() {
    final dynamic data = userBox.get('data');
    print('------------');
    print('updated state');
    _userData.value = data;
  }
}
