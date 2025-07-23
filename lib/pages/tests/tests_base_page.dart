import 'package:edutainment/core/loader.dart';
import 'package:edutainment/pages/tests/tests_list_component.dart';
import 'package:edutainment/theme/colors.dart';
import 'package:edutainment/utils/boxes.dart';
import 'package:edutainment/utils/utils.dart';
import 'package:edutainment/widgets/ui/default_scaffold.dart';
import 'package:flutter/material.dart';

class TestsBasePage extends StatefulWidget {
  const TestsBasePage({super.key});

  @override
  State<TestsBasePage> createState() => _TestsBasePageState();
}

class _TestsBasePageState extends State<TestsBasePage>
    with TickerProviderStateMixin {
  final tabs = ['Training', 'Exam'];

  final dynamic quizCategory = quizBox.get('quizCategory');
  final dynamic quizType = quizBox.get('type');

  int activeTab = 0;

  late TabController _tabController;

  bool _loading = false;

  void fetchNewData() async {
    setState(() {
      _loading = true;
    });
    await fetchQuizz(
      quizCategory['_id'],
      activeTab == 0 ? 'training' : 'examination',
    );
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      initialIndex: activeTab,
      vsync: this,
    );
    _tabController.addListener(() {
      if (activeTab != _tabController.index) {
        activeTab = _tabController.index;
        fetchNewData();
      }
      print(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      currentPage: 'tests/base',
      hideBottomBar: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            centerTitle: true,
            title: Text(
              '${getIn(quizCategory, 'label')} - $quizType',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            backgroundColor: ColorsPallet.darkBlue,
          ),
          TabBar(
            indicatorColor: ColorsPallet.blueComponent,
            indicatorWeight: 4,
            controller: _tabController,
            onTap: (int tab) {
              print(tab);
            },
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),
          if (!_loading)
            const Expanded(child: TestsListComponent())
          else
            const Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}
