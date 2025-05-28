import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/bible/bible.dart';
import 'package:meno_fe_v1/src/services/network_service.dart';
import 'package:rxdart/rxdart.dart';

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

  final _progressController = BehaviorSubject<int>.seeded(0);

  @override
  Future<void> initialize() async {
    if (!_local.isBibleEmpty) return;

    final jsonStr = await rootBundle.loadString(Assets.json.kjv);

    const translation = 'kjv';
    final verseDtos = await _remote.parse(jsonStr, translation);
    await _local.storeBible(verseDtos ?? [], translation);

    await _local.storeTranslations();
    await _local.updateTranslationWithDownloaded(translation);

    _remote.closeIsolate();
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
      return left(const BibleNetworkException());
    } else {
      try {
        final verseDtos = await _remote.download(
          translation: translation,
          onProgress: (received, total) {
            final progress = total > 0 ? (received * 100 ~/ total) : 0;
            _progressController.add(progress);
          },
        );

        await _local.storeBible(verseDtos ?? [], translation);
        await _local.updateTranslationWithDownloaded(translation);
        final translationDomain = Translation.fromAbbreviation(translation);

        _remote.closeIsolate();

        return right(translationDomain);
      } on DioException catch (e) {
        return left(BibleExceptionWithMessage(e.toString()));
      } on Exception catch (e) {
        return left(BibleExceptionWithMessage(e.toString()));
      }
    }
  }

  @override
  Stream<int> get downloadBibleProgress => _progressController.stream;

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
  void cancelDownload() {
    if (!_remote.isIsolateOpen) return;
    _remote.cancelDownload();
    _remote.closeIsolate();
    return;
  }
}
