// import 'package:appspector/appspector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/loader.dart';
import 'router/routes.dart';
import 'theme/theme.dart';

// import 'package:html_to_flutter/html_to_flutter.dart';

// Global navigator key for accessing context anywhere
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  // runAppSpector();
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode
        .edgeToEdge, // if edge to edge then  status bar color will be shown
    // other wise will be hide status bar icons.
    overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
  );
  SystemChrome.setSystemUIOverlayStyle(
    // const SystemUiOverlayStyle(statusBarColor: ColorsPallet.darkBlue),
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black38,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: MyApp()));
  configLoading();
}

// void runAppSpector() {
//   final config = Config()
//     ..iosApiKey = "ios_M2Y0NTg1ZTItZmI0NC00MjlkLWE4Y2QtODM2MjJmNzkyZGY0";
//
//   config.monitors = [Monitors.logs];
//
//   AppSpectorPlugin.run(config);
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,

      title: 'E-Dutainment',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      themeMode: ThemeMode.light,
      routerConfig: appRoutes,
      builder: EasyLoading.init(),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..dismissOnTap = false;
}







// login  ->
// name: tomcruise 
// pass: tomcruise



// flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 const Color(0xff181818),
//                 Colors.green.withOpacity(0.6),
//                 const Color(0xff181818),
//               ],
//             ),
//           ),
//         ),

// Html(
//   config: HtmlConfig(
//     onTap: (url, [attributes, element]) {},
//   ),
//   padding: const EdgeInsets.all(10),
//   renderMode: RenderMode.column,
//   data: '${ref.watch(gptVm).respIs}'),


// currently worked pages 
// ProfileButtons
// flashcardspage