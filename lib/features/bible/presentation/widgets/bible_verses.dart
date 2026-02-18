import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/bible/applications/applications.dart';
import 'package:meno/features/bible/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BibleVerses extends WatchingWidget {
  const BibleVerses({super.key});

  @override
  Widget build(BuildContext context) {
    final verses = watchValue((BibleManager m) => m.verses);

    return ListView.separated(
      itemCount: verses.length,
      separatorBuilder: (context, i) => Spaces.verticalMedium,
      itemBuilder: (context, i) => VerseWidget(verse: verses[i]),
    );
  }
}
