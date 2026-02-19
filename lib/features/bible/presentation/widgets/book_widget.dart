import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/bible/applications/applications.dart';
import 'package:meno/features/bible/domain/domain.dart';
import 'package:meno/features/bible/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// Renders a single book row.
///
/// Expansion is driven by [BibleManager.book], so only one book is ever
/// expanded at a time and state never diverges from the source of truth.
class BookWidget extends WatchingWidget {
  const BookWidget({required this.bookName, super.key, this.onChapterSelected});

  final String bookName;

  /// Called after the user selects a chapter — the modal uses this to
  /// re-scroll so the expanded grid stays in view.
  final VoidCallback? onChapterSelected;

  @override
  Widget build(BuildContext context) {
    final manager = di<BibleManager>();

    // Watch book index — rebuilds whenever the user picks a new book.
    final currentBookIdx = watchValue((BibleManager m) => m.book);
    final isExpanded = manager.bookName(currentBookIdx) == bookName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _BookRow(
          bookName: bookName,
          isExpanded: isExpanded,
          onTap: () {
            if (isExpanded) return; // already open — nothing to do
            final names = manager.bookNames;
            final idx = names.indexOf(bookName);
            if (idx == -1) return;
            manager.getVerses.run(
              BibleParams(
                book: idx,
                chapter: 1,
                translation: manager.translation.value,
              ),
            );
          },
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: isExpanded
              ? ChaptersGrid(onChapterSelected: onChapterSelected)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _BookRow extends StatelessWidget {
  const _BookRow({
    required this.bookName,
    required this.isExpanded,
    required this.onTap,
  });

  final String bookName;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return InkWell(
      borderRadius: Corners.sm,
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: isExpanded ? colors.primaryContainer : colors.outlineVariant2,
          borderRadius: Corners.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MText(
              bookName,
              style: isExpanded ? textTheme.bodyMedium : textTheme.bodyRegular,
              color: isExpanded ? colors.primary : null,
            ),
            AnimatedRotation(
              turns: isExpanded ? 0.125 : 0, // 45° when open
              duration: const Duration(milliseconds: 200),
              child: Icon(
                MIcons.plus,
                size: 20,
                color: isExpanded ? colors.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
