import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';

class BibleTranslationsModal extends StatelessWidget {
  const BibleTranslationsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final translationBloc = context.read<TranslationBloc>();
    final translationsBloc = context.read<TranslationsBloc>();
    return BlocListener<BibleDownloaderBloc, BibleDownloaderState>(
      listener: (context, state) {
        state.option.fold(
          () => null,
          (either) => either.fold(
            context.showBibleError,
            (translation) {
              final localTrans = translationsBloc.state.localTranslations;
              if (localTrans.contains(translation)) return;
              translationBloc.add(ChangeTranslation(translation));
              translationsBloc.add(UpdateTranslations(translation));
              return router.pop<void>();
            },
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
    final translationBloc = context.read<TranslationBloc>();
    return BlocBuilder<TranslationsBloc, TranslationsState>(
      builder: (context, state) => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: state.localTranslations.length,
        separatorBuilder: (context, i) => Spaces.verticalLarge,
        itemBuilder: (context, index) {
          final translation = state.localTranslations[index];
          return TranslationWidget(
            key: ObjectKey(translation.name),
            translation: translation,
            onChange: () {
              translationBloc.add(ChangeTranslation(translation));
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
    final bibleDownloader = context.watch<BibleDownloaderBloc>();
    return BlocBuilder<TranslationsBloc, TranslationsState>(
      builder: (context, state) => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: state.remoteTranslations.length,
        separatorBuilder: (context, i) => Spaces.verticalLarge,
        itemBuilder: (context, index) {
          final translation = state.remoteTranslations[index];
          final abbreviation = translation.abbreviation;
          return TranslationWidget(
            key: ObjectKey(translation),
            translation: translation,
            isOffline: false,
            onDownload: () => bibleDownloader.add(DownloadBible(abbreviation)),
          );
        },
      ),
    );
  }
}
