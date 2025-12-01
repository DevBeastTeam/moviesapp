import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edutainment/pages/auth/v2/login_screen.dart';
import 'package:edutainment/widgets/ui/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../constants/appimages.dart';
import '../../../constants/screenssize.dart';
import '../../../core/api_helper.dart';
import '../../auth/auth_splash_screen.dart';
import '../../../utils/boxes.dart';
import '../../../utils/utils.dart';

class AuthPageV2 extends StatefulWidget {
  const AuthPageV2({super.key});

  @override
  State<AuthPageV2> createState() => _AuthPageV2State();
}

class _AuthPageV2State extends State<AuthPageV2> {
  final PageController _pageController = PageController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  ApiHelper baseApi = ApiHelper();

  @override
  void dispose() {
    _pageController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      if (context.mounted) {
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: 'Please enter both username and password',
          btnOkOnPress: () {},
          btnOk: PrimaryButton(
            onPressed: () => Navigator.of(context).pop(),
            text: 'Close',
          ),
        ).show();
      }
      return;
    }

    EasyLoading.show();
    var response = await baseApi.post('/auth/token', {
      'username': usernameController.text,
      'password': passwordController.text,
    }, context);

    await EasyLoading.dismiss();

    if (!mounted) return;

    if (getIn(response, 'success') == false) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: '${getIn(response, 'message')}',
        desc:
            'Une erreur est survenue, veuillez réessayer ulterieurement ou contacter le support si le problème persiste.',
        btnOkOnPress: () {},
        btnOk: PrimaryButton(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Close',
        ),
      ).show();
    } else {
      await userBox.put('token', getIn(response, 'token'));
      Get.to(() => const AuthSplashScreenPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          ///// login intro page
          Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0A1929),
                    Color(0xFF0D2137),
                    Color(0xFF0A1929),
                  ],
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
                        onTap: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          width: Screen.width(context) * 0.5,
                          height: Screen.width(context) * 0.5,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),

                          child:
                              Image.asset(
                                    AppImages.playerlight,
                                    fit: BoxFit.contain,
                                  )
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
          ),
          ///// login page
          LoginScreenV2(
            usernameController: usernameController,
            passwordController: passwordController,
            onLoginPressed: _handleLogin,
          ),
        ],
      ),
    );
  }
}
