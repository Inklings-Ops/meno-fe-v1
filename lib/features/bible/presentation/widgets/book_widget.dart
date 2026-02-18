import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/bible/applications/bible_manager.dart';
import 'package:meno/features/bible/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BookWidget extends WatchingWidget {
  const BookWidget({required this.bookName, super.key, this.onTap});

  final String bookName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    const borderRadius = Corners.sm;

    final manager = di<BibleManager>();
    final isSelected = manager.currentBookName == bookName;

    return ExpansionTile(
      title: MText(bookName),
      backgroundColor: colors.outlineVariant2,
      collapsedBackgroundColor: colors.outlineVariant2,
      shape: const RoundedSuperellipseBorder(
        borderRadius: BorderRadiusGeometry.all(.circular(Insets.sm)),
      ),
      collapsedShape: const RoundedSuperellipseBorder(
        borderRadius: BorderRadiusGeometry.all(.circular(Insets.sm)),
      ),
      children: [ChaptersGrid()],
    );
    // return Column(
    //   children: [
    //     InkWell(
    //       borderRadius: borderRadius,
    //       onTap: () => onTap?.call(),
    //       child: Container(
    //         height: 56,
    //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    //         decoration: BoxDecoration(
    //           color: colors.outlineVariant2,
    //           borderRadius: borderRadius,
    //         ),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [MText(bookName), const Icon(MIcons.plus, size: 20)],
    //         ),
    //       ),
    //     ),
    //     Visibility(
    //       visible: isSelected,
    //       child: const ChaptersGrid(),
    //     ),
    //   ],
    // );
  }
}
