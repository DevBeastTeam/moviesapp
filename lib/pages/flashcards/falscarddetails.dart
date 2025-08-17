import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/constants/toats.dart';
import 'package:edutainment/models/flashCardsModel.dart';
import 'package:edutainment/providers/flashCardsVM.dart';
import 'package:edutainment/widgets/loaders/dotloader.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/colors.dart';
import '../../widgets/flashcardslisttile.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class FlashCardDetailsPage extends ConsumerStatefulWidget {
  const FlashCardDetailsPage({super.key});

  @override
  ConsumerState<FlashCardDetailsPage> createState() =>
      FlashCardDetailsPageState();
}

class FlashCardDetailsPageState extends ConsumerState<FlashCardDetailsPage> {
  bool isPage2 = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // syncFirstF();
  }

  void syncFirstF() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   ref.read(flashCardsVM).getPronounciationF(context);
    //   ref.read(flashCardsVM).getPronounciationFSingleByIdF(context, id: 'k');
    // });
  }

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(flashCardsVM);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isTablet =
        mediaQuery.size.shortestSide >= 600; // Common tablet threshold

    // Access the extra data from GoRouterState
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    if (extra == null) {
      return const Scaffold(
        body: Center(child: Text("Should Pass Extra Data")),
      );
    }

    final movie =
        extra['movie']
            as FlashCardsMovie; // Replace `Movie` with your actual type
    final subjectId = extra['subjectId'] as String; // Adjust type accordingly

    return DefaultScaffold(
      currentPage: '/home/fc/fcdetails',
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomHeaderBar(
              onBack: () async {
                if (context.mounted) {
                  context.pop();
                }
              },
              centerTitle: false,
              title: 'FLASHCARDS DETAILS',
              trailing: (isTablet || isLandscape)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Expanded(
                        child: SizedBox(
                          height: h * 0.13,
                          width: w * 0.5,
                          child: ListView.builder(
                            itemCount: 6,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 5,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    p.getFlashCardDetailsByIds(
                                      context,
                                      movieId: movie.id,
                                      levelId: 'A${index + 1}'.toLowerCase(),
                                      loadingFor: 'details',
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          p.selectedLevel ==
                                              'A${index + 1}'.toLowerCase()
                                          ? Colors.blue
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.blue),
                                    ),
                                    height: 52,
                                    width: 52,
                                    child: Center(
                                      child: Text(
                                        'A${index + 1}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color:
                                              p.selectedLevel ==
                                                  'A${index + 1}'.toLowerCase()
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ),

            if(!isTablet && !isLandscape)
            const SizedBox(height: 20),

            // Divider(),
            // Text("${movie.id}, $subjectId'"),
            // Divider(),

            // 📸 Image + Levels side-by-side
            // ClipRRect(
            //         borderRadius: BorderRadius.circular(12),
            //         child: Image.asset(
            //           AppImages.video1,
            //           width: w * 0.4,
            //           height: h * 0.18,
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //       const SizedBox(width: 12),
            
            
          if(!isTablet && !isLandscape)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Expanded(
                child: SizedBox(
                  height: h * 0.07,
                  child: ListView.builder(
                    itemCount: 6,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 5,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            p.getFlashCardDetailsByIds(
                              context,
                              movieId: movie.id,
                              levelId: 'A${index + 1}'.toLowerCase(),
                              loadingFor: 'details',
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  p.selectedLevel ==
                                      'A${index + 1}'.toLowerCase()
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue),
                            ),
                            height: 52,
                            width: 52,
                            child: Center(
                              child: Text(
                                'A${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color:
                                      p.selectedLevel ==
                                          'A${index + 1}'.toLowerCase()
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            FlashCardsTileWidget(
              item: movie,
              isSelected: true,
              onTap: () {
                // showToast('Tapped');
              },
            ),

            const SizedBox(height: 20),

            // 📦 Flashcard Content Box
            p.loadingFor == "details"
                ? Center(child: Padding(
                  padding: EdgeInsets.symmetric(vertical:  h*0.3),
                  child: DotLoader(),
                ))
                : p.flashCardsDetailsList.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1,
                        bottom: MediaQuery.of(context).size.height * 0.1,
                      ),
                      child:
                          Text(
                                "Empty",
                                style: TextStyle(
                                  color: Colors.yellow.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )
                              .animate(
                                delay: 1000.ms,
                                onPlay: (controller) => controller.repeat(),
                              )
                              .shimmer(
                                duration: 2000.ms,
                                color: ColorsPallet.darkBlue,
                              ),
                    ),
                  )
                : Row(
                  mainAxisAlignment: (isTablet || isLandscape)? MainAxisAlignment.spaceBetween: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
 if(isTablet || isLandscape)
                    InkWell(
                  onTap: () {
                    isPage2 = false;
                    setState(() {});
                    // scrollController.jumpTo(100);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 10),
                      Text('SWIPE \nRIGHT: NEXT'),
                    ],
                  ),
                ),
                    Container(
                        height: (isTablet || isLandscape)? h* 0.7:  h * 0.45,
                        width: (isTablet || isLandscape)? w*0.6 : w * 0.9,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.deepOrangeAccent],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              // scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child:
                                    //
                                    p
                                                .flashCardsDetailsList
                                                .first
                                                .movie
                                                .description
                                                .length >
                                            200 &&
                                        //
                                        isPage2
                                    ? CachedNetworkImage(
                                        imageUrl: p
                                            .flashCardsDetailsList
                                            .first
                                            .movie
                                            .picture,
                                        progressIndicatorBuilder:
                                            (context, url, progress) => DotLoader(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(AppImages.noimg),
                                      )
                                    : Column(
                                        children: [
                                          Text(
                                            p
                                                .flashCardsDetailsList
                                                .first
                                                .movie
                                                .label,
                                            style: t.titleMedium!.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            p
                                                .flashCardsDetailsList
                                                .first
                                                .movie
                                                .description,
                                            textAlign: TextAlign.center,
                                            style: t.labelMedium!.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          CachedNetworkImage(
                                            imageUrl: p
                                                .flashCardsDetailsList
                                                .first
                                                .movie
                                                .picture,
                                            progressIndicatorBuilder:
                                                (context, url, progress) =>
                                                    DotLoader(),
                                            errorWidget: (context, url, error) =>
                                                Image.asset(AppImages.noimg),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
 if(isTablet || isLandscape)
                      InkWell(
                  onTap: () {
                    if (p.flashCardsDetailsList.first.movie.description.length <
                        200) {
                      toast(context, msg: "maximum Content Reached");
                    }
                    debugPrint("clicked");
                    isPage2 = true;
                    setState(() {});
                    //  scrollController.jumpTo(10);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('SWIPE LEFT: \nPREVIOUS'),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
                  ],
                ),

            const SizedBox(height: 20),

            // 🔁 Swipe Instructions
          if(!isTablet && !isLandscape)
            Column(
              children: [
                InkWell(
                  onTap: () {
                    isPage2 = false;
                    setState(() {});
                    // scrollController.jumpTo(100);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 10),
                      Text('SWIPE RIGHT: NEXT'),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    if (p.flashCardsDetailsList.first.movie.description.length <
                        200) {
                      toast(context, msg: "maximum Content Reached");
                    }
                    debugPrint("clicked");
                    isPage2 = true;
                    setState(() {});
                    //  scrollController.jumpTo(10);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('SWIPE LEFT: PREVIOUS'),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
