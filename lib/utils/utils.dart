import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/loader.dart';
import 'boxes.dart';

String? isLoggedIn() {
  return userBox.get('token');
}

Future<void> fetchData() async {
  await Future.wait(
      [fetchBadges(), fetchMovies(), fetchUser(), fetchQuizCategories()]);
}

Future<void> fetchAndRedirectHome(BuildContext context) async {
  await fetchData();
  if (context.mounted) {
    context.go('/home');
  }
}

dynamic getIn(object, path, [defaultValue = '']) {
  if (object == null) {
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

  Map? pointer = object;
  dynamic returnValue = defaultValue;
  for (var i = 0; i < finalPaths.length; i++) {
    final node = finalPaths[i];
    if (!pointer!.containsKey(node)) {
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
