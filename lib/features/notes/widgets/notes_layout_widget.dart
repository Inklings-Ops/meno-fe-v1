import 'package:flutter/material.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/notes/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NotesLayoutWidget extends StatefulWidget {
  const NotesLayoutWidget._({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  static Widget builder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) => NotesLayoutWidget._(
    key: const ValueKey<String>('NotesLayoutWidget'),
    navigationShell: navigationShell,
    children: children,
  );

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<NotesLayoutWidget> createState() => _NotesLayoutWidgetState();
}

class _NotesLayoutWidgetState extends State<NotesLayoutWidget> {
  late PageController _controller;

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: const MHeader(
          title: 'My Notes',
          addTopMargin: true,
          padding: EdgeInsets.zero,
        ),
        actions: [
          switch (currentIndex) {
            0 => const NewNoteActionButton(),
            1 => const NewFolderActionButton(),
            _ => const SizedBox(),
          },
          Spaces.horizontalLarge,
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 22, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: NotesGroupWidget(
                    onTap: () => _animateToPage(0),
                    selected: currentIndex == 0,
                  ),
                ),
                Spaces.horizontalSmall,
                Expanded(
                  child: FoldersGroupWidget(
                    onTap: () => _animateToPage(1),
                    selected: currentIndex == 1,
                  ),
                ),
              ],
            ),
          ),
          switch (currentIndex) {
            0 => const NoteSearchBarWidget(),
            1 => const FolderSearchBarWidget(),
            _ => const SizedBox(height: Insets.lg),
          },
          Expanded(
            child: PageView(
              onPageChanged: widget.navigationShell.goBranch,
              controller: _controller,
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }

  void _animateToPage(int index) {
    if (_controller.hasClients) {
      _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
  }
}
