import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:meno_fe_v1/src/features/bible/domain/domain.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/bible_worker_isolate.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/datasources/datasources.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/dtos.dart';
import 'package:meno_fe_v1/src/services/network_service.dart';

@Injectable(as: IBibleFacade)
class BibleFacade implements IBibleFacade {
  BibleFacade({
    required BibleLocalDatasource local,
    required BibleRemoteDatasource remote,
    required NetworkService network,
  })  : _local = local,
        _remote = remote,
        _network = network;

  final BibleLocalDatasource _local;
  final BibleRemoteDatasource _remote;
  final NetworkService _network;

  @PostConstruct(preResolve: true)
  Future<void> initialize() async {
    // Logger().w('INITIALIZING BIBLE');
    // const params = BibleIsolateParams(translation: 'kjv');
    // final isConnected = await _network.isConnected;

    // if (!_local.isBibleEmpty) {
    //   Logger().w('ALREADY DOWNLOADED');
    //   return;
    // }

    // if (_local.isBibleEmpty && isConnected) {
    //   Logger().w('DOWNLOADING FROM REMOTE');
    //   final worker = await BibleWorkerIsolate.spawn();
    //   final verseDtos = await worker.downloadBible(params);
    //   await _local.storeBible(verseDtos ?? [], params.translation);
    //   return;
    // } else {
    //   Logger().w('DOWNLOADING FROM LOCAL JSON');
    //   final verseDtos = await _local.loadFallbackBible();
    //   await _local.storeBible(verseDtos, params.translation);
    //   return;
    // }
  }

@override
  Future<void> init() async {
        Logger().w('INITIALIZING BIBLE');
    const params = BibleIsolateParams(translation: 'kjv');
    final isConnected = await _network.isConnected;

    if (!_local.isBibleEmpty) {
      Logger().w('ALREADY DOWNLOADED');
      return;
    }

    if (_local.isBibleEmpty && isConnected) {
      Logger().w('DOWNLOADING FROM REMOTE');
      final worker = await BibleWorkerIsolate.spawn();
      final verseDtos = await worker.downloadBible(params);
      await _local.storeBible(verseDtos ?? [], params.translation);
      return;
    } else {
      Logger().w('DOWNLOADING FROM LOCAL JSON');
      final verseDtos = await _local.loadFallbackBible();
      await _local.storeBible(verseDtos, params.translation);
      return;
    }
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
  Future<Either<BibleException, Translation>> sync({
    required String translation,
    void Function(int, int)? onProgress,
    CancelToken? cancel,
  }) async {
    Logger().w('Bible about to download $translation');
    final isConnected = await _network.isConnected;

    if (!isConnected) {
      await syncFallpop();
      return left(const BibleException.networkError());
    } else {
      try {
        Logger().w('Bible downloading $translation');
        final worker = await BibleWorkerIsolate.spawn();
        final verseDtos = await worker.downloadBible(
          BibleIsolateParams(translation: translation),
        );
        await _local.storeBible(verseDtos ?? [], translation);
        final translationDomain = handleFullTranslations(translation).toDomain;
        return right(translationDomain);
      } on Exception catch (e) {
        return left(BibleException.message(e.toString()));
      }
    }
  }

  @override
  Future<Either<BibleException, Unit>> syncFallpop() async {
    Logger().w('Fallback Bible about to download');

    try {
      Logger().w('Fallback Bible downloaded already');

      final verseDtos = await _local.loadFallbackBible();
      await _local.storeBible(verseDtos, 'kjv');

      return right(unit);
    } on Exception catch (e) {
      return left(BibleException.message(e.toString()));
    }
  }

  @override
  Future<List<Translation>> get onlineTranslations async {
    final isConnected = await _network.isConnected;

    try {
      if (isConnected) {
        final response = await _remote.getTranslations();
        final translations = response.data.map((e) => e.toDomain).toList();
        return translations;
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  List<Translation> get offlineTranslations {
    final dtos = _local.getTranslations();
    final translations = dtos.map((e) => e.toDomain).toList();
    return translations;
  }

//   @override
//   Future<Either<BibleException, List<Translation>>> getTranslations() async {
//     final isConnected = await _network.isConnected;

//     try {
//       if (isConnected) {
//         final response = await _remote.getTranslations();
//         final dtos = response.data;

//         await _local.storeTranslations(1, dtos);

//         final translations = dtos.map((e) => e.toDomain).toList();
//         return right(translations);
//       } else {
//         // final dtos = _local.getTranslations();
//         // final translations = dtos.map((e) => e.toDomain).toList();
//         return right([]);
//       }
//     } on Exception catch (e) {
//       return left(BibleException.message(e.toString()));
//     }
//   }
}
