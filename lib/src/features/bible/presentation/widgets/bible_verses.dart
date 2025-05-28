import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class BibleVerses extends HookWidget {
  const BibleVerses({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<VersesCubit>();
    final scriptureCubit = context.watch<ScripturePickerCubit>();
    final translationBloc = context.watch<TranslationBloc>();
    final transAbb = translationBloc.state.abbreviation;

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
        BlocListener<TranslationBloc, Translation>(
          listener: (context, state) {
            bloc.getVerses(
              book: scriptureCubit.state.book,
              chapter: scriptureCubit.state.chapter,
              translation: transAbb,
            );
          },
        ),
      ],
      child: BlocBuilder<VersesCubit, List<Verse>>(
        bloc: bloc,
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) => ListView.separated(
          shrinkWrap: true,
          itemCount: state.length,
          separatorBuilder: (context, i) => Spaces.verticalMedium,
          itemBuilder: (context, i) => VerseWidget(verse: state[i]),
        ),
      ),
    );
  }
}
