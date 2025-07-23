import 'package:edutainment/pages/ponounciations/pfinalresult.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/appimages.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class PronounciationsDetailsPage extends StatefulWidget {
  const PronounciationsDetailsPage({super.key});

  @override
  State<PronounciationsDetailsPage> createState() =>
      _PronounciationsDetailsPageState();
}

class _PronounciationsDetailsPageState
    extends State<PronounciationsDetailsPage> {
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PronounciationsFinalResultPage(),
                ),
              );
            },
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
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PronounciationsFinalResultPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                const Text('1/8', style: TextStyle(color: Colors.white)),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PronounciationsFinalResultPage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Image.asset(AppImages.video1),
          const SizedBox(height: 100),
          const Text(
            'Hello? Can Any One Hear Me ?',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 100),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PronounciationsFinalResultPage(),
                ),
              );
            },
            child: const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: Icon(Icons.voice_chat, color: Colors.black, size: 25),
            ),
          ),
        ],
      ),
    );
  }
}
