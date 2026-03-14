import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/notes/model/_model.dart';
import 'package:meno/features/notes/services/_services.dart';
import 'package:meno/features/notes/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SelectFolderModal extends WatchingWidget {
  const SelectFolderModal._(
    this.title, {
    required this.isMove,
    this.excludedFolderId,
  }) : super(key: null);

  final String title;
  final Id? excludedFolderId;
  final bool isMove;

  static Future<NoteFolder?> show(
    BuildContext context,
    String title, {
    required bool isMove,
    Id? excludedFolderId,
  }) {
    final size = MediaQuery.sizeOf(context);
    return showModalBottomSheet<NoteFolder?>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      constraints: BoxConstraints(maxHeight: size.height * 0.85),
      builder: (_) => SelectFolderModal._(
        title,
        excludedFolderId: excludedFolderId,
        isMove: isMove,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = createOnce(() => ValueNotifier<String>(''));
    final query = watch(searchQuery).value;
    final currentUserId = watchValue((UserManager m) => m.currentUserId);

    final snapshot = watchStream(
      (NotesLocalService r) => r
          .watchFolders(ownerId: currentUserId.getOrCrash())
          .map((incomingFolders) => incomingFolders.map((dto) => dto.toDomain)),
    );

    if (snapshot.connectionState == ConnectionState.waiting) {
      return _LoadingContent(title: title);
    }

    if (snapshot.hasError) {
      return _ErrorContent(title: title, error: snapshot.error);
    }

    final allFolders = snapshot.data ?? [];

    final filtered = allFolders.where((f) => f.id != excludedFolderId).toList();

    final folders = filtered.where((f) {
      return query.isEmpty ||
          f.title
              .getOrElse((_) => '')
              .toLowerCase()
              .contains(query.toLowerCase());
    }).toList();

    return _Content(
      title: title,
      folders: folders,
      searchQuery: searchQuery,
      isMove: isMove,
    );
  }
}

class _Content extends WatchingWidget {
  const _Content({
    required this.title,
    required this.isMove,
    required this.searchQuery,
    this.folders = const [],
  });

  final String title;
  final bool isMove;
  final List<NoteFolder> folders;
  final ValueNotifier<String> searchQuery;

  @override
  Widget build(BuildContext context) {
    final pickedFolder = createOnce(() => ValueNotifier<NoteFolder?>(null));
    final picked = watch(pickedFolder).value;

    return MModal(
      title: title,
      builder: (ctx) => Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          if (folders.isEmpty)
            const Center(child: MText('No folders found'))
          else ...[
            _SearchBox(searchQuery: searchQuery),
            Spaces.verticalLarge,
            Expanded(
              child: FolderList(
                folders: folders,
                onTap: (folder) {
                  if (picked?.id == folder.id) {
                    pickedFolder.value = null;
                  } else {
                    pickedFolder.value = folder;
                  }
                },
                selectedFolder: picked,
                padding: .zero,
              ),
            ),
            Spaces.verticalLarge,
            if (isMove)
              MPrimaryButton.icon(
                icon: const Icon(MIcons.arrow_narrow_right),
                label: 'Move to folder',
                disabled: picked == null,
                onPressed: () => context.pop(picked),
              )
            else
              MPrimaryButton(
                label: 'Done',
                disabled: picked == null,
                onPressed: () => context.pop(picked),
              ),
          ],
        ],
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.title, required this.error});

  final String title;
  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: title,
      builder: (context) => MenoErrorWidget(
        error: error,
        showRetryButton: false,
        margin: EdgeInsets.zero,
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: title,
      builder: (context) => Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: Skeletonizer(
              child: FolderList(folders: fakeFolders, padding: .zero),
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
