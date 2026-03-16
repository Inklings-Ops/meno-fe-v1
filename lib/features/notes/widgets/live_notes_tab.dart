import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/manager/_manager.dart';
import 'package:meno/features/notes/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveNotesTab extends WatchingWidget {
  const LiveNotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = createOnce(PageController.new);
    final index = createOnce(() => ValueNotifier<int>(0));

    callAfterEveryBuild((context, cancel) {
      if (controller.hasClients && controller.page?.round() != index.value) {
        controller.animateToPage(
          index.value,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const .symmetric(horizontal: 16),
          sliver: Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .end,
            children: [
              Expanded(
                child: NotesGroupWidget(
                  onTap: () => index.value = 0,
                  selected: index.value == 0,
                ),
              ),
              Spaces.horizontalSmall,
              Expanded(
                child: FoldersGroupWidget(
                  onTap: () => index.value = 1,
                  selected: index.value == 1,
                ),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(child: Spaces.verticalLarge),
        SliverToBoxAdapter(
          child: switch (index.value) {
            0 => const _NoteSearchBarWidget(key: Key('liveNotesSearchBar')),
            1 => const _FolderSearchBarWidget(key: Key('liveFoldersSearchBar')),
            _ => const SizedBox(height: Insets.lg),
          },
        ),
        const SliverToBoxAdapter(child: Spaces.verticalLarge),
        Expanded(
          child: PageView(
            controller: controller,
            onPageChanged: (value) => index.value = value,
            children: [const NoteListWidget(), const FolderListWidget()],
          ),
        ),
      ],
    );
  }
}

class _NoteSearchBarWidget extends WatchingWidget {
  const _NoteSearchBarWidget({super.key});

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
  const _FolderSearchBarWidget({super.key});

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
