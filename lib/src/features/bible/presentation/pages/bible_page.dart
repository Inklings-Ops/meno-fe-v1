import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class BiblePage extends StatelessWidget {
  const BiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bibleFac = di<IBibleFacade>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VersesCubit(facade: bibleFac)),
        BlocProvider(create: (_) => ScripturePickerCubit(facade: bibleFac)),
      ],
      child: const _BibleView(),
    );
  }
}

class _BibleView extends StatelessWidget {
  const _BibleView();

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: AppBar(
        title: const MHeader(title: 'Bible', padding: EdgeInsets.zero),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ScripturePicker(),
          ),
        ),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ScripturePicker(),
          MDivider(bottomSpace: 16),
          Expanded(child: BibleVerses()),
        ],
      ),
    );
  }
}
