import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/widgets/ui/primary_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../core/loader.dart';
import '../../theme/colors.dart';
import '../../utils/boxes.dart';
import '../../utils/utils.dart';
import '../start/start_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  final dynamic userData = userBox.get('data');

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'WELCOME TO',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: Theme.of(
                          context,
                        ).textTheme.titleMedium?.fontWeight!,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    margin: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // AssetsImage.defaultIcon.toImage(width: 50),
                        Image.asset(AppImages.playerlight, width: 50),
                        const VerticalDivider(
                          width: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          'E-DUTAINMENT',
                          style: TextStyle(
                            fontFamily: 'Football Attack',
                            color: Colors.white,
                            fontWeight: Theme.of(
                              context,
                            ).textTheme.titleLarge?.fontWeight!,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/forestgumpwave.gif'),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: const Text(
                          'Ready to develop your',
                          style: TextStyle(
                            color: ColorsPallet.blueAccent,
                            fontWeight: FontWeight.normal,
                            fontSize: 35,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: const Text(
                          'ENGLISH SKILLS ?',
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                      ),
                      const Divider(height: 50, color: Colors.transparent),
                      PrimaryButton(
                        onPressed: () async {
                          await saveSawEntryPage();

                          var hasAnswerEntryQuiz =
                              userData['answer_entry_quiz'] ?? false;
                          if (context.mounted) {
                            if (!hasAnswerEntryQuiz) {
                              Get.to(() => const StartPage());
                            } else {
                              await fetchAndRedirectHome(context);
                            }
                          }
                        },
                        text: 'Yes, I am ready!',
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
