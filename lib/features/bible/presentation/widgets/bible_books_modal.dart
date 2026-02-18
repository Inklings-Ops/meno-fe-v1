import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/bible/applications/bible_manager.dart';
import 'package:meno/features/bible/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BibleBooksModal extends WatchingWidget {
  const BibleBooksModal({super.key});

  static Future<dynamic> show(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      constraints: BoxConstraints(maxHeight: size.height * 0.9),
      builder: (_) => const BibleBooksModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // late final AutoScrollController controller;

    final manager = di<BibleManager>();

    final books = manager.bookNames;
    final currentBook = manager.currentBookName;

    // callOnce((ctx) {
    //   final index = books.indexWhere((b) => b == currentBook);
    //   controller = AutoScrollController(suggestedRowHeight: 200);
    //   controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    // });

    return MModal(
      title: 'Bible Books',
      builder: (context) => Material(
        child: ListView.separated(
          // controller: controller,
          itemCount: books.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final book = books[index];

            return BookWidget(
              key: ValueKey(index),
              bookName: book,
              // onTap: () => controller.scrollToIndex(index),
            );
          },
        ),
      ),
    );
  }
}
