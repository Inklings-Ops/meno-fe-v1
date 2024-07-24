import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'chapter_widget.dart';

class ChaptersGrid extends StatelessWidget {
  const ChaptersGrid({super.key, required this.chapterLength});

  final int chapterLength;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: $styles.insets.large),
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chapterLength,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: $styles.insets.medium,
        mainAxisSpacing: $styles.insets.medium,
      ),
      itemBuilder: (context, index) => ChapterWidget(chapter: index + 1),
    );
  }
}
