import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/bible/applications/bible_manager.dart';
import 'package:meno/features/bible/presentation/widgets/chapter_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ChaptersGrid extends WatchingWidget {
  const ChaptersGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<BibleManager>();
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: Insets.lg),
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: manager.chapterCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: Insets.md,
        mainAxisSpacing: Insets.md,
      ),
      itemBuilder: (context, index) => ChapterWidget(chapter: index + 1),
    );
  }
}
