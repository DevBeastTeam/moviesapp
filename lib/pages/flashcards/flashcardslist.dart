import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/providers/flashCardsVM.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/header_bar/custom_header_bar.dart';

class FlashCardsListPage extends ConsumerStatefulWidget {
  const FlashCardsListPage({super.key});

  @override
  ConsumerState<FlashCardsListPage> createState() => FlashCardsListsPageState();
}

class FlashCardsListsPageState extends ConsumerState<FlashCardsListPage> {
  List<bool> openedCards = List.generate(10, (index) => false);
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(flashCardsVM);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return DefaultScaffold(
      currentPage: '/home/fc',
      child: Column(
        children: [
          Column(
            children: [
              CustomHeaderBar(
                onBack: () {
                  if (context.mounted) {
                    context.pop();
                  }
                },
                centerTitle: false,
                title: 'FLASHCARDS',
              ),
              const SizedBox(height: 20),
            ],
          ),

          SizedBox(
            height: 30,
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    onTap: () {
                      _pageController.jumpToPage(index);
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4,
                        ),
                        child: Center(
                          child: Text(
                            index == 0
                                ? 'ENTERTAINMENT'
                                : index == 1
                                ? 'PEDAGOGIAL VIDEOS'
                                : 'ENGLISH LEASSONS',
                            style: t.labelSmall,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: 11,
              onPageChanged: (index) {
                if (index < 10) {
                  setState(() {
                    openedCards[index] = true;
                  });
                }
              },
              itemBuilder: (context, index) {
                if (index == 10) {
                  return const Center(
                    child: Text(
                      'This is the last flashcard',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(14),
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.4,
                        image: AssetImage(AppImages.video1),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Terminator',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (openedCards[index])
                            SizedBox(
                              width: 25,
                              child: Image.asset(AppImages.check, width: 25),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
