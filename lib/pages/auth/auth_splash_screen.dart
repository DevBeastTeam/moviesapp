import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edutainment/pages/splash_screen/v2/splash_screen_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../core/loader.dart';
import '../../utils/boxes.dart';
import '../../utils/utils.dart';
import '../../widgets/ui/primary_button.dart';
// import '../splash_screen/splash_screen_content.dart';
import '../welcome/welcome_page.dart';
import '../start/start_page.dart';
import '../auth/auth_page.dart';

class AuthSplashScreenPage extends StatefulWidget {
  const AuthSplashScreenPage({super.key});

  @override
  State<AuthSplashScreenPage> createState() => _AuthSplashScreenPage();
}

class _AuthSplashScreenPage extends State<AuthSplashScreenPage> {
  Future _init({required BuildContext context}) async {
    try {
      await fetchUser();
      // Update user data in GetX controller
      try {
        Get.find<UserController>().updateUserData();
      } catch (e) {
        // UserController might not be initialized yet, that's okay
      }
      var userData = userBox.get('data');
      var hasSawEntryPage = userData['saw_entry_page'] ?? false;
      var hasAnswerEntryQuiz = userData['answer_entry_quiz'] ?? false;
      if (context.mounted) {
        if (!hasSawEntryPage) {
          Get.to(() => const WelcomePage());
        } else if (!hasAnswerEntryQuiz) {
          Get.to(() => const StartPage());
        } else {
          await fetchAndRedirectHome(context);
        }
      }
    } catch (e) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        desc:
            'Une erreur est survenue, veuillez réessayer ulterierement ou contacter le support si le problème persiste.',
        btnOkOnPress: () {},
        btnOk: PrimaryButton(
          onPressed: () async {
            EasyLoading.show();
            await userBox.clear();
            Future.delayed(const Duration(seconds: 1), () {
              EasyLoading.dismiss();
              Get.to(() => const AuthPage());
            });
          },
          text: 'Quitter',
        ),
      ).show();
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
    // return const SplashScreenContent();
    return const SplashScreenPageV2();
  }
}
