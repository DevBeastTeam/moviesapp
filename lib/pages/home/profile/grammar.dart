import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../grammer/grammerData.dart';
import '../../../widgets/ui/default_scaffold.dart';

class GrammarPage extends ConsumerStatefulWidget {
  const GrammarPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GrammarPageState();
}

class _GrammarPageState extends ConsumerState<GrammarPage> {
  @override
  Widget build(BuildContext context) {
    ref.read(grammerData).getGrammersF(context);

    return DefaultScaffold(
      // appBar: AppBar(),
      currentPage: '',
      child: Column(
        children: [
          Text('👉 ${ref.watch(grammerData).grammersList.toString()}'),
        ],
      ),
    );
  }
}
