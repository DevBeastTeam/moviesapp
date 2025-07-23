import 'package:edutainment/pages/ponounciations/pronoundetails.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/appimages.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class PeonounciationsPage extends StatefulWidget {
  const PeonounciationsPage({super.key});

  @override
  State<PeonounciationsPage> createState() => _PeonounciationsPageState();
}

class _PeonounciationsPageState extends State<PeonounciationsPage> {
  List catgList = [
    {'icon': AppImages.check, 'title': 'DAILY'},
    {'icon': AppImages.check, 'title': 'HISTORY'},
    {'icon': AppImages.uncheck, 'title': 'PRONOUNCE'},
    {'icon': AppImages.uncheck, 'title': 'BODY'},
    {'icon': AppImages.uncheck, 'title': 'NUMBERS'},
    {'icon': AppImages.uncheck, 'title': 'TIME'},
    {'icon': AppImages.uncheck, 'title': 'COLORS'},
    {'icon': AppImages.uncheck, 'title': 'BLABLA'},
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
                  title: 'Pronounciations'.toUpperCase(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PronounciationsDetailsPage(),
                ),
              );
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: ListView.builder(
                itemCount: 6,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: index >= 1 ? Colors.white : Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 50,
                      height: 40,
                      child: Center(
                        child: Text(
                          'A1',
                          style: TextStyle(
                            color: index >= 1 ? Colors.black : Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.87,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const CupertinoListTile(
                title: Text('Sports', style: TextStyle(color: Colors.black)),
                trailing: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: ListView.builder(
                itemCount: catgList.length,
                shrinkWrap: true,
                controller: ScrollController(),
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var data = catgList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PronounciationsDetailsPage(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CupertinoListTile(
                          title: Text(
                            data['title'],
                            style: const TextStyle(color: Colors.blue),
                          ),
                          leading: SizedBox(
                            width: 25,
                            child: Image.asset(data['icon'], width: 25),
                          ),
                          trailing: SizedBox(
                            width: 25,
                            child: Image.asset(AppImages.playIcon, width: 25),
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
