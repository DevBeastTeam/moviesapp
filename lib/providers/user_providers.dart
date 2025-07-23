import 'package:edutainment/utils/boxes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends Notifier<dynamic> {
  // We initialize the list of todos to an empty list
  @override
  List<dynamic> build() {
    final dynamic userData = userBox.get('data');
    return userData;
  }

  void update() {
    final dynamic userData = userBox.get('data');
    print('------------');
    print('updated state');
    state = userData;
  }
}

// Finally, we are using NotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final userProvider = NotifierProvider<UserNotifier, dynamic>(() {
  return UserNotifier();
});
