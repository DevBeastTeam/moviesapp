import 'package:edutainment/theme/colors.dart';
import 'package:edutainment/widgets/card_3d.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/appimages.dart';
import '../../constants/screenssize.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class PronResultsPage5 extends StatefulWidget {
  const PronResultsPage5({super.key});

  @override
  State<PronResultsPage5> createState() => _PronResultsPage5State();
}

class _PronResultsPage5State extends State<PronResultsPage5> {
  @override
  Widget build(BuildContext context) {
    // Get the extra data passed from GoRouter
    final extra = Get.arguments as Map<String, dynamic>?;
    final selectedlabel = extra?['selectedlabel'] as String?;
    final categoryId = extra?['categoryId'] as String?;
    final score = extra?['score'] as int? ?? 0;
    final totalQuestions = extra?['totalQuestions'] as int? ?? 8;

    return DefaultScaffold(
      currentPage: '/home/PronlevelsPage1/2/3/4/5',
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Column(
                children: [
                  CustomHeaderBar(
                    onBack: () {
                      Navigator.pop(context);
                    },
                    centerTitle: false,
                    title: 'Pronounciations'.toUpperCase(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card3D(
                    borderRadius: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // border: Border.all(color: Colors.blue, width: 1),
                      ),
                      child: CupertinoListTile(
                        title: const Text(
                          'CATEGORY',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: SizedBox(
                          width: 35,
                          child: Image.asset(AppImages.playerlight, width: 35),
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
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: CupertinoListTile(
                            title: const Text(
                              'Lessons',
                              style: TextStyle(color: Colors.blue),
                            ),
                            trailing: SizedBox(
                              width: 25,
                              child: Image.asset(AppImages.check, width: 25),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Final Result',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(color: ColorsPallet.darkBlue),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$totalQuestions',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'QUESTIONS',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('$score', style: TextStyle(color: Colors.white)),
                        Text(
                          'AVERAGE SCORE',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // child: Wrap(
                //   alignment: WrapAlignment.center,
                //   children: List.generate(
                //     8,
                //     (index) => Container(
                //       margin: const EdgeInsets.all(7),
                //       width: 70,
                //       height: 70,
                //       decoration: BoxDecoration(
                //         color: index == 7
                //             ? const Color.fromARGB(255, 213, 92, 84)
                //             : const Color.fromARGB(255, 80, 142, 97),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: Center(
                //         child: Text(
                //           '${index + 1}',
                //           style: const TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Screen.isPhone(context)
                        ? 25
                        : Screen.width(context) * 0.2,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: Screen.isPhone(context) ? 10 : 20,
                      mainAxisSpacing: Screen.isPhone(context) ? 10 : 20,
                    ),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: index == 7
                              ? const Color.fromARGB(255, 213, 92, 84)
                              : const Color.fromARGB(255, 80, 142, 97),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
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
          ],
        ),
      ),
    );
  }
}
