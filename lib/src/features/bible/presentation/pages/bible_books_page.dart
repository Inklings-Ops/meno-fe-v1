import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class BibleBooksPage extends StatelessWidget {
  const BibleBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;

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
                MText('Bible Books', style: textTheme.subheadingMedium),
                MIconButton(
                  icon: const Icon(MIcons.x_close),
                  color: MColorScheme.of(context)?.onBackground,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Spaces.verticalSmall,
          const MDivider(),
          ListView.separated(
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) => BookWidget(
              bookName: books[i].key,
              onTap: () {},
            ),
            separatorBuilder: (context, i) => const SizedBox(height: 10),
            itemCount: booksLength,
          ),
        ],
      ),
    );
  }
}
