import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../widgets/bible_verses.dart';
import '../widgets/scripture_picker.dart';

class BiblePage extends StatelessWidget {
  const BiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.secondary(title: 'Bible', centerTitle: true),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          ScripturePicker(),
          MDivider(bottomSpace: 16),
          Expanded(child: BibleVerses()),
        ],
      ),
    );
  }
}
