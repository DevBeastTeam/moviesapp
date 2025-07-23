library;

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Core {
  Core._();

  static final Core _instance = Core._();

  static Core get instance => _instance;

  bool get startedCoreInitialized => _coreState != CoreStates.uninitialized;

  bool get coreInitialized => _coreState == CoreStates.initialized;

  CoreStates _coreState = CoreStates.uninitialized;

  CoreStates get coreState => _coreState;

  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  bool get isOnline => _connectivityResult != ConnectivityResult.none;

  bool? _updateAvailable;

  bool get updateAvailable => _updateAvailable ?? false;

  Future initCore({required Function(bool?) whenComplete}) async {
    _coreState = CoreStates.startInitialisation;

    try {
      var initFunctions = <Function>[];

      _connectivityResult = await Connectivity().checkConnectivity();
      Connectivity().onConnectivityChanged.listen(
        (event) => _connectivityResult = event,
      );
      //TODO: Make reconnect/disconnect search features.

      for (var element in initFunctions) {
        await element.call();
      }

      await _checkUpdateAvailable();
      _coreState = CoreStates.initialized;
      whenComplete.call(false);
    } catch (_) {
      if (kDebugMode) {
        print("_");
      }
      _coreState = CoreStates.uninitialized;
      whenComplete.call(true);
    }
  }

  Future _checkUpdateAvailable() async {
    if (kIsWeb) {
      _updateAvailable = false;
      return;
    }
    if (isOnline) {
      _updateAvailable = (await PackageInfo.fromPlatform()).version != '1.0.0';
    }
  }

  /*Future<String> get currentLocale async =>
      Core.instance.sharedPreferences!.getString('carbucalcul-locale') ??
      ((await Core.instance.sharedPreferences!.setString('carbucalcul-locale', Intl.systemLocale)) ? Intl.systemLocale : Intl.systemLocale);*/
}

enum CoreStates { uninitialized, startInitialisation, initialized }
