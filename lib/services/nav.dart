import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Nav - Simple navigation helper using GetX
class Nav {
  /// Navigate to a new page
  static Future<T?>? to<T>(Widget page) {
    return Get.to<T>(() => page);
  }

  /// Navigate and remove current page
  static Future<T?>? off<T>(Widget page) {
    return Get.off<T>(() => page);
  }

  /// Navigate and remove all previous pages
  static Future<T?>? offAll<T>(Widget page) {
    return Get.offAll<T>(() => page);
  }

  /// Go back to previous page
  static void back<T>([T? result]) {
    Get.back<T>(result: result);
  }

  /// Check if can go back
  static bool canBack() {
    return Get.key.currentState?.canPop() ?? false;
  }

  /// Close dialog/bottom sheet/snackbar
  static void close() {
    Get.back();
  }
}
