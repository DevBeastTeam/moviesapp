import 'package:edutainment/widgets/ui/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/loader.dart';
import '../../theme/colors.dart';
import '../../utils/assets/assets_images.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.bottomLeft,
            colors: ColorsPallet.bdb,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: const Text(
                          'What is your level ?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Divider(height: 50, color: Colors.transparent),
                      AssetsImage.levelsGif.toImage(width: 150),
                      const Divider(height: 50, color: Colors.transparent),
                      const Text(
                        'The position test is waiting for you',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(height: 50, color: Colors.transparent),
                      PrimaryButton(
                        onPressed: () async {
                          await fetchEntryQuiz();
                          if (context.mounted) {
                            context.go('/entry-quiz');
                          }
                        },
                        text: 'LET\'S GO !',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
