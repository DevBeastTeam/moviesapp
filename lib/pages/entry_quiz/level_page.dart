import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutainment/utils/boxes.dart';
import 'package:edutainment/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/colors.dart';
import '../../widgets/ui/primary_button.dart';

class EntryQuizLevelPage extends StatefulWidget {
  const EntryQuizLevelPage({super.key});

  @override
  State<EntryQuizLevelPage> createState() => _EntryQuizLevelPage();
}

class _EntryQuizLevelPage extends State<EntryQuizLevelPage> {
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
                          'Congratulations',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: const Text(
                          'your estimated level is',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Divider(height: 50, color: Colors.transparent),
                      CachedNetworkImage(
                        imageUrl: getIn(userData, 'Level.picture', null),
                        width: 200,
                      ),
                      const Divider(height: 50, color: Colors.transparent),
                      Text(
                        getIn(userData, 'Level.label', ''),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 25, color: Colors.transparent),
                      PrimaryButton(
                        onPressed: () async {
                          if (context.mounted) {
                            context.go('/entry-quiz-results');
                          }
                        },
                        text: 'Show my results',
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
