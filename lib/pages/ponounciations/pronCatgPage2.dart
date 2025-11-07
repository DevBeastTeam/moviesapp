import 'package:edutainment/helpers/forstrings.dart';
import 'package:edutainment/widgets/emptyWIdget.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/screenssize.dart';
import '../../models/pLevelCatgModel.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class PronCatgPage2 extends ConsumerStatefulWidget {
  const PronCatgPage2({super.key});

  @override
  ConsumerState<PronCatgPage2> createState() => _PronCatgPage2State();
}

class _PronCatgPage2State extends ConsumerState<PronCatgPage2> {
  List catgList = [
    {'icon': '📚', 'title': 'Education', " subtitle": "Education"},
    {'icon': '✈️', 'title': 'Travel', " subtitle": "Education"},
    {'icon': '💼', 'title': 'Work', " subtitle": "Education"},
    {'icon': '🎭', 'title': 'Culture & Entetainment', " subtitle": "Education"},
    {'icon': '⚽', 'title': 'Sports', " subtitle": "Education"},
    {'icon': '🏠', 'title': 'Daily Life', " subtitle": "Education"},
    {'icon': '👥', 'title': 'Holidays', " subtitle": "Education"},
    {'icon': '🏥', 'title': 'Relatioins', " subtitle": "Education"},
  ];
  @override
  Widget build(BuildContext context) {
    // Get the extra data passed from GoRouter
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final selectedlabel = extra?['selectedlabel'] as String;
    List<String> allLevels = extra?['allLevels'] as List<String>;
    List<Category> categories = extra?['categories'] as List<Category>;

    return DefaultScaffold(
      currentPage: '/home/PronlevelsPage1/2',
      child: SingleChildScrollView(
        controller: ScrollController(),

        child: Column(
          children: [
            SizedBox(
              // height: MediaQuery.of(context).size.height * 0.18,
              child: Column(
                children: [
                  CustomHeaderBar(
                    onBack: () async {
                      context.pop();
                    },
                    centerTitle: false,
                    title: 'Select A Category'.toUpperCase(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            SizedBox(
              height: Screen.isTablet(context) && Screen.isLandscape(context)
                  ? Screen.height(context) * 0.15
                  : Screen.height(context) * 0.00,
            ),
            categories.isEmpty
                ? EmptyWidget()
                : Padding(
                    padding: const EdgeInsets.all(14),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: List.generate(categories.length, (index) {
                        var data = categories[index];
                        return InkWell(
                          onTap: () {
                            context.go(
                              "/home/PronlevelsPage1/2/3",
                              extra: {
                                "selectedlabel": selectedlabel,
                                "allLevels": allLevels,
                                "categories": categories,
                                "selectedCatg": data,
                              },
                            );
                          },
                          child: Container(
                            width:
                                Screen.isTablet(context) &&
                                    Screen.isPortrait(context)
                                ? Screen.width(context) * 0.7
                                : Screen.isTablet(context) &&
                                      Screen.isLandscape(context)
                                ? Screen.width(context) * 0.3
                                : null,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    data.icon,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    Screen.isTablet(context) &&
                                            Screen.isLandscape(context)
                                        ? subStringText(
                                            data.label.toString(),
                                            0,
                                            20,
                                          )
                                        : data.label.toUpperCase(),
                                    maxLines: 3,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
