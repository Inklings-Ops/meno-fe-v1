import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class BibleTranslationsModal extends StatelessWidget {
  const BibleTranslationsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return BlocListener<TransBloc, TransState>(
      listener: (context, state) {
        state.downloadOption.fold(
          () => null,
          (either) => either.fold(
            context.showBibleError,
            (r) => null,
          ),
        );
      },
      child: MModal(
        title: 'Bible Translations',
        builder: (context) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MText('Offline Translations', style: textTheme.microRegular),
              Spaces.verticalSmall,
              const OfflineBibleTranslationsList(),
              Spaces.verticalXXLarge,
              MText('Online Translations', style: textTheme.microRegular),
              Spaces.verticalSmall,
              const OnlineBibleTranslationsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class OfflineBibleTranslationsList extends StatelessWidget {
  const OfflineBibleTranslationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TransBloc>();
    return BlocBuilder<TransBloc, TransState>(
      bloc: bloc,
      builder: (context, state) => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: state.storedTranslations.length,
        separatorBuilder: (context, i) => Spaces.verticalLarge,
        itemBuilder: (context, index) {
          final translation = state.storedTranslations[index];
          return TranslationWidget(
            key: ObjectKey(translation.name),
            translation: translation,
            onChange: () {
              bloc.add(ChangeTranslation(translation));
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

class OnlineBibleTranslationsList extends StatelessWidget {
  const OnlineBibleTranslationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TransBloc>();
    return BlocBuilder<TransBloc, TransState>(
      bloc: bloc,
      builder: (context, state) => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: state.otherTranslations.length,
        separatorBuilder: (context, i) => Spaces.verticalLarge,
        itemBuilder: (context, index) {
          final translation = state.otherTranslations[index];
          return TranslationWidget(
            key: ObjectKey(translation),
            translation: translation,
            isOffline: false,
            onDownload: () => bloc.add(DownloadTranslation(translation)),
          );
        },
      ),
    );
  }
}
