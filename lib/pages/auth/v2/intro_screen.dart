import 'package:edutainment/constants/appimages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../constants/screenssize.dart';

class IntroScreenV2 extends StatelessWidget {
  const IntroScreenV2({super.key});

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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: Screen.width(context) * 0.5,
                    height: Screen.width(context) * 0.5,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),

                    child:
                        Image.asset(AppImages.playerlight, fit: BoxFit.contain)
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
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
                ),

                const SizedBox(height: 10),

                const Spacer(flex: 2),

                // Tagline
                const Text(
                  'Bienvenue sur e-dutainment. \n Pour vous connecter, veuillez swiper à droite.',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 14,

                    fontFamily: 'Football Attack',
                    color: Colors.white,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 70),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
