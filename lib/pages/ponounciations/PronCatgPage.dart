import 'package:edutainment/widgets/emptyWIdget.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/pLevelCatgModel.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class PronCatgPage extends ConsumerStatefulWidget {
  const PronCatgPage({super.key});

  @override
  ConsumerState<PronCatgPage> createState() => _PronCatgPageState();
}

class _PronCatgPageState extends ConsumerState<PronCatgPage> {
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
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    // Get the extra data passed from GoRouter
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final selectedlabel = extra?['selectedlabel'] as String;
    List<String> allLevels = extra?['allLevels'] as List<String>;
    List<Category> categories = extra?['categories'] as List<Category>;

    return DefaultScaffold(
      currentPage: 'PronCatgPage',
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

            categories.isEmpty
                ? EmptyWidget()
                : Padding(
                    padding: const EdgeInsets.all(14),
                    child: ListView.builder(
                      itemCount: categories.length,
                      shrinkWrap: true,
                      controller: ScrollController(),
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var data = categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () {
                              // get data
                              // WidgetsBinding.instance.addPostFrameCallback((_) {
                              //   ref
                              //       .read(pronounciationVm)
                              //       .getPronBySelectedCatgOptionsByIdF(
                              //         context,
                              //         id: data.id,
                              //         loadingFor: "getPronBySelectedCatgOptionsByIdF",
                              //       );
                              // });

                              context.go(
                                "/home/PronlevelsPage/PronLevelsCatgSelectionPage",
                                extra: {
                                  "selectedlabel": selectedlabel,
                                  "allLevels": allLevels,
                                  "categories": categories,
                                  "selectedCatg": data,
                                },
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
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
                                      // "${data['title']}",
                                      data.label.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
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
          ],
        ),
      ),
    );
  }
}
