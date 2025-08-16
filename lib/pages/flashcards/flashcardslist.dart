import 'package:edutainment/config/textTheme.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/models/flashCardsModel.dart';
import 'package:edutainment/providers/flashCardsVM.dart';
import 'package:edutainment/widgets/loaders/dotloader.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/toast.dart';
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
    syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(flashCardsVM).getFlashCards(context, loadingFor: "getflash");
    });
  }

  @override
  Widget build(BuildContext context) {
   var t =  Theme.of(context).textTheme;
    var p = ref.watch(flashCardsVM);

    return DefaultScaffold(
      currentPage: 'fc',
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



          p.loadingFor == "getflash"
              ? const Center(child: DotLoader())
              : p.flashCardsList.isEmpty
              ? Center(child: Text("Empty"))
              : SizedBox(
                  height: 30,
                  child: ListView.builder(
                    itemCount: p.flashCardsList.first.subjects.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      var flashSubject =  p.flashCardsList.first.subjects[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Opacity(
                          opacity:
                             flashSubject.enabled
                              ? 1
                              : 0.5,
                          child: InkWell(
                            onTap:
                                flashSubject.enabled
                                ? () {
                                  p.getFlashCardMoviesListById(
                                    context,
                                    id: flashSubject.id,
                                    loadingFor: "movies"
                                  );
                                  }
                                : () {
                                    showToast('This subject is not enabled');
                                  },
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4,
                                ),
                                child: Center(
                                  child: Text(
                                        flashSubject
                                        .label ?? "Empty",
                                    style: t.labelSmall!.copyWith(color: flashSubject.id == p.selectedSubject  ? Colors.blue : Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          const SizedBox(height: 20),

p.loadingFor == "getflash"? SizedBox.shrink():
           p.loadingFor == "movies" 
              ? const Center(child: DotLoader())
              : p.flashCardsList.isEmpty
              ? Center(child: Text("Movies Empty"))
              :
          ListView.builder(
            itemCount: p.flashCardsList.first.movies.length,
            shrinkWrap: true,
            controller: ScrollController(),
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return FlashCardsTileWidget(
                item: p.flashCardsList.first.movies[index],
                onTap: () {
                  showToast('Tapped');
                  p.getFlashCardMoviesListById(
                    context,
                    id: p.flashCardsList.first.movies[index].reference,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
          // Expanded(
          //   child: PageView.builder(
          //     controller: _pageController,
          //     itemCount: 11,
          //     onPageChanged: (index) {
          //       if (index < 10) {
          //         setState(() {
          //           openedCards[index] = true;
          //         });
          //       }
          //     },
          //     itemBuilder: (context, index) {
          //       if (index == 10) {
          //         return const Center(
          //           child: Text(
          //             'This is the last flashcard',
          //             style: TextStyle(
          //               fontSize: 20,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         );
          //       }
          //       return Padding(
          //         padding: const EdgeInsets.all(14),
          //         child: Container(
          //           decoration: const BoxDecoration(
          //             image: DecorationImage(
          //               opacity: 0.4,
          //               image: AssetImage(AppImages.video1),
          //               fit: BoxFit.cover,
          //             ),
          //             borderRadius: BorderRadius.all(Radius.circular(10)),
          //           ),
          //           child: Padding(
          //             padding: const EdgeInsets.all(15),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 const Text(
          //                   'Terminator',
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 20,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 if (openedCards[index])
          //                   SizedBox(
          //                     width: 25,
          //                     child: Image.asset(AppImages.check, width: 25),
          //                   ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class FlashCardsTileWidget extends StatelessWidget {
  final FlashCardsMovie item;
  final Function() onTap;
  bool isSelected = false;
  FlashCardsTileWidget({
    super.key,
    required this.item,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:  8, vertical: 3),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(item.picture), fit: BoxFit.cover, opacity: 0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(item.label),
          trailing: Image.asset(
            width: 30,
            isSelected ? AppImages.check : AppImages.uncheckradius,
          ),
      
          onTap: () {
            onTap();
          },
        ),
      ),
    );
  }
}
