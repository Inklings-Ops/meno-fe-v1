import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/widgets/dynamic_sliver_app_bar.dart';
import 'package:meno/features/notes/manager/_manager.dart';
import 'package:meno/features/notes/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MyNotesPage extends WatchingWidget {
  const MyNotesPage({this.initialIndex = 0, super.key}) : isLive = false;

  const MyNotesPage.live({super.key}) : initialIndex = 0, isLive = true;

  final int initialIndex;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final pageCtrl = createOnce(PageController.new);
    final index = createOnce(() => ValueNotifier<int>(initialIndex));

    callAfterEveryBuild((context, cancel) {
      if (pageCtrl.hasClients && pageCtrl.page?.round() != index.value) {
        pageCtrl.animateToPage(
          index.value,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      }
    });

    watch(index);

    final colors = MColorScheme.of(context);

    Widget? titleWidget;
    if (!isLive) {
      titleWidget = const MHeader(
        title: 'My Notes',
        addTopMargin: true,
        padding: EdgeInsets.zero,
      );
    }

    List<Widget>? actions;
    if (!isLive) {
      actions = [
        switch (index.value) {
          0 => const _NewNoteActionButton(),
          1 => const _NewFolderActionButton(),
          _ => const SizedBox(),
        },
        Spaces.horizontalLarge,
      ];
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: DynamicSliverAppBar(
              key: const Key('NotesFolderAppBar'),
              toolbarHeight: isLive ? 8 : kToolbarHeight,
              backgroundColor: colors.background,
              surfaceTintColor: Colors.transparent,
              forceElevated: innerBoxIsScrolled,
              elevation: innerBoxIsScrolled ? 1 : 0,
              shadowColor: colors.onBackground.withValues(alpha: 0.08),
              pinned: true,
              title: titleWidget,
              actions: actions,
              flexibleSpace: GroupWidgets(index: index, isLive: isLive),
              bottom: PreferredSize(
                preferredSize: const .fromHeight(40),
                child: Container(
                  color: colors.background,
                  height: 40,
                  child: switch (index.value) {
                    0 => const _NoteSearchBarWidget(),
                    1 => const _FolderSearchBarWidget(),
                    _ => const SizedBox(height: 40),
                  },
                ),
              ),
            ),
          ),
        ],
        body: PageView(
          controller: pageCtrl,
          onPageChanged: (value) => index.value = value,
          children: const [
            NoteListWidget(isNested: true),
            FolderListWidget(isNested: true),
          ],
        ),
      ),
    );
  }
}

class GroupWidgets extends StatelessWidget {
  const GroupWidgets({required this.index, required this.isLive, super.key});

  final ValueNotifier<int> index;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: .fromLTRB(16, isLive ? 16 : kToolbarHeight, 16, 0),
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
            if (isLive) Spaces.verticalXXLarge else Spaces.verticalXXLarge,
          ],
        ),
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

// class NotesFoldersShell extends WatchingWidget {
//   const NotesFoldersShell._({
//     required this.navigationShell,
//     required this.children,
//     super.key,
//   });
//
//   static Widget builder(
//     BuildContext context,
//     StatefulNavigationShell navigationShell,
//     List<Widget> children,
//   ) => NotesFoldersShell._(
//     key: const ValueKey<String>('NotesFoldersShell'),
//     navigationShell: navigationShell,
//     children: children,
//   );
//
//   final StatefulNavigationShell navigationShell;
//   final List<Widget> children;
//
//   @override
//   Widget build(BuildContext context) {
//     final index = navigationShell.currentIndex;
//
//     final controller = createOnce(PageController.new);
//
//     // Sync PageController → shell whenever the shell's currentIndex changes
//     // (e.g. programmatic context.go(R.folders) or deep link).
//     // callAfterEveryBuild fires after layout, so animateToPage is safe.
//     callAfterEveryBuild((context, cancel) {
//       if (controller.hasClients && controller.page?.round() != index) {
//         controller.animateToPage(
//           index,
//           duration: const Duration(milliseconds: 350),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const MHeader(
//           title: 'My Notes',
//           addTopMargin: true,
//           padding: EdgeInsets.zero,
//         ),
//         actions: [
//           switch (index) {
//             0 => const _NewNoteActionButton(),
//             1 => const _NewFolderActionButton(),
//             _ => const SizedBox(),
//           },
//           Spaces.horizontalLarge,
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const .symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: .spaceBetween,
//               crossAxisAlignment: .end,
//               children: [
//                 Expanded(
//                   child: NotesGroupWidget(
//                     onTap: () => navigationShell.goBranch(0),
//                     selected: index == 0,
//                   ),
//                 ),
//                 Spaces.horizontalSmall,
//                 Expanded(
//                   child: FoldersGroupWidget(
//                     onTap: () => navigationShell.goBranch(1),
//                     selected: index == 1,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Spaces.verticalLarge,
//           switch (index) {
//             0 => const _NoteSearchBarWidget(),
//             1 => const _FolderSearchBarWidget(),
//             _ => const SizedBox(height: Insets.lg),
//           },
//           const SizedBox(height: 2),
//           Expanded(
//             child: PageView(
//               controller: controller,
//               onPageChanged: navigationShell.goBranch,
//               children: children,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
