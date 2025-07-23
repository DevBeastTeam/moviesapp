import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:edutainment/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/loader.dart';
import '../../utils/boxes.dart';
import '../../utils/utils.dart';
import '../../widgets/ui/primary_button.dart';
import '../splash_screen/splash_screen_content.dart';

class AuthSplashScreenPage extends ConsumerStatefulWidget {
  const AuthSplashScreenPage({super.key});

  @override
  ConsumerState<AuthSplashScreenPage> createState() => _AuthSplashScreenPage();
}

class _AuthSplashScreenPage extends ConsumerState<AuthSplashScreenPage> {
  Future _init({required BuildContext context}) async {
    try {
      await fetchUser();
      ref.read(userProvider.notifier).update();
      var userData = userBox.get('data');
      var hasSawEntryPage = userData['saw_entry_page'] ?? false;
      var hasAnswerEntryQuiz = userData['answer_entry_quiz'] ?? false;
      if (context.mounted) {
        if (!hasSawEntryPage) {
          context.go('/welcome');
        } else if (!hasAnswerEntryQuiz) {
          context.go('/start');
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
              context.go('/auth');
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
    return const SplashScreenContent();
  }
}
