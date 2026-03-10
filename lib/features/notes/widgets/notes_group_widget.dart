import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/manager/notes_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NotesGroupWidget extends StatelessWidget {
  const NotesGroupWidget({super.key, this.onTap, this.selected = false});

  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    final background = selected ? colors.primary : colors.inActiveContainer;
    final foreground = selected ? colors.onPrimary : colors.onInActiveContainer;

    return RawMaterialButton(
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 88,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MText('Notes', style: textTheme.captionMedium, color: foreground),
            _ValueWidget(color: foreground),
          ],
        ),
      ),
    );
  }
}

class _ValueWidget extends WatchingWidget {
  const _ValueWidget({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    final count = watchValue((NotesManager m) => m.totalNotesCount);
    return MText(
      count.toString(),
      style: textTheme.heading2Medium,
      color: color,
    );
  }
}
