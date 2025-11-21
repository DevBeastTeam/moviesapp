import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/grammer_controller.dart';
import '../../../widgets/ui/default_scaffold.dart';

class GrammarPage extends StatefulWidget {
  const GrammarPage({super.key});

  @override
  State<StatefulWidget> createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage> {
  @override
  Widget build(BuildContext context) {
    final grammerCtrl = Get.find<GrammerController>();
    grammerCtrl.getGrammersF(context);

    return DefaultScaffold(
      // appBar: AppBar(),
      currentPage: '',
      child: Column(
        children: [
          Obx(() => Text('👉 ${grammerCtrl.grammersList.toString()}')),
        ],
      ),
    );
  }
}
