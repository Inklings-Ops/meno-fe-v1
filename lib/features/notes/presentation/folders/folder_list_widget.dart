import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:logger/logger.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/infrastructure/dtos/note_folder_dto.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FolderListWidget extends WatchingWidget {
  const FolderListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final error = watchValue((FoldersManager m) => m.error);
    final folders = watchValue((FoldersManager m) => m.folders);
    final isLoading = watchValue((FoldersManager m) => m.initialize.isRunning);

    const padding = EdgeInsets.all(Insets.lg);

    if (isLoading) return Skeletonizer(child: FolderList(folders: fakeFolders));

    if (error != null && folders.isEmpty) {
      return const Padding(padding: padding, child: NoteListFailureWidget());
    }

    if (error == null && folders.isEmpty) {
      return const Padding(padding: padding, child: EmptyNoteListWidget());
    }

    return FolderList(folders: folders);
  }
}

class FolderList extends StatelessWidget {
  const FolderList({required this.folders, this.padding, super.key});

  final List<NoteFolder?> folders;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: folders.length,
      separatorBuilder: (context, index) => Spaces.verticalLarge,
      itemBuilder: (context, index) => FolderListTile(
        folder: folders[index]!,
        // onTap: () => router.push(Routes.folder, extra: folders[index]),
      ),
    );
  }
}

class FolderListTile extends StatelessWidget {
  const FolderListTile({
    required this.folder,
    super.key,
    this.onTap,
    this.isSelected = false,
  });

  final NoteFolder folder;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final border = Border.all(
      width: 2,
      color: colors.primary,
      strokeAlign: BorderSide.strokeAlignOutside,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: Corners.lg,
      child: Container(
        height: 78,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceTint,
          borderRadius: Corners.lg,
          border: isSelected ? border : null,
        ),
        child: Row(
          children: [
            Skeleton.leaf(
              child: SizedBox(
                height: 46,
                width: 52,
                child: ClipPath(
                  clipper: FolderClipper(r: 8, notch: 4),
                  child: ColoredBox(
                    color: colors.primary,
                    child: Center(
                      child: Icon(
                        MIcons.file_02,
                        size: 20,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spaces.horizontalSmall,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: MText(
                        folder.title.getOrCrash(),
                        style: textTheme.captionMedium,
                      ),
                    ),
                  ),
                  Spaces.verticalMicro,
                  SizedBox(
                    height: 18,
                    child: MText(
                      '${folder.numberOfNotes} notes',
                      style: textTheme.captionRegular,
                      color: colors.onBackgroundVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FolderListTileSkeleton extends StatelessWidget {
  const FolderListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Skeletonizer(
      child: Card(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: Corners.lg),
        child: Container(
          height: 78,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfaceTint,
            borderRadius: Corners.lg,
          ),
          child: Row(
            children: [
              Skeleton.leaf(
                child: SizedBox(
                  height: 46,
                  width: 52,
                  child: ClipPath(
                    clipper: FolderClipper(r: 8, notch: 4),
                    child: ColoredBox(
                      color: colors.primary,
                      child: Center(
                        child: Icon(
                          MIcons.file_02,
                          size: 20,
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spaces.horizontalSmall,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: MText(
                          BoneMock.title,
                          style: textTheme.captionMedium,
                        ),
                      ),
                    ),
                    Spaces.verticalMicro,
                    SizedBox(
                      height: 18,
                      child: MText(
                        BoneMock.subtitle,
                        style: textTheme.captionRegular,
                        color: colors.onBackgroundVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
