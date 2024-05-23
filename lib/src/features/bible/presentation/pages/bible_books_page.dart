import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../application/bible/bible_bloc.dart';
import '../widgets/book_widget.dart';

class BibleBooksPage extends StatelessWidget {
  const BibleBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BibleBloc>();
    final books = bloc.books;
    final booksLength = books.length;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const MText('Bible Books', style: MTextStyle.subheadingMedium),
                MIconButton(
                  icon: const Icon(MIcons.x_close),
                  color: MColorScheme.of(context)?.onBackground,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          MCore.small.verticalSpace,
          const MDivider(),
          ListView.separated(
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) => BookWidget(
              bookName: books[i].key,
              onTap: () => bloc.add(BibleEvent.bookChanged(books[i].key)),
            ),
            separatorBuilder: (context, i) => 10.verticalSpace,
            itemCount: booksLength,
          ),
        ],
      ),
    );
  }
}
