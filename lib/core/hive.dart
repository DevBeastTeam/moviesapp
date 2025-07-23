import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  List<String> boxesList = [
    'config',
    'user',
    'statistics',
    'badges',
    'quiz',
    'movies',
  ];
  Map<String, dynamic> boxes = {};

  Future<void> init() async {
    for (var element in boxesList) {
      boxes[element] = null;
    }
    await Hive.initFlutter();
    await openBoxes();
    return;
  }

  Future<void> closeBoxes() async {
    var futureActions = [];
    for (var element in boxesList) {
      var currentBox = get(element);
      if (currentBox != null) {
        futureActions.add(currentBox.close());
      }
    }
    await Future.wait(Iterable.castFrom(futureActions));
    return;
  }

  Future<void> clearBox(elementName) async {
    try {
      var elementBox = Hive.box(elementName);
      await elementBox.clear();
    } catch (e) {
      // osef
    }

    return;
  }

  Future<void> clearBoxes(bool clearAll) async {
    var futureActions = [];
    for (var element in boxesList) {
      var currentBox = Hive.box(element);
      futureActions.add(currentBox.clear());
    }
    await Future.wait(Iterable.castFrom(futureActions));
    return;
  }

  Future<void> openBoxes() async {
    var futureActions = [];
    for (var element in boxesList) {
      futureActions.add(setOpenBoxes(element));
    }
    await Future.wait(Iterable.castFrom(futureActions));
    return;
  }

  Future<void> setOpenBoxes(elementName) async {
    boxes[elementName] = await Hive.openBox(elementName);
    return;
  }

  Box box(String box) {
    return Hive.box(box);
  }

  dynamic get(String box) {
    return boxes[box];
  }
}
