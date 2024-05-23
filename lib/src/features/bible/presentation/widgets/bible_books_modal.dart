import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/bible/application/scripture_picker/scripture_picker_cubit.dart';
import 'package:meno_fe_v1/src/features/bible/presentation/widgets/book_widget.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BibleBooksModal extends HookWidget {
  const BibleBooksModal({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ScripturePickerCubit>();

    final books = bloc.books.entries;
    final booksLength = books.length;

    final controller = AutoScrollController(suggestedRowHeight: 200.h);

    useEffect(() {
      final index = books.toList().indexWhere((b) => b.key == bloc.state.book);
      controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
      return null;
    }, []);

    return MModal(
      title: 'Bible Books',
      builder: (context) => Material(
        child: ListView.separated(
          controller: controller,
          itemCount: booksLength,
          separatorBuilder: (context, index) => 10.verticalSpace,
          itemBuilder: (context, index) {
            final book = books.elementAt(index);

            return AutoScrollTag(
              key: ValueKey(index),
              index: index,
              controller: controller,
              child: BookWidget(
                key: ValueKey(index),
                bookName: book.key,
                onTap: () => controller.scrollToIndex(index),
              ),
            );
          },
        ),
      ),
    );
  }
}
