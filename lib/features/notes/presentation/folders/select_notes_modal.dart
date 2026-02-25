import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno/shared/domain/value_objects/id.dart';
import 'package:meno/shared/presentation/widgets/error_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SelectNotesModal extends WatchingWidget {
  const SelectNotesModal._([this.excludedFolderId]) : super(key: null);

  final Id? excludedFolderId;

  static Future<List<Id>?> show(BuildContext context, [Id? excludedFolderId]) {
    final size = MediaQuery.sizeOf(context);
    return showModalBottomSheet<List<Id>?>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      constraints: BoxConstraints(maxHeight: size.height * 0.85),
      builder: (context) => SelectNotesModal._(excludedFolderId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = createOnce(() => ValueNotifier<String>(''));
    final query = watch(searchQuery).value;

    final snapshot = watchStream((INotesRepository r) => r.watchNotes());

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const _LoadingContent();
    }

    if (snapshot.hasError) return _ErrorContent(error: snapshot.error);

    final allNotes = snapshot.data ?? [];

    final filtered = allNotes
        .where((n) => n.folder == null || n.folder?.id != excludedFolderId)
        .toList();

    final notes = filtered.where((n) {
      return query.isEmpty ||
          n.title
              .getOrElse((_) => '')
              .toLowerCase()
              .contains(query.toLowerCase());
    }).toList();

    return _Content(notes: notes, searchQuery: searchQuery);
  }
}

class _Content extends WatchingWidget {
  const _Content({required this.notes, required this.searchQuery});

  final List<Note> notes;
  final ValueNotifier<String> searchQuery;

  @override
  Widget build(BuildContext context) {
    final pickedNotes = createOnce(SetNotifier<Note>.new);
    final pickedIds = watch(pickedNotes).value.map((n) => n.id).toList();

    return MModal(
      title: 'Add to Folder',
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SearchBox(searchQuery: searchQuery),
          Spaces.verticalLarge,
          Expanded(
            child: NotesList(
              notes: notes,
              padding: .zero,
              showAddButton: true,
              onNoteTap: (note) {
                if (pickedIds.contains(note.id)) {
                  pickedNotes.value.remove(note);
                } else {
                  pickedNotes.add(note);
                }
              },
              selectedNoteIds: pickedIds.toList(),
            ),
          ),
          Spaces.verticalLarge,
          MPrimaryButton(
            label: 'Done',
            disabled: pickedIds.isEmpty,
            onPressed: () => context.pop(pickedIds),
          ),
        ],
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.error});

  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: 'Add to Folder',
      builder: (context) =>
          MenoErrorWidget(error: error, margin: .zero, showRetryButton: false),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: 'Add to Folder',
      builder: (context) => Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          Spaces.verticalLarge,
          Expanded(
            child: Skeletonizer(
              child: NotesList(notes: fakeNotes, padding: .zero),
            ),
          ),
          Spaces.verticalXLarge,
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
    final query = watch(searchQuery).value;
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
    );
  }
}
