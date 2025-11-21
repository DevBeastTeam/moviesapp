import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/appimages.dart';
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue, width: 1),
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
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        '$totalQuestions',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Text('QUESTIONS', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('$score', style: TextStyle(color: Colors.blue)),
                      Text(
                        'AVERAGE SCORE',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.8,
              child: Wrap(
                children: List.generate(
                  8,
                  (index) => Container(
                    margin: const EdgeInsets.all(7),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: index == 7
                          ? const Color.fromARGB(255, 212, 83, 73)
                          : const Color.fromARGB(255, 34, 205, 122),
                      borderRadius: BorderRadius.circular(10),
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
