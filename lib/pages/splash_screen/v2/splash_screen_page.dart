import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edutainment/constants/screenssize.dart';
import 'package:edutainment/pages/auth/v2/auth_page.dart';
import 'package:edutainment/pages/auth/auth_splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';

import '../../../constants/appimages.dart';
import '../../../core/core.dart';
import '../../../utils/boxes.dart';
import '../../../widgets/indicators/double_circular_progress_indicator.dart';
import '../../../widgets/ui/primary_button.dart';

class SplashScreenPageV2 extends StatefulWidget {
  const SplashScreenPageV2({super.key});

  @override
  State<SplashScreenPageV2> createState() => _SplashScreenPageV2State();
}

class _SplashScreenPageV2State extends State<SplashScreenPageV2> {
  Future _init({required BuildContext context}) async {
    if (!Core.instance.coreInitialized &&
        !Core.instance.startedCoreInitialized) {
      Future.delayed(
        const Duration(seconds: 3),
        () => Core.instance.initCore(
          whenComplete: (error) async {
            debugPrint('👉 on splash screen wait');
            if (error == false) {
              if (!Core.instance.isOnline) {
                await AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  title: 'Connexion internet',
                  desc:
                      "Vous n'êtes pas connecté à internet,  vérifier votre modem/router et assurez-vous d'être connecté à internet.",
                  btnOkOnPress: () {},
                  btnOk: PrimaryButton(
                    onPressed: () => exit(0),
                    text: 'Quitter',
                  ),
                ).show();
              } else {
                // Check if user has a saved token for persistent login
                final savedToken = userBox.get('token');

                if (savedToken != null && savedToken.toString().isNotEmpty) {
                  debugPrint('👉 Found saved token, auto-logging in...');
                  // User has a saved token, skip login and go to auth splash
                  if (context.mounted) {
                    Get.to(() => const AuthSplashScreenPage());
                  }
                } else {
                  debugPrint('👉 No saved token, showing login page');
                  // No saved token, show login page
                  Get.to(() => const AuthPageV2());
                }
              }
            } else {
              await AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                title: 'Error',
                desc:
                    'Une erreur est survenue, veuillez réessayer ulterieurement ou contacter le support si le problème persiste.',
                btnOkOnPress: () {},
                btnOk: PrimaryButton(onPressed: () => exit(0), text: 'Quitter'),
              ).show();
            }
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _init(context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1929), Color(0xFF0D2137), Color(0xFF0A1929)],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background pattern/texture
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: Image.asset(AppImages.bgLogin, fit: BoxFit.cover),
              ),
            ),
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo
                Container(
                  width: Screen.isPhone(context)
                      ? Screen.width(context) * 0.5
                      : Screen.width(context) * 0.25,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),

                  child: Image.asset(AppImages.playerlight, fit: BoxFit.contain)
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(
                        begin: const Offset(0.7, 0.7),
                        end: const Offset(1.3, 1.3),
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                      )
                      .scale(
                        begin: const Offset(1.3, 1.3),
                        end: const Offset(0.7, 0.7),
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                      ),
                ),

                const SizedBox(height: 10),

                // App name
                const Text(
                  'E-DUTAINMENT',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Football Attack',
                    color: Colors.white,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // Tagline
                const Text(
                  'WATCH. PLAY. PROGRESS',
                  style: TextStyle(
                    fontSize: 27,
                    fontFamily: 'Football Attack',
                    color: Colors.white,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(flex: 2),

                // Loading indicator
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: DoubleCircularProgressIndicator(),
                ),

                const Spacer(flex: 1),

                // Footer
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Powered and proudly made in France 🇫🇷 by',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      AppImages.bannerColor,
                      width: Screen.isPhone(context)
                          ? Screen.width(context) * 0.7
                          : Screen.isTablet(context)
                          ? Screen.width(context) * 0.35
                          : Screen.width(context) * 0.7,
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
