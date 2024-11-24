import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NotesPageLayout extends StatefulWidget {
  const NotesPageLayout({
    required this.navigationShell,
    required this.children,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('NotesPageLayout'));

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<NotesPageLayout> createState() => _NotesPageLayoutState();
}

class _NotesPageLayoutState extends State<NotesPageLayout> {
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
                  child: NoteWidget(
                    onTap: () => _animateToPage(0),
                    selected: currentIndex == 0,
                  ),
                ),
                Spaces.horizontalSmall,
                Expanded(
                  child: FolderWidget(
                    onTap: () => _animateToPage(1),
                    selected: currentIndex == 1,
                  ),
                ),
              ],
            ),
          ),
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
