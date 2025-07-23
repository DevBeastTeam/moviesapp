import 'package:edutainment/pages/ponounciations/pronounciationspage.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';

import '../../widgets/header_bar/custom_header_bar.dart';

class PSelectCatgPage extends StatefulWidget {
  const PSelectCatgPage({super.key});

  @override
  State<PSelectCatgPage> createState() => _PSelectCatgPageState();
}

class _PSelectCatgPageState extends State<PSelectCatgPage> {
  List catgList = [
    {'icon': '📚', 'title': 'Education'},
    {'icon': '✈️', 'title': 'Travel'},
    {'icon': '💼', 'title': 'Work'},
    {'icon': '🎭', 'title': 'Culture & Entetainment'},
    {'icon': '⚽', 'title': 'Sports'},
    {'icon': '🏠', 'title': 'Daily Life'},
    {'icon': '👥', 'title': 'Holidays'},
    {'icon': '🏥', 'title': 'Relatioins'},
  ];
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
                  title: 'Select A Category'.toUpperCase(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.82,
              child: ListView.builder(
                itemCount: catgList.length,
                shrinkWrap: true,
                controller: ScrollController(),
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var data = catgList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PeonounciationsPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${data['icon']}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "${data['title']}",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
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
    );
  }
}
