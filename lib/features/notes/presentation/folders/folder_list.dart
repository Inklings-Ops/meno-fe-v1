import 'package:flutter/material.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class FolderList extends StatelessWidget {
  const FolderList({
    required this.folders,
    this.padding,
    super.key,
    this.onOptionsTap,
    this.onTap,
    this.selectedFolder,
  });

  final List<NoteFolder?> folders;
  final EdgeInsetsGeometry? padding;
  final void Function(NoteFolder)? onTap;
  final void Function(NoteFolder)? onOptionsTap;
  final NoteFolder? selectedFolder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: folders.length,
      separatorBuilder: (context, index) => Spaces.verticalLarge,
      itemBuilder: (ctx, index) {
        final folder = folders[index]!;
        return FolderCard(
          folder: folder,
          onTap: () => onTap?.call(folder),
          onOptionsTap: () => onOptionsTap?.call(folder),
          isSelected: selectedFolder?.id == folder.id,
        );
      },
    );
  }
}
