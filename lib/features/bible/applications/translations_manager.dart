import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/bible/domain/domain.dart';

class TranslationsManager with MLogger implements Disposable {
  TranslationsManager(this._repository);

  final IBibleRepository _repository;

  late final downloadedTranslations = ListNotifier<Translation>(data: []);

  late final remoteTranslations = ListNotifier<Translation>(data: []);

  late final initialize = Command.createSyncNoParamNoResult(() async {
    downloadedTranslations.startTransAction();
    downloadedTranslations.clear();
    downloadedTranslations.addAll(_repository.localTranslations);
    downloadedTranslations.endTransAction();
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(getRemoteTranslations);

  late final getRemoteTranslations = Command.createSyncNoParamNoResult(
    () async {
      final result = await _repository.getRemoteTranslations();
      return result.fold((failure) => throw failure, (translations) {
        if (translations.isEmpty) return;
        remoteTranslations.startTransAction();
        remoteTranslations.clear();
        remoteTranslations.addAll(translations);
      });
    },
    errorFilterFn: menoExceptionFilter,
  );

  @override
  FutureOr<dynamic> onDispose() {
    log.i('TranslationsManager: Disposing...');
    downloadedTranslations.dispose();
    remoteTranslations.dispose();

    initialize.dispose();
    getRemoteTranslations.dispose();
  }
}
