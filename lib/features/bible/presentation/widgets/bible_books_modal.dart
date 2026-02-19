import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/bible/applications/applications.dart';
import 'package:meno/features/bible/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BibleBooksModal extends StatefulWidget {
  const BibleBooksModal({super.key});

  static Future<void> show(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      constraints: BoxConstraints(maxHeight: size.height * 0.9),
      builder: (_) => const BibleBooksModal(),
    );
  }

  @override
  State<BibleBooksModal> createState() => _BibleBooksModalState();
}

class _BibleBooksModalState extends State<BibleBooksModal> {
  late final AutoScrollController _controller;
  late final BibleManager _manager;
  late final List<String> _books;

  static const double _rowHeight = 56;
  static const double _separatorHeight = 10;

  @override
  void initState() {
    super.initState();
    _manager = di<BibleManager>();
    _books = _manager.bookNames;

    _controller = AutoScrollController(
      suggestedRowHeight: _rowHeight + _separatorHeight,
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.paddingOf(context).bottom),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _scrollToCurrent() async {
    final index = _books.indexOf(_manager.currentBookName);
    if (index < 0 || !_controller.hasClients) return;

    await _controller.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MModal(
      title: 'Bible Books',
      builder: (context) => ListView.separated(
        controller: _controller,
        itemCount: _books.length,
        separatorBuilder: (_, __) => const SizedBox(height: _separatorHeight),
        itemBuilder: (context, index) {
          final bookName = _books[index];
          return AutoScrollTag(
            key: ValueKey(bookName),
            controller: _controller,
            index: index,
            child: BookWidget(
              key: ValueKey(bookName),
              bookName: bookName,
              onChapterSelected: _scrollToCurrent,
            ),
          );
        },
      ),
    );
  }
}
