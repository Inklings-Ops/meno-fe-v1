import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class BibleVerses extends HookWidget {
  const BibleVerses({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<VersesCubit>();
    final scriptureCubit = context.watch<ScripturePickerCubit>();
    final translationBloc = context.watch<TranslationBloc>();
    final transAbb = translationBloc.state.translation.abbreviation;

    useEffect(
      () {
        final book = scriptureCubit.state.book;
        final chapter = scriptureCubit.state.chapter;
        bloc.getVerses(book: book, chapter: chapter, translation: transAbb);
        return null;
      },
      const [],
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<ScripturePickerCubit, ScripturePickerState>(
          listenWhen: (p, c) => p.chapter != c.chapter,
          listener: (context, state) {
            bloc.getVerses(
              book: state.book,
              chapter: state.chapter,
              translation: transAbb,
            );
          },
        ),
        BlocListener<TranslationBloc, TranslationState>(
          listener: (context, state) {
            bloc.getVerses(
              book: scriptureCubit.state.book,
              chapter: scriptureCubit.state.chapter,
              translation: transAbb,
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
