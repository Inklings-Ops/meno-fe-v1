import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/bible/model/_model.dart';
import 'package:meno/features/bible/services/_services.dart';

/// Manages the availability and download progress of Bible translations.
class TranslationsManager with MLogger implements Disposable {
  TranslationsManager(this._http, this._local);

  final BibleHttpService _http;
  final BibleLocalService _local;

  // =========================================================================
  // STATE
  // =========================================================================

  /// Translations already stored locally.
  final downloadedTranslations = ListNotifier<Translation>(data: []);

  /// Translations available from the remote API.
  final remoteTranslations = ListNotifier<Translation>(data: []);

  /// Abbreviation of the translation currently being downloaded, or null.
  final downloadingAbbreviation = ValueNotifier<String?>(null);

  // =========================================================================
  // COMMANDS
  // =========================================================================

  /// Initializes the local translation list and seeds KJV if necessary.
  late final initialize = Command.createAsyncNoParamNoResult(() async {
    if (_local.isBibleEmpty) {
      await _local.seedFromAsset(
        assetPath: 'assets/json/kjv.json',
        translation: 'kjv',
      );
    }
    _refreshDownloaded();
  }, errorFilterFn: menoExceptionFilter);

  /// Fetches the list of available translations from the remote API.
  late final getRemoteTranslations = Command.createAsyncNoParamNoResult(
    () async {
      try {
        final dtos = await _http.fetchAvailableTranslations();
        final translations = dtos.map((dto) => dto.toDomain).toList();

        if (translations.isEmpty) return;

        remoteTranslations.startTransAction();
        remoteTranslations.clear();
        remoteTranslations.addAll(translations);
        remoteTranslations.endTransAction();
      } catch (e) {
        log.w('TranslationsManager: remote translations unavailable — $e');
        // Fallback or rethrow based on business needs
        rethrow;
      }
    },
    errorFilterFn: menoExceptionFilter,
  );

  /// Downloads a translation by abbreviation.
  ///
  /// Progress is surfaced via the command's `.progress` ValueListenable.
  /// On success, the translation is moved to [downloadedTranslations].
  late final downloadTranslation = Command.createAsyncNoResultWithProgress((
    String abbreviation,
    ProgressHandle handle,
  ) async {
    downloadingAbbreviation.value = abbreviation;

    try {
      final verses = await _http.downloadTranslation(
        translation: abbreviation,
        onProgress: (p) => handle.updateProgress(p / 100),
      );

      if (verses == null) {
        log.d('TranslationsManager: download cancelled');
        return;
      }

      await _local.storeVerses(verses);
      _local.markTranslationDownloaded(abbreviation);

      log.d('TranslationsManager: downloaded $abbreviation');
      _refreshDownloaded();

      // Remove from remote list since it is now local.
      remoteTranslations.startTransAction();
      remoteTranslations.removeWhere((t) => t.abbreviation == abbreviation);
      remoteTranslations.endTransAction();
    } finally {
      downloadingAbbreviation.value = null;
    }
  }, errorFilterFn: menoExceptionFilter);

  // =========================================================================
  // PRIVATE HELPERS
  // =========================================================================

  void _refreshDownloaded() {
    final local = _local
        .getTranslations(downloaded: true)
        .map((dto) => dto.toDomain)
        .toList();

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

    downloadedTranslations.dispose();
    remoteTranslations.dispose();
    downloadingAbbreviation.dispose();

    initialize.dispose();
    getRemoteTranslations.dispose();
    downloadTranslation.dispose();
  }
}
