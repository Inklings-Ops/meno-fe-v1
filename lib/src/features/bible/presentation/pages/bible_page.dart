import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../widgets/scripture_picker.dart';
import '../widgets/verse_widget.dart';

class BiblePage extends StatelessWidget {
  const BiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.secondary(title: 'Bible', centerTitle: true),
      body: Column(
        children: [
          const ScripturePicker(),
          const MDivider(bottomSpace: 16),
          Expanded(
            child: ListView(
              children: const [
                VerseWidget(),
                VerseWidget(),
                VerseWidget(),
                VerseWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
