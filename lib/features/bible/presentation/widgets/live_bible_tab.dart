import 'package:flutter/material.dart';
import 'package:meno/features/bible/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveBibleTab extends StatelessWidget {
  const LiveBibleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScripturePicker(),
          MDivider(bottomSpace: 16),
          Expanded(child: BibleVerses()),
        ],
      ),
    );
  }
}
