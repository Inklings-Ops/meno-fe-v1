import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno/shared/extensions/m_snack_bar_extension.dart';
import 'package:meno_design_system/meno_design_system.dart';

class AddNotesToFolderModal extends WatchingWidget {
  const AddNotesToFolderModal(this.folder, {super.key});

  final NoteFolder folder;

  static Future<dynamic> show(BuildContext context, NoteFolder folder) {
    final size = MediaQuery.sizeOf(context);
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      constraints: BoxConstraints(maxHeight: size.height * 0.85),
      builder: (context) => AddNotesToFolderModal(folder),
    );
  }

  @override
  Widget build(BuildContext context) {
    pushScope(
      init: (getIt) {
        getIt.registerLazySingleton<FolderAssignmentManager>(() {
          return FolderAssignmentManager(
            repository: di<INotesRepository>(),
            excludedNoteIds: folder.notes.map((n) => n?.id).toSet(),
            onConfirm: getIt<FolderManager>().assignNotesToFolder.runAsync,
          );
        }, onCreated: (m) => m.initialize.run());
      },
    );

    return const _Content();
  }
}

class _Content extends WatchingWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final manager = di<FolderAssignmentManager>();
    final notes = watchValue((FolderAssignmentManager m) => m.notes);
    final isLoading = watchValue(
      (FolderAssignmentManager m) => m.confirm.isRunning,
    );

    registerHandler(
      select: (FolderAssignmentManager m) => m.error,
      handler: (context, error, cancel) {
        if (error == null) return;
        context.showErrorSnackBar(error.message);
      },
    );

    return MModal(
      title: 'Add to Folder',
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spaces.verticalLarge,
          const _SearchBox(),
          Spaces.verticalLarge,
          NotesList(
            notes: notes,
            padding: .zero,
            showAddButton: true,
            onNoteTap: (note) => manager.toggleSelection(note.id),
          ),
          Spaces.verticalLarge,
          MPrimaryButton(
            label: 'Done',
            loading: isLoading,
            disabled: notes.isEmpty,
            onPressed: manager.confirm.run,
          ),
        ],
      ),
    );
  }
}

class _SearchBox extends WatchingWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    final manager = di<FolderAssignmentManager>();
    final query = watchValue((FolderAssignmentManager m) => m.searchQuery);
    final controller = createOnce(() => TextEditingController(text: query));

    Timer? debounce;

    void onChanged(String value) {
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 400), () {
        manager.performSearch.run(value);
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
                  manager.searchQuery.value = '';
                  manager.performSearch.run('');
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
