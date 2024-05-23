import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/bible/application/scripture_picker/scripture_picker_cubit.dart';
import 'package:meno_fe_v1/src/features/bible/application/translations/translations_cubit.dart';
import 'package:meno_fe_v1/src/features/bible/application/verses/verses_cubit.dart';

import '../widgets/scripture_picker.dart';
import '../widgets/verse_widget.dart';

class BiblePage extends StatelessWidget {
  const BiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.secondary(title: 'Bible', centerTitle: true),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          ScripturePicker(),
          MDivider(bottomSpace: 16),
          Expanded(child: BibleVerses()),
        ],
      ),
    );
  }
}

class BibleVerses extends StatelessWidget {
  const BibleVerses({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<VersesCubit>();

    return MultiBlocListener(
      listeners: [
        BlocListener<ScripturePickerCubit, ScripturePickerState>(
          listenWhen: (p, c) => p.chapter != c.chapter,
          listener: (context, state) {
            bloc.getVerses(book: state.book, chapter: state.chapter);
          },
        ),
        BlocListener<TranslationsCubit, TranslationsState>(
          listenWhen: (p, c) => p.selectedTranslation != c.selectedTranslation,
          listener: (context, state) {
            final translation = state.selectedTranslation.abbreviation;
            bloc.getVerses(translation: translation);
          },
        ),
      ],
      child: BlocBuilder<VersesCubit, VersesState>(
        bloc: bloc,
        buildWhen: (p, c) => p.verses != c.verses,
        builder: (context, state) => ListView.separated(
          shrinkWrap: true,
          itemCount: state.verses.length,
          separatorBuilder: (context, i) => MCore.medium.verticalSpace,
          itemBuilder: (context, i) => VerseWidget(verse: state.verses[i]),
        ),
      ),
    );
  }
}
