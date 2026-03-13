import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:intl/intl.dart';
import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/notes/manager/_manager.dart';
import 'package:meno/features/notes/model/_model.dart';
import 'package:meno/features/notes/services/_services.dart';
import 'package:meno/features/notes/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class FolderPage extends WatchingWidget {
  const FolderPage({required this.folderId, super.key});

  final String folderId;

  @override
  Widget build(BuildContext context) {
    pushScope(
      init: (getIt) {
        getIt.registerLazySingleton<FolderManager>(() {
          return FolderManager(
            local: di<NotesLocalService>(),
            folderId: .fromString(folderId),
          );
        }, onCreated: (instance) => instance.initialize.run());
      },
    );

    return const _FolderPageContent();
  }
}

class _FolderPageContent extends WatchingWidget {
  const _FolderPageContent();

  @override
  Widget build(BuildContext context) {
    final scrollController = createOnce(ScrollController.new);

    final isLoading = watchValue((FolderManager m) => m.initialize.isRunning);
    final folder = watchValue((FolderManager m) => m.folder);

    return RefreshIndicator(
      onRefresh: () async {},
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 42,
          leadingWidth: 90,
          leading: const MCustomBackButton(title: 'Folders'),
          actions: isLoading ? null : [_PageOptionsButton(folder: folder)],
        ),

        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            if (isLoading)
              const SliverToBoxAdapter(
                child: Center(child: MLoadingIndicator.box()),
              )
            else ...[
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: _FolderWidget(),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _SearchBox(),
                ),
              ),
              const SliverFillRemaining(child: _FolderNotesList()),
            ],
          ],
        ),
      ),
    );
  }
}

class _FolderWidget extends WatchingWidget {
  const _FolderWidget();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final folder = watchValue((FolderManager m) => m.folder);
    final notesCount = watchValue((FolderManager m) => m.totalNotesCount);

    return RawMaterialButton(
      onPressed: null,
      shape: const FolderWidgetBorder(),
      fillColor: colors.primary,
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      child: Container(
        height: 88,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MText(
              folder.title.getOrElse((_) => ''),
              style: textTheme.subheadingMedium,
              color: colors.onPrimary,
            ),
            MText(
              _formatNotesNumber(notesCount),
              style: textTheme.captionMedium,
              color: colors.onPrimary,
            ),
          ],
        ),
      ),
    );
  }

  String _formatNotesNumber(int numberOfNotes) {
    return Intl.plural(
      numberOfNotes,
      zero: 'No notes',
      one: '1 note',
      other: '$numberOfNotes notes',
    );
  }
}

class _PageOptionsButton extends StatelessWidget {
  const _PageOptionsButton({required this.folder});

  final NoteFolder folder;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final folderId = folder.id.getOrCrash();

    return IconButton(
      icon: const Icon(MIcons.dots_horizontal),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) => MModal(
          builder: (ctx) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MModalListTile(
                leading: const Icon(MIcons.file_plus_02),
                title: 'Add Notes',
                onTap: () async {
                  final result = await SelectNotesModal.show(ctx, folder.id);
                  if (result == null) return;
                  di<NoteActionsManager>().assignNotesToFolder.run((
                    noteIds: result,
                    targetFolderId: folder.id,
                  ));
                },
              ),
              Spaces.verticalSmall,
              MModalListTile(
                leading: const Icon(MIcons.edit_05),
                title: 'Rename Folder',
                onTap: () => FolderEditorModal.show(ctx, folderId),
              ),
              Spaces.verticalSmall,
              MModalListTile(
                leading: Icon(MIcons.trash, color: colors.error),
                title: 'Delete',
                titleColor: colors.error,
                onTap: () async => _deleteFolder(context),
              ),
              Spaces.verticalLarge,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteFolder(BuildContext context) async {
    final result = await DeleteAlertDialog.show(
      context,
      title: 'Delete Folder?',
      description: 'Do want to delete this folder?',
    );

    if (result ?? false) {
      di<FoldersManager>().deleteFolder.run(folder.id);
      if (context.mounted) context.popMultiple(2);
    }
  }

  Future<void> _renameFolder(BuildContext ctx) async {
    final result = await FolderEditorModal.show(ctx, folder.id.getOrCrash());
    if ((result ?? false) && ctx.mounted) ctx.pop();
  }
}

class _SearchBox extends WatchingWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    final manager = di<FolderManager>();
    final query = watchValue((FolderManager m) => m.searchQuery);
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

    return SizedBox(
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
    );
  }
}

class _FolderNotesList extends WatchingWidget {
  const _FolderNotesList();

  @override
  Widget build(BuildContext ctx) {
    final textTheme = MTextTheme.of(ctx);
    final folder = watchValue((FolderManager m) => m.folder);
    final notes = folder.notes;

    if (notes.isEmpty) {
      return Padding(
        padding: const .all(Insets.lg),
        child: MText(
          'No notes found in this folder',
          style: textTheme.bodyRegular,
          textAlign: TextAlign.center,
        ),
      );
    }

    return NotesList(
      notes: notes,
      onNoteTap: (note) => ctx.pushNamed(
        R.noteEditorName,
        pathParameters: {'noteId': note.id.getOrCrash()},
      ),
      onNoteOptionsTap: (note) => _NoteOptionsModal.show(ctx, note, folder.id),
    );
  }
}

class _EmptyFolderPlaceholder extends StatelessWidget {
  const _EmptyFolderPlaceholder({required this.folder});

  final NoteFolder folder;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Container(
      width: 266,
      height: 224,
      margin: const EdgeInsets.only(top: 64),
      child: Column(
        children: [
          Assets.images.newFile.image(height: 120, width: 160),
          MText(
            'Let’s add some notes to this folder',
            style: textTheme.bodyRegular,
            textAlign: TextAlign.center,
          ),
          Spaces.verticalXLarge,
          SizedBox(
            width: 155,
            height: 32,
            child: MSecondaryButton.icon(
              label: 'Add to this Folder',
              icon: const Icon(MIcons.plus),
              style: OutlinedButton.styleFrom(
                textStyle: textTheme.microMedium,
                foregroundColor: colors.onBackground,
                iconColor: colors.onBackground,
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
                side: BorderSide(color: colors.outlineVariant3, width: 1.50),
              ),
              onPressed: () async {
                final result = await SelectNotesModal.show(context);
                if (result == null) return;
                di<NoteActionsManager>().assignNotesToFolder.run((
                  noteIds: result,
                  targetFolderId: folder.id,
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteOptionsModal extends WatchingWidget {
  const _NoteOptionsModal._({required this.note, this.folderId})
    : super(key: null);

  final Note note;
  final Id? folderId;

  static Future<dynamic> show(BuildContext context, Note note, [Id? folderId]) {
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => _NoteOptionsModal._(note: note, folderId: folderId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MModalListTile(
            leading: const Icon(MIcons.file_02),
            title: 'Move Note',
            onTap: () async => _moveNoteToFolder(context),
          ),
          Spaces.verticalSmall,
          MModalListTile(
            leading: const Icon(MIcons.folder_x),
            title: 'Remove from Folder',
            onTap: () async => _removeNoteFromFolder(context),
          ),
          Spaces.verticalSmall,
        ],
      ),
    );
  }

  Future<void> _moveNoteToFolder(BuildContext ctx) async {
    final folder = await SelectFolderModal.show(ctx, 'Move Note', isMove: true);
    if (folder == null) return;
    di<NoteActionsManager>().assignNotesToFolder.run((
      noteIds: [note.id],
      targetFolderId: folder.id,
    ));
    if (ctx.mounted) ctx.pop();
  }

  Future<void> _removeNoteFromFolder(BuildContext context) async {
    final folderId = note.folder?.id;
    if (folderId == null) return;

    final result = await RemoveAlertDialog.show(
      context,
      title: 'Remove Note',
      description: 'Do you want to remove this note from this folder?',
    );

    if (result == false) return;

    di<NoteActionsManager>().removeNotesFromFolder.run((
      noteIds: [note.id],
      folderId: folderId,
    ));
    if (context.mounted) context.pop();
  }
}
