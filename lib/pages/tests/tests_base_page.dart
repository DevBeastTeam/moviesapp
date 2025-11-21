import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_widgets/widgets/tiktok.dart';

import '../../controllers/quiz_controller.dart';
import '../../theme/colors.dart';
import '../../widgets/ui/default_scaffold.dart';
import 'tests_list_component.dart';

class TestsBasePage extends StatefulWidget {
  const TestsBasePage({super.key});

  @override
  State<TestsBasePage> createState() => _TestsBasePageState();
}

class _TestsBasePageState extends State<TestsBasePage>
    with TickerProviderStateMixin {
  final QuizController quizController = Get.find();
  final tabs = ['Training', 'Exam'];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      initialIndex: quizController.selectedType.value == 'training' ? 0 : 1,
      vsync: this,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Handle tab change if needed, though usually onTap does it
      }
    });
  }

  void _onTabChanged(int index) {
    final type = index == 0 ? 'training' : 'exam';
    quizController.selectedType.value = type;
    if (quizController.selectedCategory.value != null) {
      quizController.fetchQuizzesByCategory(
        quizController.selectedCategory.value!.id,
        type,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: 'tests/base',
      hideBottomBar: true,
      child: Obx(() {
        final category = quizController.selectedCategory.value;
        final type = quizController.selectedType.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (quizController.isLoading.value) QuickTikTokLoader(),
            AppBar(
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("TEST", style: TextStyle(fontSize: 17)),
                  Text(
                    '${category?.label ?? ''} - $type',
                    style: const TextStyle(fontSize: 17),
                  ),
                  const Text(""),
                  const Text(""),
                ],
              ),
              elevation: 0,
              backgroundColor: ColorsPallet.darkBlue,
            ),
            TabBar(
              indicatorColor: ColorsPallet.orangeA031,
              indicatorWeight: 4,
              controller: _tabController,
              onTap: _onTabChanged,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: tabs.map((e) => Tab(text: e)).toList(),
            ),
            if (!quizController.isLoading.value)
              const Expanded(child: TestsListComponent()),
            // else
            //   QuickTikTokLoader()
          ],
        );
      }),
    );
  }
}
