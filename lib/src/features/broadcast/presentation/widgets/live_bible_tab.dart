import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class LiveBibleTab extends StatelessWidget {
  const LiveBibleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BibleBloc(facade: di<IBibleFacade>())..init(),
        ),
        BlocProvider(
          create: (_) => ScripturePickerCubit(facade: di<IBibleFacade>()),
        ),
        BlocProvider(
          create: (_) => TranslationsCubit(facade: di<IBibleFacade>()),
        ),
        BlocProvider(
          create: (_) => VersesCubit(facade: di<IBibleFacade>()),
        ),
      ],
      child: const LiveBibleTabView(),
    );
  }
}

class LiveBibleTabView extends StatelessWidget {
  const LiveBibleTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScripturePicker(),
          MDivider(bottomSpace: 16),
          Expanded(child: BibleVerses()),
        ],
      ),
    );
  }
}
