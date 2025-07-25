import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/providers/flashCardsVM.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/header_bar/custom_header_bar.dart';

class FlashCardDetailsPage extends ConsumerStatefulWidget {
  const FlashCardDetailsPage({super.key});

  @override
  ConsumerState<FlashCardDetailsPage> createState() =>
      FlashCardDetailsPageState();
}

class FlashCardDetailsPageState extends ConsumerState<FlashCardDetailsPage> {
  @override
  void initState() {
    super.initState();
    // syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(flashCardsVM).getPronounciationF(context);
      ref.read(flashCardsVM).getPronounciationFSingleByIdF(context, id: 'k');
    });
  }

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(flashCardsVM);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
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
            ),
            const SizedBox(height: 20),

            // 📸 Image + Levels side-by-side
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      AppImages.video1,
                      width: w * 0.4,
                      height: h * 0.18,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: h * 0.18,
                      child: ListView.builder(
                        itemCount: 6,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: index >= 1 ? Colors.white : Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue),
                              ),
                              height: 35,
                              child: Center(
                                child: Text(
                                  'A${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: index >= 1
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📝 Title and Check Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Terminator',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Image.asset(AppImages.check, width: 30),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📦 Flashcard Content Box
            Container(
              height: h * 0.45,
              width: w * 0.9,
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    child: Column(
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            children: [
                              Text(
                                'vjk',
                                style: t.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'One Of The Best Players OF the World has Ever Seen',
                                textAlign: TextAlign.center,
                                style: t.labelMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔁 Swipe Instructions
            const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back),
                    SizedBox(width: 10),
                    Text('SWIPE RIGHT: NEXT'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('SWIPE LEFT: PREVIOUS'),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward),
                  ],
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
