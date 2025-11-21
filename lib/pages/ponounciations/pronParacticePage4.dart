import 'package:edutainment/constants/screenssize.dart';
import 'package:edutainment/providers/pronounciationVM.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/appimages.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class PronParacticePage4 extends ConsumerStatefulWidget {
  const PronParacticePage4({super.key});

  @override
  ConsumerState<PronParacticePage4> createState() => _PronParacticePage4State();
}

class _PronParacticePage4State extends ConsumerState<PronParacticePage4> {
  @override
  Widget build(BuildContext context) {
    // Get data from provider instead of GoRouter extra
    var p = ref.watch(pronounciationVm);
    final selectedlabel = p.selectedLevel;
    final selectedCatg = p.selectedCategory;
    final selectedLesson = p.selectedLesson;
    final selectedLessonId = p.selectedLessonId;
    final selectedLessonIndex = p.selectedLessonIndex;

    return DefaultScaffold(
      currentPage: '/home/PronlevelsPage1/2/3/4',
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              // height: MediaQuery.of(context).size.height * 0.18,
              child: Column(
                children: [
                  CustomHeaderBar(
                    onBack: () async {
                      context.pop();
                    },
                    centerTitle: false,
                    title: 'Pronounciations'.toUpperCase(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue, width: 1),
                        ),
                        child: CupertinoListTile(
                          title: Text(
                            '${selectedCatg?.label ?? ''}',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: SizedBox(
                            width: 35,
                            child: Image.asset(
                              AppImages.playerlight,
                              width: 35,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CupertinoListTile(
                                title: Text(
                                  '${selectedLesson['title'] ?? ''}',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                trailing: SizedBox(
                                  width: 25,
                                  child: Image.asset(
                                    AppImages.check,
                                    width: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  const Text('1/8', style: TextStyle(color: Colors.white)),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Image.asset(AppImages.video2, width: Screen.width(context) * 0.8),
            SizedBox(height: Screen.height(context) * 0.08),
            const Text(
              'Hello? Can Any One Hear Me ?',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: Screen.height(context) * 0.08),

            InkWell(
              onTap: () {
                context.go(
                  '/home/PronlevelsPage1/2/3/4/5',
                  extra: {
                    'selectedlabel': selectedlabel,
                    'categoryId': selectedCatg?.id ?? '',
                    'score': 0,
                    'totalQuestions': 8,
                  },
                );
              },
              child: const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: Icon(Icons.voice_chat, color: Colors.black, size: 25),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
