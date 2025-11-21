import 'package:flutter_easyloading/flutter_easyloading.dart';

/// ToastService - Wrapper for EasyLoading to show toasts and loading indicators
class ToastService {
  /// Show success message
  static Future<void> showSuccess(String message) {
    return EasyLoading.showSuccess(
      message,
      duration: const Duration(seconds: 2),
    );
  }

  /// Show error message
  static Future<void> showError(String message) {
    return EasyLoading.showError(message, duration: const Duration(seconds: 3));
  }

  /// Show info message
  static Future<void> showInfo(String message) {
    return EasyLoading.showInfo(message, duration: const Duration(seconds: 2));
  }

  /// Show loading indicator
  static Future<void> showLoading({String? message}) {
    return EasyLoading.show(
      status: message ?? 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
  }

  /// Show progress indicator
  static Future<void> showProgress(double progress, {String? message}) {
    return EasyLoading.showProgress(progress, status: message);
  }

  /// Dismiss loading/toast
  static Future<void> dismiss() {
    return EasyLoading.dismiss();
  }

  /// Show toast (general purpose)
  static Future<void> showToast(
    String message, {
    Duration? duration,
    EasyLoadingToastPosition? position,
  }) {
    return EasyLoading.showToast(
      message,
      duration: duration ?? const Duration(seconds: 2),
      toastPosition: position ?? EasyLoadingToastPosition.bottom,
    );
  }
}
