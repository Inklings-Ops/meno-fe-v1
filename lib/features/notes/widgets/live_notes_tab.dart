import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/notes/manager/_manager.dart';
import 'package:meno/features/notes/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveNotesTab extends WatchingWidget {
  const LiveNotesTab({super.key});

  @override
  Widget build(BuildContext ctx) {
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

    watch(index);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _HeaderWidget(innerBoxIsScrolled: innerBoxIsScrolled, index: index),
        ],
        body: PageView(
          controller: controller,
          onPageChanged: (value) => index.value = value,
          children: const [_NotesListView(), _FoldersListView()],
        ),
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({required this.innerBoxIsScrolled, required this.index});

  final bool innerBoxIsScrolled;
  final ValueNotifier<int> index;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: DynamicSliverAppBar(
        key: const Key('NotesFolderAppBar'),
        toolbarHeight: 8,
        backgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
        forceElevated: innerBoxIsScrolled,
        elevation: innerBoxIsScrolled ? 1 : 0,
        shadowColor: colors.onBackground.withValues(alpha: 0.08),
        pinned: true,
        bottom: PreferredSize(
          preferredSize: const .fromHeight(40),
          child: Container(
            color: colors.background,
            height: 40,
            child: switch (index.value) {
              0 => const NotesSearchBar(),
              1 => const FoldersSearchBar(),
              _ => const SizedBox(height: 40),
            },
          ),
        ),
        flexibleSpace: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const .fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
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
                Spaces.verticalXXXLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotesListView extends WatchingWidget {
  const _NotesListView();

  @override
  Widget build(BuildContext ctx) {
    final notes = watchValue((NotesManager manager) => manager.notes);
    final isLoading = watchValue((NotesManager m) => m.initialize.isRunning);
    return NotesListWidget(
      notes: notes,
      isNested: true,
      isLoading: isLoading,
      onNoteTap: (note) => ctx.push(R.liveNoteEditor(note.id.getOrCrash())),
      onNoteLongPress: (note) => NoteOptionsModal.show(ctx, note),
      onNoteOptionsTap: (note) => NoteOptionsModal.show(ctx, note),
    );
  }
}

class _FoldersListView extends WatchingWidget {
  const _FoldersListView();

  @override
  Widget build(BuildContext ctx) {
    final folders = watchValue((FoldersManager manager) => manager.folders);
    final isLoading = watchValue((FoldersManager m) => m.initialize.isRunning);
    return FoldersListWidget(
      folders: folders,
      isNested: true,
      isLoading: isLoading,
      onFolderTap: (folder) => ctx.push(R.liveFolder(folder.id.getOrCrash())),
      onFolderOptionsTap: (folder) => FolderOptionsModal.show(ctx, folder),
    );
  }
}
