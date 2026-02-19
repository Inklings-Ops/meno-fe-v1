import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/bible/applications/applications.dart';
import 'package:meno/features/bible/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ScripturePicker extends StatelessWidget {
  const ScripturePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 56,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                _ScriptureReference(),
                Spaces.horizontalSmall,
                _ScriptureTranslation(),
              ],
            ),
          ),
          Spaces.horizontalSmall,
          _PreviousAndNextButtons(),
        ],
      ),
    );
  }
}

class _ScriptureReference extends WatchingWidget {
  const _ScriptureReference();

  @override
  Widget build(BuildContext context) {
    final reference = watchValue((BibleManager m) => m.reference);
    return _Chip(label: reference, onTap: () => BibleBooksModal.show(context));
  }
}

class _ScriptureTranslation extends WatchingWidget {
  const _ScriptureTranslation();

  @override
  Widget build(BuildContext context) {
    final translation = watchValue((BibleManager m) => m.translation);
    return _Chip(
      label: translation.toUpperCase(),
      onTap: () => BibleTranslationsModal.show(context),
    );
  }
}

class _PreviousAndNextButtons extends WatchingWidget {
  const _PreviousAndNextButtons();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final style = IconButton.styleFrom(backgroundColor: colors.outlineVariant2);

    // Watch both book + chapter so buttons enable/disable reactively.
    watchValue((BibleManager m) => m.book);
    watchValue((BibleManager m) => m.chapter);

    final manager = di<BibleManager>();

    return Row(
      children: [
        SizedBox.square(
          dimension: 32,
          child: IconButton.filled(
            icon: const Icon(MIcons.chevron_left),
            padding: EdgeInsets.zero,
            iconSize: 20,
            style: style,
            onPressed: manager.isFirstChapter ? null : manager.prevChapter.run,
          ),
        ),
        const SizedBox(width: 13),
        SizedBox.square(
          dimension: 32,
          child: IconButton.filled(
            icon: const Icon(MIcons.chevron_right),
            padding: EdgeInsets.zero,
            iconSize: 20,
            style: style,
            onPressed: manager.isLastChapter ? null : manager.nextChapter.run,
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colors.outlineVariant2,
          borderRadius: Corners.circle,
        ),
        child: MText(label, style: textTheme.captionMedium),
      ),
    );
  }
}
