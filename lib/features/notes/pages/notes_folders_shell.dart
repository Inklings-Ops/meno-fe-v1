import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/notes/manager/_manager.dart';
import 'package:meno/features/notes/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NotesFoldersShell extends WatchingWidget {
  const NotesFoldersShell._({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  static Widget builder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) => NotesFoldersShell._(
    key: const ValueKey<String>('NotesFoldersShell'),
    navigationShell: navigationShell,
    children: children,
  );

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final index = navigationShell.currentIndex;

    final controller = createOnce(PageController.new);

    // Sync PageController → shell whenever the shell's currentIndex changes
    // (e.g. programmatic context.go(R.folders) or deep link).
    // callAfterEveryBuild fires after layout, so animateToPage is safe.
    callAfterEveryBuild((context, cancel) {
      if (controller.hasClients && controller.page?.round() != index) {
        controller.animateToPage(
          index,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const MHeader(
          title: 'My Notes',
          addTopMargin: true,
          padding: EdgeInsets.zero,
        ),
        actions: [
          switch (index) {
            0 => const _NewNoteActionButton(),
            1 => const _NewFolderActionButton(),
            _ => const SizedBox(),
          },
          Spaces.horizontalLarge,
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const .symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .end,
              children: [
                Expanded(
                  child: NotesGroupWidget(
                    onTap: () => navigationShell.goBranch(0),
                    selected: index == 0,
                  ),
                ),
                Spaces.horizontalSmall,
                Expanded(
                  child: FoldersGroupWidget(
                    onTap: () => navigationShell.goBranch(1),
                    selected: index == 1,
                  ),
                ),
              ],
            ),
          ),
          Spaces.verticalLarge,
          switch (index) {
            0 => const _NoteSearchBarWidget(),
            1 => const _FolderSearchBarWidget(),
            _ => const SizedBox(height: Insets.lg),
          },
          const SizedBox(height: 2),
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: navigationShell.goBranch,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewNoteActionButton extends WatchingWidget {
  const _NewNoteActionButton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    final totalCount = watchValue((NotesManager m) => m.totalNotesCount);
    if (totalCount < 1) return const SizedBox.shrink();
    return InkWell(
      onTap: () => context.push(R.noteEditor()),
      child: Row(
        children: [
          Icon(MIcons.plus, size: 22, color: colors.primary),
          Spaces.horizontalMicro,
          MText(
            'Add New Note',
            style: textTheme.captionMedium,
            color: colors.primary,
          ),
        ],
      ),
    );
  }
}

class _NewFolderActionButton extends WatchingWidget {
  const _NewFolderActionButton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    final totalCount = watchValue((FoldersManager m) => m.totalFoldersCount);
    if (totalCount < 1) return const SizedBox.shrink();
    return InkWell(
      onTap: () => FolderEditorModal.show(context),
      child: Row(
        children: [
          Icon(MIcons.plus, size: 22, color: colors.primary),
          Spaces.horizontalMicro,
          MText(
            'Add New Folder',
            style: textTheme.captionMedium,
            color: colors.primary,
          ),
        ],
      ),
    );
  }
}

class _NoteSearchBarWidget extends WatchingWidget {
  const _NoteSearchBarWidget();

  @override
  Widget build(BuildContext context) {
    final manager = di<NotesManager>();
    final controller = createOnce(TextEditingController.new);
    callOnce((_) => controller.text = manager.searchQuery.value);
    watch(controller);
    final searchQuery = watchValue((NotesManager m) => m.searchQuery);
    if (controller.text != searchQuery) controller.text = searchQuery;
    final textTheme = MTextTheme.of(context);
    return Container(
      height: 40,
      padding: const .symmetric(horizontal: 16),
      child: SearchBar(
        elevation: const WidgetStatePropertyAll(0),
        controller: controller,
        onChanged: manager.performSearch.run,
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
                manager.clearSearch();
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

class _FolderSearchBarWidget extends WatchingWidget {
  const _FolderSearchBarWidget();

  @override
  Widget build(BuildContext context) {
    final manager = di<FoldersManager>();
    final controller = createOnce(TextEditingController.new);
    callOnce((_) => controller.text = manager.searchQuery.value);
    watch(controller);
    final searchQuery = watchValue((FoldersManager m) => m.searchQuery);
    if (controller.text != searchQuery) controller.text = searchQuery;
    final textTheme = MTextTheme.of(context);
    return Container(
      height: 40,
      padding: const .symmetric(horizontal: 16),
      child: SearchBar(
        elevation: const WidgetStatePropertyAll(0),
        controller: controller,
        onChanged: manager.performSearch.run,
        hintText: 'Search for folder',
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
                manager.clearSearch();
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
