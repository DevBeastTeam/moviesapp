import 'package:edutainment/pages/ponounciations/pselectcatg.dart';
import 'package:edutainment/providers/pronounciationVM.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/header_bar/custom_header_bar.dart';
import '../../widgets/loaders/dotloader.dart';

class PlevelsPage extends ConsumerStatefulWidget {
  const PlevelsPage({super.key});

  @override
  ConsumerState<PlevelsPage> createState() => _PlevelsPageState();
}

class _PlevelsPageState extends ConsumerState<PlevelsPage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(pronounciationVm).getPronounciationF(context);
      // ref
      //         .read(pronounciationVm)
      //         .getPronounciationFSingleByIdF(context, id: 'k');
    });
  }

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(pronounciationVm);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
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
                  title: 'Select Youruytre Levels'.toUpperCase(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          p.isLoading
              ? Padding(
                  padding: EdgeInsets.only(top: h * 0.35),
                  child: const Center(child: DotLoader()),
                )
              : p.pronounciationList.isEmpty
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
              : Padding(
                  padding: const EdgeInsets.all(14),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.82,
                    child: ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      controller: ScrollController(),
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PSelectCatgPage(),
                                ),
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
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'A1',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'select The Level',
                                      style: TextStyle(color: Colors.black),
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
