import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/domain/domain.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/bible_worker_isolate.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/datasources/datasources.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/dtos.dart';
import 'package:meno_fe_v1/src/services/network_service.dart';

@Injectable(as: IBibleFacade)
class BibleFacade implements IBibleFacade {
  BibleFacade({
    required BibleLocalDatasource local,
    required NetworkService network,
  })  : _local = local,
        _network = network;

  final BibleLocalDatasource _local;
  final NetworkService _network;

  BibleWorkerIsolate? _worker;

  @override
  Future<void> initialize() async {
    if (!_local.isBibleEmpty) return;

    final jsonStr = await rootBundle.loadString(Assets.json.kjv);
    _worker = await BibleWorkerIsolate.spawn();

    final verseDtos = await _worker?.parseBible(jsonStr);
    await _local.storeBible(verseDtos ?? [], 'kjv');

    await _local.storeTranslations();
    await _local.updateTranslationWithDownloaded('kjv');

    _worker?.close();
    _worker = null;
    return;
  }

  @override
  bool get isBibleEmpty => _local.isBibleEmpty;

  @override
  Map<String, int> get books => _local.booksToChaptersMap;

  @override
  Chapter getChapter({
    required String book,
    required int chapter,
    required String translation,
  }) {
    final dto = _local.getChapter(
      book: book,
      chapter: chapter,
      translation: translation,
    );
    return dto!.toDomain;
  }

  @override
  Verse? getVerse({
    required String book,
    required int chapter,
    required int verse,
    required String translation,
  }) {
    final result = _local.getVerse(
      book: book,
      chapter: chapter,
      verse: verse,
      translation: translation,
    );
    return result?.toDomain;
  }

  @override
  List<Verse> getVerses({
    required String book,
    required int chapter,
    required String translation,
  }) {
    final verses = _local.getVerses(
      book: book,
      chapter: chapter,
      translation: translation,
    );

    return verses.map((e) => e.toDomain).toList();
  }

  @override
  Future<Either<BibleException, Translation>> downloadBible(
    String translation,
  ) async {
    final isConnected = await _network.isConnected;

    if (!isConnected) {
      return left(const BibleException.networkError());
    } else {
      try {
        _worker = await BibleWorkerIsolate.spawn();
        final verseDtos = await _worker?.downloadBible(translation);

        await _local.storeBible(verseDtos ?? [], translation);
        await _local.updateTranslationWithDownloaded(translation);
        final translationDomain = Translation.fromAbbreviation(translation);

        _worker?.close();
        _worker = null;

        // Job 5:12, 19-22

        return right(translationDomain);
      } on Exception catch (e) {
        return left(BibleException.message(e.toString()));
      }
    }
  }

  @override
  Stream<double?> get downloadBibleProgress {
    if (_worker == null) return const Stream<double?>.empty();
    return _worker!.progressStream;
  }

  @override
  List<Translation> get storedTranslations {
    final localTranslations = _local.getTranslations(true);
    return localTranslations.map((e) => e.toDomain).toList();
  }

  @override
  List<Translation> get otherTranslations {
    final localTranslations = _local.getTranslations(false);
    return localTranslations.map((e) => e.toDomain).toList();
  }

  @override
  void cancelBibleDownload(String translation) {
    if (_worker == null) return;

    _worker?.cancelDownload(translation);
    _worker?.close();
    _worker = null;
  }
}
