import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/dtos.dart';

import '../../../services/network_service.dart';
import '../domain/domain.dart';
import 'datasources/datasources.dart';

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
  Future<Either<BibleException, Unit>> sync([
    String translation = 'kjv',
  ]) async {
    final isConnected = await _network.isConnected;

    try {
      if (isConnected) {
        final verses = await _remote.downloadBible(translation);
        await _local.storeBible(1, verses);
        return right(unit);
      } else {
        final verses = await _local.loadFallbackBible();
        await _local.storeBible(1, verses);
        return right(unit);
      }
    } on Exception catch (e) {
      return left(BibleException.message(e.toString()));
    }
  }

  @override
  Future<Either<BibleException, List<Translation>>> get translations async {
    final isConnected = await _network.isConnected;

    try {
      if (isConnected) {
        final response = await _remote.getTranslations();
        final dtos = response.data;

        await _local.storeTranslations(1, dtos);

        final translations = dtos.map((e) => e.toDomain).toList();
        return right(translations);
      } else {
        final dtos = _local.getTranslations();
        final translations = dtos.map((e) => e.toDomain).toList();
        return right(translations);
      }
    } on Exception catch (e) {
      return left(BibleException.message(e.toString()));
    }
  }
}
