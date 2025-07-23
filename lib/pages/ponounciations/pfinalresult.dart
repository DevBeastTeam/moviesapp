import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/appimages.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class PronounciationsFinalResultPage extends StatefulWidget {
  const PronounciationsFinalResultPage({super.key});

  @override
  State<PronounciationsFinalResultPage> createState() =>
      _PronounciationsFinalResultPageState();
}

class _PronounciationsFinalResultPageState
    extends State<PronounciationsFinalResultPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: '',
      child: Column(
        children: [
          SizedBox(
            // height: MediaQuery.of(context).size.height * 0.18,
            child: Column(
              children: [
                CustomHeaderBar(
                  onBack: () async {
                    // Get.back();
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
                      child: Image.asset(AppImages.playIcon, width: 35),
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
          const SizedBox(height: 30),
          const Text(
            'Final Result',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 50),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('8', style: TextStyle(color: Colors.blue)),
                      Text('QUESTIONS', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('775', style: TextStyle(color: Colors.blue)),
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
          const SizedBox(height: 100),
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
