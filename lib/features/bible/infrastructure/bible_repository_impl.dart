import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/bible/domain/domain.dart';
import 'package:meno/features/bible/infrastructure/infrastructure.dart';

class BibleRepositoryImpl with MLogger implements IBibleRepository {
  BibleRepositoryImpl({
    required BibleLocalDataSource local,
    required BibleRemoteDataSource remote,
  }) : _local = local,
       _remote = remote;

  final BibleLocalDataSource _local;
  final BibleRemoteDataSource _remote;

  // Broadcast so multiple listeners (e.g. BibleDownloaderBloc) can subscribe.
  // Seeded at 0 — new subscribers always get an immediate value.
  final _progressController = StreamController<int>.broadcast();
  int _lastProgress = 0;

  // =========================================================================
  // INITIALIZATION
  // =========================================================================
  @override
  Future<void> initialize() async {
    if (!_local.isBibleEmpty) {
      log.d('BibleRepository: already seeded, skipping');
      return;
    }

    log.d('BibleRepository: seeding KJV from bundled asset...');

    await _local.seedFromAsset(
      assetPath: 'assets/json/kjv.json',
      translation: 'kjv',
    );

    log.d('BibleRepository: initialization complete');
  }

  // =========================================================================
  // STATE
  // =========================================================================
  @override
  bool get isBibleEmpty => _local.isBibleEmpty;

  // =========================================================================
  // METADATA
  // =========================================================================
  @override
  Map<int, String> get books => BibleMetadata.books;

  @override
  Map<int, int> get chapterCounts => BibleMetadata.chapterCounts;

  @override
  int chapterCount(int bookId) => BibleMetadata.chapterCount(bookId);

  @override
  int verseCount(int bookId, int chapter) {
    return BibleMetadata.verseCount(bookId, chapter);
  }

  // =========================================================================
  // TRANSLATIONS
  // =========================================================================
  @override
  List<Translation> get localTranslations {
    return _local
        .getTranslations(downloaded: true)
        .map((dto) => dto.toDomain)
        .toList();
  }

  @override
  Future<Either<MenoException, List<Translation>>>
  getRemoteTranslations() async {
    try {
      final remote = await _remote.fetchAvailableTranslations();
      log.d('BibleRepository: ${remote.length} translations from remote');
      if (remote.isEmpty) return const Left(MenoException('No translations'));
      return Right(remote.map((dto) => dto.toDomain).toList());
    } catch (e) {
      log.w('BibleRepository: remote translations unavailable — $e');
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
    //
    // log.d('BibleRepository: using local translation fallback');
    // final fallbackTranslations = [
    //   for (final entry in translationNames.entries)
    //     Translation.fromAbbreviation(
    //       entry.key,
    //       downloaded: false,
    //       available: entry.key == 'kjv',
    //     ),
    // ];
    //
    // return Right(fallbackTranslations);
  }

  @override
  List<Verse> getVerses({
    required String book,
    required int chapter,
    required String translation,
  }) {
    return _local
        .getVerses(book: book, chapter: chapter, translation: translation)
        .map((dto) => dto.toDomain)
        .toList();
  }

  @override
  Verse? getVerse({
    required String book,
    required int chapter,
    required int verse,
    required String translation,
  }) {
    final dto = _local.getVerse(
      book: book,
      chapter: chapter,
      verse: verse,
      translation: translation,
    );
    return dto?.toDomain;
  }

  // =========================================================================
  // DOWNLOAD
  // =========================================================================
  @override
  int get currentProgress => _lastProgress;

  @override
  Stream<int> get downloadProgress => _progressController.stream;

  @override
  Future<Either<MenoException, Translation>> downloadTranslation(
    String abbreviation,
  ) async {
    try {
      _emit(0);

      final verses = await _remote.downloadTranslation(
        translation: abbreviation,
        onProgress: _emit,
      );

      // null = cancelled by user, not an error.
      if (verses == null) {
        _emit(0);
        return left(const MenoException('Download cancelled'));
      }

      await _local.storeVerses(verses);
      _local.markTranslationDownloaded(abbreviation);

      _emit(0);

      final translation = Translation.fromAbbreviation(abbreviation);

      log.d('BibleRepository: downloaded $abbreviation successfully');
      return right(translation);
    } on MenoException catch (e) {
      log.e('BibleRepository: download failed', error: e);
      _emit(0);
      return left(e);
    } catch (e) {
      log.e('BibleRepository: unexpected error', error: e);
      _emit(0);
      return left(MenoException(e.toString()));
    }
  }

  @override
  void cancelDownload() {
    _remote.cancelDownload();
    _emit(0);
    log.d('BibleRepository: download cancelled');
  }

  // =========================================================================
  // HELPERS
  // =========================================================================
  void _emit(int progress) {
    _lastProgress = progress;
    if (!_progressController.isClosed) _progressController.add(progress);
  }

  // =========================================================================
  // DISPOSE
  // =========================================================================
  @override
  FutureOr<dynamic> onDispose() {
    _progressController.close();
  }
}
