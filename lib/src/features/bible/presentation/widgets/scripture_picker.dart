import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import 'book_widget.dart';
import 'translation_widget.dart';

class ScripturePicker extends StatelessWidget {
  const ScripturePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return Container(
      height: 56,
      padding: const EdgeInsets.only(top: MCore.large, bottom: MCore.small),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildContainer(
                  colorScheme: colorScheme,
                  content: "1 Thessalonians 1:13",
                  onTap: () => context.showModal(
                    const BibleBooksModal(),
                    isScrollControlled: true,
                  ),
                ),
                MCore.small.horizontalSpace,
                _buildContainer(
                  colorScheme: colorScheme,
                  content: "NLT",
                  onTap: () => context.showModal(
                    const BibleTranslationsModal(),
                    isScrollControlled: true,
                  ),
                ),
              ],
            ),
          ),
          MCore.small.horizontalSpace,
          Row(
            children: [
              MIconButton(
                icon: const Icon(MIcons.chevron_left),
                isFilled: true,
                fillColor: colorScheme.outlineVariant2,
                size: 32,
              ),
              const SizedBox(width: 13),
              MIconButton(
                icon: const Icon(MIcons.chevron_right),
                isFilled: true,
                fillColor: colorScheme.outlineVariant2,
                size: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContainer({
    required MColorScheme colorScheme,
    required String content,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MCore.circle),
          color: colorScheme.outlineVariant2,
        ),
        child: MText(content, style: MTextStyle.captionMedium),
      ),
    );
  }
}

class BibleBooksModal extends StatelessWidget {
  const BibleBooksModal({super.key});

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: "Bible Books",
      builder: (context) => ListView(
        children: const [
          BookWidget(bookName: "Genesis"),
        ],
      ),
    );
  }
}

class BibleTranslationsModal extends StatelessWidget {
  const BibleTranslationsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: "Bible Translations",
      builder: (context) => ListView(
        children: const [
          TranslationWidget(name: "NLT"),
        ],
      ),
    );
  }
}
