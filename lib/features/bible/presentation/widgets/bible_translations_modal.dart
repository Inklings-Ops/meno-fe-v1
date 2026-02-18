import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/bible/applications/applications.dart';
import 'package:meno/features/bible/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BibleTranslationsModal extends StatelessWidget {
  const BibleTranslationsModal({super.key});

  static Future<dynamic> show(BuildContext context) {
    return showModalBottomSheet<dynamic>(
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
    );
  }
}

class OfflineBibleTranslationsList extends WatchingWidget {
  const OfflineBibleTranslationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = watchValue(
      (TranslationsManager m) => m.downloadedTranslations,
    );

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      itemCount: translations.length,
      separatorBuilder: (context, i) => Spaces.verticalLarge,
      itemBuilder: (context, index) {
        final translation = translations[index];
        return TranslationWidget(
          key: ObjectKey(translation.name),
          translation: translation,
          onTap: () {},
        );
      },
    );
  }
}

class OnlineBibleTranslationsList extends WatchingWidget {
  const OnlineBibleTranslationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = watchValue(
      (TranslationsManager m) => m.remoteTranslations,
    );

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      itemCount: translations.length,
      separatorBuilder: (context, i) => Spaces.verticalLarge,
      itemBuilder: (context, index) {
        final translation = translations[index];
        return TranslationWidget(
          key: ObjectKey(translation),
          translation: translation,
        );
      },
    );
  }
}
