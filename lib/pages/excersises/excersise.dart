import 'package:edutainment/providers/exercisesVm.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/header_bar/custom_header_bar.dart';
import '../../widgets/loaders/dotloader.dart';
import 'exlessons.dart';

class ExcerisisePage extends ConsumerStatefulWidget {
  const ExcerisisePage({super.key});

  @override
  ConsumerState<ExcerisisePage> createState() => _ExcerisisePageState();
}

class _ExcerisisePageState extends ConsumerState<ExcerisisePage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(excerVm).getExcerF(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(excerVm);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return DefaultScaffold(
      currentPage: '',
      child: Column(
        children: [
          CustomHeaderBar(
            onBack: () async {
              // context.pop();
              // Get.back();
              Navigator.pop(context);
            },
            centerTitle: false,
            title: 'Levels',
          ),
          ///////////////
          const Text('LEVELS', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 50),
          p.isLoading
              ? Padding(
                  padding: EdgeInsets.only(top: h * 0.35),
                  child: const Center(child: DotLoader()),
                )
              : p.excersiseList.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: h * 0.35),
                  child: Center(
                    child: Text(
                      'Empty',
                      style: t.titleMedium!.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                )
              : Wrap(
                  runSpacing: 15,
                  spacing: 15,
                  children: List.generate(
                    p.excersiseList.first.allowedLessonCategory.length,
                    (index) {
                      var data =
                          p.excersiseList.first.allowedLessonCategory[index];
                      return InkWell(
                        onTap: () {
                          // p.getExcerSingleByIdF(context, id: data.id);
                          // p.getExcerSingleByIdF(context, id: '1');
                          // p.getExcerSingleByIdF(context, id: 1);
                          // p.getExcerSingleByIdF(context, id: 'a');
                          // p.getExcerSingleByIdF(context, id: 'a1');
                          // p.getExcerSingleByIdF(context,
                          //     id: '63f0ba7fe75faea17ab6c557');
                          // p.getExcerSingleByIdF(context,
                          //     id: '650b12aca0220be99027bd4d');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExcersiseLessonsPage(
                                labelTitle: data.label,
                                lableOptionsList: p.excersiseList.first.tags,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                gradient: LinearGradient(
                                  colors:
                                      index >= 0 &&
                                          p
                                                  .excersiseList
                                                  .first
                                                  .userLevel
                                                  .index <
                                              index
                                      ? [
                                          Colors.orangeAccent.withOpacity(0.5),
                                          Colors.deepOrange.withOpacity(0.5),
                                        ]
                                      : [
                                          Colors.orangeAccent,
                                          Colors.deepOrange,
                                        ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Center(
                                  child: Text(
                                    data.label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            index >= 0 &&
                                    p.excersiseList.first.userLevel.index <
                                        index
                                ? const Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.lock_clock),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),




     ],
      ),
    );
  }
}
