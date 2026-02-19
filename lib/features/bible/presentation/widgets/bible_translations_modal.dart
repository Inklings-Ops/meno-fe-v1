import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/bible/applications/applications.dart';
import 'package:meno/features/bible/domain/domain.dart';
import 'package:meno/features/bible/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BibleTranslationsModal extends StatelessWidget {
  const BibleTranslationsModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => const BibleTranslationsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    return MModal(
      title: 'Bible Translations',
      builder: (context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MText('Downloaded', style: textTheme.microRegular),
            Spaces.verticalSmall,
            const _DownloadedList(),
            Spaces.verticalXXLarge,
            MText('Available Online', style: textTheme.microRegular),
            Spaces.verticalSmall,
            const _OnlineList(),
          ],
        ),
      ),
    );
  }
}

class _DownloadedList extends WatchingWidget {
  const _DownloadedList();

  @override
  Widget build(BuildContext context) {
    final translations = watchValue(
      (TranslationsManager m) => m.downloadedTranslations,
    );

    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: translations.length,
      separatorBuilder: (_, __) => Spaces.verticalLarge,
      itemBuilder: (context, index) {
        final t = translations[index];
        return TranslationWidget(
          key: ObjectKey(t.abbreviation),
          translation: t,
          onSelect: () => _applyTranslation(context, t),
        );
      },
    );
  }

  void _applyTranslation(BuildContext context, Translation t) {
    final manager = di<BibleManager>();
    manager.translation.value = t.abbreviation;
    manager.refreshChapter.run();
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class _OnlineList extends WatchingWidget {
  const _OnlineList();

  @override
  Widget build(BuildContext context) {
    final translations = watchValue(
      (TranslationsManager m) => m.remoteTranslations,
    );

    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: translations.length,
      separatorBuilder: (_, __) => Spaces.verticalLarge,
      itemBuilder: (context, index) {
        final t = translations[index];
        return TranslationWidget(
          key: ObjectKey(t.abbreviation),
          translation: t,
          isDownloaded: false,
          onDownload: () => _download(context, t),
        );
      },
    );
  }

  void _download(BuildContext context, Translation t) {
    di<TranslationsManager>().downloadTranslation.run(t.abbreviation);
  }
}
