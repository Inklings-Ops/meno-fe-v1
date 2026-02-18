import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/bible/applications/applications.dart';
import 'package:meno/features/bible/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ScripturePicker extends StatelessWidget {
  const ScripturePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: const Row(
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
          _PreviousAndNextButton(),
        ],
      ),
    );
  }
}

class _ScriptureTranslation extends WatchingWidget {
  const _ScriptureTranslation();

  @override
  Widget build(BuildContext context) {
    final translation = watchValue((BibleManager m) => m.translation);
    return _Container(
      content: translation.toUpperCase(),
      onTap: () => BibleTranslationsModal.show(context),
    );
  }
}

class _ScriptureReference extends WatchingWidget {
  const _ScriptureReference();

  @override
  Widget build(BuildContext context) {
    final reference = watchValue((BibleManager m) => m.reference);
    return _Container(
      content: reference,
      onTap: () => BibleBooksModal.show(context),
    );
  }
}

class _PreviousAndNextButton extends StatelessWidget {
  const _PreviousAndNextButton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final buttonStyle = IconButton.styleFrom(
      backgroundColor: colors.outlineVariant2,
    );

    final manager = di<BibleManager>();

    return Row(
      children: [
        SizedBox.square(
          dimension: 32,
          child: IconButton.filled(
            icon: const Icon(MIcons.chevron_left),
            padding: EdgeInsets.zero,
            iconSize: 20,
            style: buttonStyle,
            onPressed: !manager.isFirstChapter ? manager.prevChapter.run : null,
          ),
        ),
        const SizedBox(width: 13),
        SizedBox.square(
          dimension: 32,
          child: IconButton.filled(
            icon: const Icon(MIcons.chevron_right),
            padding: EdgeInsets.zero,
            iconSize: 20,
            style: buttonStyle,
            onPressed: !manager.isLastChapter ? manager.nextChapter.run : null,
          ),
        ),
      ],
    );
  }
}

class _Container extends StatelessWidget {
  const _Container({required this.content, required this.onTap});

  final String content;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        constraints: BoxConstraints.loose(const Size.fromHeight(32)),
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: Corners.circle,
          color: colors.outlineVariant2,
        ),
        child: MText(content, style: textTheme.captionMedium),
      ),
    );
  }
}
