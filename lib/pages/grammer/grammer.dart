import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'grammerData.dart';
import '../../widgets/header_bar/custom_header_bar.dart';

class GrammerPage extends ConsumerStatefulWidget {
  const GrammerPage({super.key});

  @override
  ConsumerState<GrammerPage> createState() => GrammerPageState();
}

class GrammerPageState extends ConsumerState<GrammerPage> {
  @override
  void initState() {
    super.initState();
    syncFirstF();
  }

  void syncFirstF() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(grammerData).getGrammersF(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var p = ref.watch(grammerData);
    var t = Theme.of(context).textTheme;
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return DefaultScaffold(
      currentPage: '',
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        controller: ScrollController(),
        child: Column(
          children: [
            CustomHeaderBar(
              onBack: () async {
                Navigator.pop(context);
              },
              centerTitle: false,
              title: 'Lessons',
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'SELECT YOUR LEVEL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildLevelBox("A1"),
                  buildLevelBox("A2"),
                  buildLevelBox("B1"),
                  buildLevelBox("B2"),
                  buildLevelBox("C1"),
                  buildLevelBox("C2"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLevelBox(String level) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Center(
          child: Text(
            level,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              'Select this level',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
          // Level tapped, add logic here if needed
          print('Selected level: $level');
        },
      ),
    );
  }
}
