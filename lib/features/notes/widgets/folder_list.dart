import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/manager/folders_manager.dart';
import 'package:meno/features/notes/model/entities/note_folder.dart';
import 'package:meno/features/notes/widgets/folder_card.dart';
import 'package:meno_design_system/meno_design_system.dart';

class FolderList extends StatelessWidget {
  const FolderList({
    required this.folders,
    this.padding,
    super.key,
    this.onOptionsTap,
    this.onTap,
    this.selectedFolder,
    this.physics,
    this.controller,
    this.primary,
  });

  final List<NoteFolder?> folders;
  final EdgeInsetsGeometry? padding;
  final void Function(NoteFolder)? onTap;
  final void Function(NoteFolder)? onOptionsTap;
  final NoteFolder? selectedFolder;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool? primary;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: physics,
      controller: controller,
      primary: primary,
      padding: padding ?? const .all(16),
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

class FolderListFailureWidget extends StatelessWidget {
  const FolderListFailureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    return Column(
      children: [
        const SizedBox(height: 72),
        MText(
          'An error occurred while retrieving the folders. Please, try again?',
          style: textTheme.bodyRegular,
          textAlign: TextAlign.center,
        ),
        Spaces.verticalXLarge,
        SizedBox(
          height: 32,
          child: MSecondaryButton.icon(
            label: 'Reload',
            icon: const Icon(Icons.refresh),
            style: OutlinedButton.styleFrom(
              textStyle: textTheme.microMedium,
              foregroundColor: colors.onBackground,
              iconColor: colors.onBackground,
              shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
              side: BorderSide(color: colors.outlineVariant3, width: 1.50),
            ),
            onPressed: () => di<FoldersManager>().initialize.run(),
          ),
        ),
      ],
    );
  }
}
