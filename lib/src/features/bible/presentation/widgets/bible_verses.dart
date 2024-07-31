import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class BibleVerses extends HookWidget {
  const BibleVerses({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<VersesCubit>();
    final scriptureCubit = context.watch<ScripturePickerCubit>();
    final transCubit = context.watch<TranslationsCubit>();

    useEffect(() {
      final book = scriptureCubit.state.book;
      final chapter = scriptureCubit.state.chapter;
      final transAbb = transCubit.state.selectedTranslation.abbreviation;
      bloc.getVerses(book: book, chapter: chapter, translation: transAbb);
      return null;
    }, const []);

    return MultiBlocListener(
      listeners: [
        BlocListener<ScripturePickerCubit, ScripturePickerState>(
          bloc: scriptureCubit,
          listenWhen: (p, c) => p.chapter != c.chapter,
          listener: (context, state) {
            bloc.getVerses(
              book: state.book,
              chapter: state.chapter,
              translation: transCubit.state.selectedTranslation.abbreviation,
            );
          },
        ),
        BlocListener<TranslationsCubit, TranslationsState>(
          bloc: transCubit,
          listenWhen: (p, c) =>
              p.selectedTranslation != c.selectedTranslation && !c.loading,
          listener: (context, state) {
            bloc.getVerses(
              book: scriptureCubit.state.book,
              chapter: scriptureCubit.state.chapter,
              translation: state.selectedTranslation.abbreviation,
            );
          },
        ),
      ],
      child: BlocBuilder<VersesCubit, VersesState>(
        bloc: bloc,
        buildWhen: (p, c) => p.verses != c.verses,
        builder: (context, state) => ListView.separated(
          shrinkWrap: true,
          itemCount: state.verses.length,
          separatorBuilder: (context, i) => Spaces.verticalMedium,
          itemBuilder: (context, i) => VerseWidget(verse: state.verses[i]),
        ),
      ),
    );
  }
}
