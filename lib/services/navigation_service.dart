import 'package:flutter/material.dart';

/// NavigationService - Centralized navigation management
/// Replaces GoRouter with traditional MaterialPageRoute navigation
class NavigationService {
  // Global navigator key
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Get the current context
  static BuildContext? get context => navigatorKey.currentContext;

  // Get the navigator state
  static NavigatorState? get navigator => navigatorKey.currentState;

  /// Navigate to a new page
  static Future<T?>? navigateTo<T>(Widget page) {
    return navigator?.push<T>(MaterialPageRoute(builder: (_) => page));
  }

  /// Navigate to a named route
  static Future<T?>? navigateToNamed<T>(String routeName, {Object? arguments}) {
    return navigator?.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Replace current page with a new page
  static Future<T?>? replaceWith<T>(Widget page) {
    return navigator?.pushReplacement<T, void>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Replace current route with a named route
  static Future<T?>? replaceWithNamed<T>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator?.pushReplacementNamed<T, void>(
      routeName,
      arguments: arguments,
    );
  }

  /// Go back to previous page
  static void goBack<T>([T? result]) {
    if (navigator?.canPop() ?? false) {
      navigator?.pop<T>(result);
    }
  }

  /// Pop until a specific route
  static void popUntil(String routeName) {
    navigator?.popUntil(ModalRoute.withName(routeName));
  }

  /// Pop until first route (clear stack)
  static void popToRoot() {
    navigator?.popUntil((route) => route.isFirst);
  }

  /// Remove all routes and navigate to a new page
  static Future<T?>? navigateAndRemoveUntil<T>(
    Widget page, {
    bool Function(Route<dynamic>)? predicate,
  }) {
    return navigator?.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate ?? (route) => false,
    );
  }

  /// Remove all routes and navigate to a named route
  static Future<T?>? navigateToNamedAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return navigator?.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Check if we can go back
  static bool canGoBack() {
    return navigator?.canPop() ?? false;
  }
}
