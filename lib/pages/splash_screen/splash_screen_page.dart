import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';
import '../../widgets/ui/primary_button.dart';
import 'splash_screen_content.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPage();
}

class _SplashScreenPage extends State<SplashScreenPage> {
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
              }
              /* else if (Core.instance.updateAvailable) {
                    await AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        title: 'Mise à jour',
                        desc:
                            "Une mise à jour et disponible, afin de vous garantir une meilleure expérience, veuillez m'être à jour l'application.",
                        btnOkOnPress: () {},
                        btnOk: PrimaryButton(
                          onPressed: () => exit(0), // launch app url
                          text: 'Mettre à jour',
                        )).show();
                  }*/
              else {
                context.go('/auth');
              }
            } else {
              await AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                title: 'Error',
                desc:
                    'Une erreur est survenue, veuillez réessayer ulterierement ou contacter le support si le problème persiste.',
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
    return const SplashScreenContent();
  }
}
