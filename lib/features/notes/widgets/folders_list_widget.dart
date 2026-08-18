import 'package:flutter/material.dart';
import 'package:meno/features/notes/model/entities/note_folder.dart';
import 'package:meno/features/notes/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FoldersListWidget extends StatelessWidget {
  const FoldersListWidget({
    required this.folders,
    super.key,
    this.onFolderOptionsTap,
    this.onFolderTap,
    this.selectedFolder,
    this.padding = const .all(16),
    this.physics,
    this.controller,
    this.primary,
    this.isNested = false,
    this.isLoading = false,
  });

  final List<NoteFolder?> folders;
  final void Function(NoteFolder)? onFolderTap;
  final void Function(NoteFolder)? onFolderOptionsTap;
  final NoteFolder? selectedFolder;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final EdgeInsetsGeometry padding;
  final bool? primary;
  final bool isNested;
  final bool isLoading;

  @override
  Widget build(BuildContext ctx) {
    if (folders.isEmpty) return const EmptyFolderListWidget();
    return CustomScrollView(
      primary: primary,
      controller: controller,
      physics: physics,
      slivers: [
        if (isNested) ...[
          Builder(
            builder: (context) => SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
          ),
        ],
        SliverPadding(
          padding: padding,
          sliver: SliverList.separated(
            itemCount: folders.length,
            separatorBuilder: (_, __) => Spaces.verticalLarge,
            itemBuilder: (context, index) {
              final folder = folders[index];
              if (folder == null) return const SizedBox.shrink();

              if (isLoading) {
                return Skeletonizer(child: FolderCard(folder: folder));
              }

              return FolderCard(
                key: ValueKey(folder.id),
                folder: folder,
                onTap: () => onFolderTap?.call(folder),
                onOptionsTap: () => onFolderOptionsTap?.call(folder),
              );
            },
          ),
        ),
      ],
    );
  }
}

class FolderListFailureWidget extends StatelessWidget {
  const FolderListFailureWidget({required this.onRefresh, super.key});

  final Future<void> Function() onRefresh;

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
            onPressed: () async => onRefresh(),
          ),
        ),
      ],
    );
  }
}
