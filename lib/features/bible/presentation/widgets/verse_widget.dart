import 'package:flutter/material.dart';
import 'package:meno/features/bible/domain/domain.dart';
import 'package:meno/features/bible/presentation/widgets/verse_options_modal.dart';
import 'package:meno_design_system/meno_design_system.dart';

class VerseWidget extends StatelessWidget {
  const VerseWidget({required this.verse, super.key});

  final Verse verse;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final reference = '${verse.book} ${verse.chapter}:${verse.verse}';

    return GestureDetector(
      onTap: () => VerseOptionsModal.show(context, verse),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: Corners.circle,
              color: colors.primaryContainer,
            ),
            child: MText(
              reference,
              style: textTheme.microMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Spaces.verticalMicro,
          MText(verse.text, style: textTheme.bodyRegular),
        ],
      ),
    );
  }
}
