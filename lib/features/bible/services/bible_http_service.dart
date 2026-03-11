import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/services/http_client.dart';
import 'package:meno/features/bible/model/_model.dart';

class BibleHttpService with MLogger {
  BibleHttpService(this._http);

  final HttpClient _http;

  CancelToken? _cancelToken;

  /// Downloads a Bible translation and parses it off the main thread.
  ///
  /// - Progress is reported via [onProgress] as a percentage [0–100].
  /// - Returns `null` if the download was cancelled.
  /// - Throws [MenoException] on network or parse failure.
  Future<List<VerseDto>?> downloadTranslation({
    required String translation,
    required void Function(int percent) onProgress,
  }) async {
    // Fresh token for each download.
    _cancelToken = CancelToken();

    try {
      log.d('BibleHttpService: downloading translation=$translation');

      // We bypass HttpClient's _executeRequest intentionally:
      // The Bible API returns raw binary (not a MenoResponse JSON wrapper),
      // and we need onReceiveProgress — neither fits HttpClient's contract.
      final response = await _http.raw.get<Uint8List>(
        '/api/default/',
        queryParameters: {'v': translation},
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total <= 0) return;
          onProgress((received * 100 ~/ total).clamp(0, 100));
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          // Bible API may be slow on large translations.
          receiveTimeout: const Duration(minutes: 3),
        ),
      );

      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        throw const MenoException('Empty response from Bible API');
      }

      log.d('BibleHttpService: parsing ${bytes.length} bytes off-thread');

      // Offload decode + DTO mapping to a background isolate.
      final verses = await compute(_parseVerseBytes, (
        bytes: bytes,
        translation: translation,
      ));

      log.d('BibleHttpService: parsed ${verses.length} verses');
      return verses;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        log.d('BibleHttpService: download cancelled');
        return null; // Cancellation is not an error — let caller decide.
      }
      log.e('BibleHttpService: download failed', error: e);
      throw MenoException(e.message ?? 'Failed to download Bible translation');
    } catch (e) {
      log.e('BibleHttpService: parse failed', error: e);
      throw MenoException(e.toString());
    } finally {
      // Always clear so stale tokens can't be cancelled after completion.
      _cancelToken = null;
    }
  }

  /// Parses a bundled KJV JSON string off the main thread.
  Future<List<VerseDto>> parseAsset({
    required String jsonString,
    required String translation,
  }) async {
    log.d('BibleHttpService: parsing asset for translation=$translation');

    try {
      final bytes = Uint8List.fromList(utf8.encode(jsonString));
      return compute(_parseVerseBytes, (
        bytes: bytes,
        translation: translation,
      ));
    } catch (e) {
      log.e('BibleHttpService: asset parse failed', error: e);
      throw MenoException('Failed to parse bundled Bible asset: $e');
    }
  }

  /// Cancels an in-progress download. No-op if nothing is downloading.
  void cancelDownload() {
    _cancelToken?.cancel('User cancelled download');
    _cancelToken = null;
  }

  bool get isDownloading => _cancelToken != null;

  // ==========================================================================
  // TRANSLATIONS
  // Fetches available translations from remote.
  // The repository falls back to the local list if this throws.
  // ==========================================================================

  /// Returns translations the API considers available for download.
  Future<List<TranslationDto>> fetchAvailableTranslations() async {
    final results = await _http.getList<TranslationDto>(
      '/api/translations/',
      fromJson: (json) {
        final map = json as Map<String, dynamic>;
        final abb = map['abbreviation'] as String;
        return TranslationDto(
          abbreviation: abb,
          name: translationNames[abb] ?? abb.toUpperCase(),
          downloaded: true,
          available: true,
        );
      },
    );
    return results;
  }
}

// ============================================================================
// ISOLATE PAYLOAD
// Top-level so compute() can serialize it across isolate boundaries.
// ============================================================================

/// Payload passed to the background isolate for JSON parsing.
typedef _ParsePayload = ({Uint8List bytes, String translation});

/// Parses raw Bible JSON bytes into [VerseDto] list.
/// Must be top-level for use with [compute].
List<VerseDto> _parseVerseBytes(_ParsePayload payload) {
  final jsonString = utf8.decode(payload.bytes);
  final root = json.decode(jsonString) as Map<String, dynamic>;

  // Expected shape: { "data": [ {...verse...}, ... ] }
  final data = root['data'];
  if (data is! List) throw const FormatException('Unexpected Bible API shape');

  return data.cast<Map<String, dynamic>>().map((v) {
    return VerseDto.fromJson(v).copyWith(translation: payload.translation);
  }).toList();
}
