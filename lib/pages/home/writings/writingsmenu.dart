import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/pages/home/writings/moviesug.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/header_bar/custom_header_bar.dart';

class CopilotMenuPage extends StatefulWidget {
  const CopilotMenuPage({super.key});

  @override
  State<CopilotMenuPage> createState() => _CopilotMenuPageState();
}

class _CopilotMenuPageState extends State<CopilotMenuPage> {
  int flashcardsLeft =
      7; // Example number. You can dynamically load this later.

  List menuList = [
    {'icon': Icons.movie_creation_outlined, 'title': 'Movies Suggestions'},
    {'icon': Icons.bookmarks_sharp, 'title': 'Track My Progress'},
    {'icon': Icons.show_chart_sharp, 'title': 'Progress Charts'},
    {'icon': Icons.question_mark, 'title': 'Request Explanation'},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      isShowDrawer: true,
      currentPage: '/home/ai',
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
                'My Recent Grammar',
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
              onPressed: () {
                context.go('/home/ai/aichat');
              },
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
              if (context.mounted) {
                context.pop();
              }
            },
            centerTitle: false,
            title: 'Back',
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(color: Colors.blueGrey.shade50),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.83,
            child: Column(
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(
                            Icons.sort_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
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
                    // Right Icon Placeholder (customizable)
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {
                        // Action here
                      },
                    ),
                  ],
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.robo,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      const Text(
                        'COPILOT',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Flashcard Button with number (red background)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$flashcardsLeft Flashcards to Watch',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: GridView.builder(
                    shrinkWrap: true,
                    controller: ScrollController(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                    itemCount: menuList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = menuList[index];
                      return Padding(
                        padding: const EdgeInsets.all(14),
                        child: InkWell(
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MovieSuggetinosPage(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  data['icon'],
                                  color: Colors.blueAccent,
                                  size: 60,
                                ),
                                const Divider(),
                                Text(
                                  '${data['title']}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
