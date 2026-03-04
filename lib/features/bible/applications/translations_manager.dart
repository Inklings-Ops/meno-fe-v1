import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/bible/domain/domain.dart';

class TranslationsManager with MLogger implements Disposable {
  TranslationsManager(this._repository);

  final IBibleRepository _repository;

  // =========================================================================
  // STATE
  // =========================================================================

  final downloadedTranslations = ListNotifier<Translation>(data: []);
  final remoteTranslations = ListNotifier<Translation>(data: []);

  /// Download progress [0–100] for the currently downloading translation.
  final downloadProgress = ValueNotifier<int>(0);

  /// Abbreviation of the translation currently being downloaded, or null.
  final downloadingAbbreviation = ValueNotifier<String?>(null);

  StreamSubscription<int>? _progressSub;

  // =========================================================================
  // COMMANDS
  // =========================================================================

  late final initialize = Command.createSyncNoParamNoResult(
    _refreshDownloaded,
    errorFilterFn: menoExceptionFilter,
  );

  late final getRemoteTranslations = Command.createSyncNoParamNoResult(
    () async {
      final result = await _repository.getRemoteTranslations();
      return result.fold((failure) => throw failure, (translations) {
        if (translations.isEmpty) return;
        remoteTranslations.startTransAction();
        remoteTranslations
          ..clear()
          ..addAll(translations);
        remoteTranslations.endTransAction();
      });
    },
    errorFilterFn: menoExceptionFilter,
  );

  /// Downloads a translation by abbreviation.
  ///
  /// Progress is surfaced via [downloadProgress] + [downloadingAbbreviation].
  /// On success the translation is moved to [downloadedTranslations].
  late final downloadTranslation = Command.createAsyncNoResult<String>((
    abbreviation,
  ) async {
    if (downloadingAbbreviation.value != null) return; // one at a time

    downloadingAbbreviation.value = abbreviation;
    downloadProgress.value = 0;

    // Subscribe to the repository's progress stream.
    await _progressSub?.cancel();
    _progressSub = _repository.downloadProgress.listen(
      (p) => downloadProgress.value = p,
    );

    try {
      final result = await _repository.downloadTranslation(abbreviation);
      result.fold(
        (failure) {
          log.e('TranslationsManager: download failed — ${failure.message}');
          throw failure;
        },
        (translation) {
          log.d('TranslationsManager: downloaded ${translation.abbreviation}');
          _refreshDownloaded();
          // Remove from remote list since it is now local.
          remoteTranslations.startTransAction();
          remoteTranslations.removeWhere((t) => t.abbreviation == abbreviation);
          remoteTranslations.endTransAction();
        },
      );
    } finally {
      await _progressSub?.cancel();
      _progressSub = null;
      downloadingAbbreviation.value = null;
      downloadProgress.value = 0;
    }
  }, errorFilterFn: menoExceptionFilter);

  /// Cancels an in-progress download.
  late final cancelDownload = Command.createSyncNoParamNoResult(
    _repository.cancelDownload,
  );

  // =========================================================================
  // PRIVATE HELPERS
  // =========================================================================

  void _refreshDownloaded() {
    final local = _repository.localTranslations;
    downloadedTranslations.startTransAction();
    downloadedTranslations.clear();
    downloadedTranslations.addAll(local);
    downloadedTranslations.endTransAction();
  }

  // =========================================================================
  // DISPOSE
  // =========================================================================

  @override
  FutureOr<dynamic> onDispose() {
    log.i('TranslationsManager: Disposing…');
    _progressSub?.cancel();

    downloadedTranslations.dispose();
    remoteTranslations.dispose();
    downloadProgress.dispose();
    downloadingAbbreviation.dispose();

    initialize.dispose();
    getRemoteTranslations.dispose();
    downloadTranslation.dispose();
    cancelDownload.dispose();
  }
}
