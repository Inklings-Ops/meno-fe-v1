import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno/features/notes/domain/domain.dart';
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
      itemBuilder: (ctx, index) {
        final folder = folders[index]!;
        return FolderCard(
          folder: folder,
          onTap: () => ctx.push(R.folder(folder.id.getOrCrash())),
          onOptionsTap: () => FolderCardOptionsModal.show(ctx, folder: folder),
        );
      },
    );
  }
}
