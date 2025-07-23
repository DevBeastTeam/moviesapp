import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';

import '../../../widgets/header_bar/custom_header_bar.dart';

class MovieSuggetinosPage extends StatefulWidget {
  const MovieSuggetinosPage({super.key});

  @override
  State<MovieSuggetinosPage> createState() => _MovieSuggetinosPageState();
}

class _MovieSuggetinosPageState extends State<MovieSuggetinosPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      isShowDrawer: true,
      currentPage: '',
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: const Icon(Icons.close_rounded, color: Colors.black),
              title: const Text(
                'Previous Conversations',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 2, color: Colors.grey.shade700),
            ListTile(
              leading: const Icon(Icons.push_pin_outlined, color: Colors.black),
              title: const Text(
                'Pinned Conversations',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 2, color: Colors.grey.shade700),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.black),
              trailing: const Icon(
                Icons.delete_outline_outlined,
                color: Colors.black,
              ),
              title: const Text(
                'Can Your Recommended',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 2, color: Colors.grey.shade700),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.black),
              title: const Text(
                'My recent Grammers',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 2, color: Colors.grey.shade700),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {},
              label: const Text(
                'New Chat',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          CustomHeaderBar(
            onBack: () async {
              // Get.back();
              Navigator.pop(context);
            },
            centerTitle: false,
            title: 'Back',
          ),
          // const Drawer(),
          ////////////////////
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(color: Colors.blueGrey.shade50),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.83,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            icon: const Icon(
                              Icons.sort_outlined,
                              color: Colors.black,
                            ),
                            onPressed: (() {
                              Scaffold.of(context).openDrawer();
                            }),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.push_pin_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Users First Name',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hello What are you going to teach me ths weekend',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.robo,
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      const Text(
                        'COPILT',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hello What are you going to teach me ths weekend',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(AppImages.video1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
