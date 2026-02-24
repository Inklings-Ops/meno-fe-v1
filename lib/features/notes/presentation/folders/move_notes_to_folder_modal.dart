import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/app/router/router.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno/shared/extensions/m_snack_bar_extension.dart';
import 'package:meno/shared/presentation/widgets/error_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MoveNotesToFolderModal extends WatchingWidget {
  const MoveNotesToFolderModal(this.note, {super.key});

  final Note note;

  static Future<dynamic> show(BuildContext context, Note note) {
    final size = MediaQuery.sizeOf(context);
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      constraints: BoxConstraints(maxHeight: size.height * 0.85),
      builder: (context) => MoveNotesToFolderModal(note),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = createOnce(() => ValueNotifier<String>(''));
    final snapshot = watchStream(
      (INotesRepository r) => r.watchFolders(keywords: searchQuery.value),
    );

    if (snapshot.connectionState == ConnectionState.waiting) {
      return _Content(
        note: note,
        folders: fakeFolders,
        isLoading: true,
        searchQuery: searchQuery,
      );
    }

    if (snapshot.hasError) {
      return _Content(
        note: note,
        error: snapshot.error,
        searchQuery: searchQuery,
      );
    }

    final excludedFolderId = note.folder?.id;
    final allFolders = snapshot.data ?? [];
    final folders = allFolders.where((f) => f.id != excludedFolderId).toList();
    return _Content(note: note, folders: folders, searchQuery: searchQuery);
  }
}

class _Content extends WatchingWidget {
  const _Content({
    required this.note,
    required this.searchQuery,
    this.folders = const [],
    this.isLoading = false,
    this.error,
  });

  final Note note;
  final List<NoteFolder> folders;
  final ValueNotifier<String> searchQuery;
  final bool isLoading;
  final dynamic error;

  @override
  Widget build(BuildContext context) {
    registerHandler(
      select: (FolderManager m) => m.error,
      handler: (context, error, cancel) {
        if (error == null) return;
        context.showErrorSnackBar(error.message);
      },
    );

    registerHandler(
      select: (FolderManager m) => m.moveNotes,
      handler: (context, newValue, cancel) => context.popMultiple(2),
    );

    final pickedFolder = createOnce(() => ValueNotifier<NoteFolder?>(null));
    final isMoving = watchValue((FolderManager m) => m.moveNotes.isRunning);

    final hasError = error != null;

    return MModal(
      title: 'Move Note',
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spaces.verticalLarge,
          if (isLoading) ...[
            Skeletonizer(child: FolderList(folders: folders)),
            Spaces.verticalXLarge,
          ],

          if (!isLoading && hasError) ...[
            MenoErrorWidget(error: error),
            Spaces.verticalLarge,
          ],

          if (!isLoading && !hasError && folders.isEmpty) ...[
            const Center(child: MText('No folders found')),
            Spaces.verticalLarge,
          ],

          if (!isLoading && !hasError && folders.isNotEmpty) ...[
            _SearchBox(searchQuery: searchQuery),
            Spaces.verticalLarge,
            if (folders.isEmpty)
              const Center(child: MText('No folders found'))
            else ...[
              FolderList(
                folders: folders,
                onTap: (folder) => pickedFolder.value = folder,
                selectedFolder: pickedFolder.value,
              ),
              Spaces.verticalLarge,
              MPrimaryButton(
                label: 'Done',
                loading: isMoving,
                disabled: pickedFolder.value == null || isMoving,
                onPressed: () {
                  final targetFolderId = pickedFolder.value?.id;
                  if (targetFolderId == null) return;
                  final manager = di<FolderManager>();
                  manager.moveNotes.run(([note.id], targetFolderId));
                },
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _SearchBox extends WatchingWidget {
  const _SearchBox({required this.searchQuery});

  final ValueNotifier<String> searchQuery;

  @override
  Widget build(BuildContext context) {
    final query = watchValue((_) => searchQuery);
    final controller = createOnce(() => TextEditingController(text: query));

    Timer? debounce;

    void onChanged(String value) {
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 300), () {
        searchQuery.value = value;
      });
    }

    onDispose(() => debounce?.cancel());

    final textTheme = MTextTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(Insets.lg),
      child: SizedBox(
        height: 40,
        child: SearchBar(
          elevation: const WidgetStatePropertyAll(0),
          controller: controller,
          onChanged: onChanged,
          hintText: 'Search for note',
          hintStyle: WidgetStatePropertyAll(textTheme.captionRegular),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: Insets.md),
          ),
          leading: const Icon(MIcons.search, size: Insets.lg),
          trailing: [
            if (controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, size: Insets.lg),
                onPressed: () {
                  controller.clear();
                  debounce?.cancel();
                  searchQuery.value = '';
                },
              ),
          ],
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFFC2C7D0)),
              borderRadius: Corners.sm,
            ),
          ),
        ),
      ),
    );
  }
}
