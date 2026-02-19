import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/bible/applications/applications.dart';
import 'package:meno/features/bible/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

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
  // One GlobalObjectKey per book name — stable across rebuilds, no package.
  late final Map<String, GlobalObjectKey> _keys;
  late final BibleManager _manager;

  @override
  void initState() {
    super.initState();
    _manager = di<BibleManager>();
    _keys = {
      for (final name in _manager.bookNames) name: GlobalObjectKey(name),
    };

    // Scroll after the first frame so the list is fully laid out.
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
  }

  void _scrollToCurrent() {
    final key = _keys[_manager.currentBookName];
    final ctx = key?.currentContext;
    if (ctx == null) return;

    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      // Keep the item near the top so its chapter grid is visible below it.
      alignment: 0.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = _manager.bookNames;

    return MModal(
      title: 'Bible Books',
      builder: (context) => ListView.separated(
        itemCount: books.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final bookName = books[index];
          return BookWidget(
            key: _keys[bookName],
            bookName: bookName,
            onChapterSelected: _scrollToCurrent,
          );
        },
      ),
    );
  }
}
