import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:duration/duration.dart';

import '../pages/home/home_page.dart';
import '../../core/loader.dart';
import 'boxes.dart';

String? isLoggedIn() {
  return userBox.get('token');
}

Future<void> fetchData() async {
  await Future.wait([
    fetchBadges(),
    fetchMovies(),
    fetchUser(),
    fetchQuizCategories(),
  ]);
}

Future<void> fetchAndRedirectHome(BuildContext context) async {
  await fetchData();
  if (context.mounted) {
    Get.to(() => const HomePage());
  }
}

dynamic getIn(object, path, [defaultValue = '']) {
  if (object == null || object is! Map) {
    return defaultValue;
  }
  var varType = path.runtimeType.toString();
  var finalPaths = [];
  if (varType.contains('List')) {
    finalPaths = path;
  }
  if (varType == 'String') {
    finalPaths = path.split('.');
  }
  assert(finalPaths.isNotEmpty);

  Map pointer = object;
  dynamic returnValue = defaultValue;
  for (var i = 0; i < finalPaths.length; i++) {
    final node = finalPaths[i];
    if (!pointer.containsKey(node)) {
      break;
    }
    if (i == finalPaths.length - 1) {
      returnValue = pointer[node] ?? defaultValue;
      break;
    } else {
      if (pointer[node] is! Map) {
        break;
      }
      pointer = pointer[node];
    }
  }
  return returnValue;
}

void prettyPrintJSON(jsonData) {
  var encoder = const JsonEncoder.withIndent('  ');
  try {
    var prettyPrint = encoder.convert(jsonData);
    if (kDebugMode) {
      debugPrint(prettyPrint);
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint(jsonData);
    }
  }
}

String formatDuration(Duration duration, {bool short = false}) {
  String result = prettyDuration(
    duration,
    tersity: DurationTersity.millisecond,
    delimiter: ', ',
    conjunction: ', ',
  );
  if (short) {
    return result
        .replaceAll(' years', 'y')
        .replaceAll(' year', 'y')
        .replaceAll(' months', 'mo')
        .replaceAll(' month', 'mo')
        .replaceAll(' weeks', 'w')
        .replaceAll(' week', 'w')
        .replaceAll(' days', 'd')
        .replaceAll(' day', 'd')
        .replaceAll(' hours', 'h')
        .replaceAll(' hour', 'h')
        .replaceAll(' minutes', 'm')
        .replaceAll(' minute', 'm')
        .replaceAll(' seconds', 's')
        .replaceAll(' second', 's')
        .replaceAll(' milliseconds', 'ms')
        .replaceAll(' millisecond', 'ms')
        .replaceAll(',', '');
  }
  return result;
}
