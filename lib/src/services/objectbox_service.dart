import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:meno_fe_v1/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../features/bible/infrastructure/dtos/dtos.dart';

class ObjectBoxService {
  late final Store store;

  late Box<BibleDto> _bibleBox;
  Box<BibleDto> get bibleBox => _bibleBox;

  late Box<VerseDto> _verseBox;
  Box<VerseDto> get verseBox => _verseBox;

  ObjectBoxService._create(this.store) {
    _bibleBox = store.box<BibleDto>();
    _verseBox = store.box<VerseDto>();
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBoxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    var directory = p.join(docsDir.path, 'meno');

    late Store newStore;

    if (Store.isOpen(directory)) {
      newStore = Store.attach(getObjectBoxModel(), directory);
    } else {
      newStore = await openStore(directory: directory);
    }

    return ObjectBoxService._create(newStore);
  }

  bool get isBibleEmpty => _bibleBox.isEmpty();

  Future<void> storeBibleWithoutIsolate(
      List<VerseDto> verses, String translation) async {
    try {
      const batchSize = 10000;
      final totalItems = verses.length;

      for (var i = 0; i < totalItems; i += batchSize) {
        final end = (i + batchSize < totalItems) ? i + batchSize : totalItems;
        final batch = verses.sublist(i, end);
        await _verseBox.putManyAsync(batch);
      }

      final allVerses = ToMany<VerseDto>(items: _verseBox.getAll());
      bibleBox.put(BibleDto(translation: translation, verses: allVerses));
    } on ObjectBoxException catch (_) {
      // print(e.message);
    }
  }

  Future<void> storeTranslations(
    int id,
    List<TranslationDto> translations,
  ) async {
    RootIsolateToken token = RootIsolateToken.instance!;
    final box = store.box<TranslationDto>();
    await Isolate.run(() => _storeInObjectBoxIsolate(token, translations, box));
  }

  static Future<void> _storeInObjectBoxIsolate<T>(
    RootIsolateToken token,
    T object,
    Box<T> box,
  ) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);

    try {
      if (T is List<T>) {
        const batchSize = 10000;
        final totalItems = (object as List<T>).length;

        for (var i = 0; i < totalItems; i += batchSize) {
          final end = (i + batchSize < totalItems) ? i + batchSize : totalItems;
          final batch = object.sublist(i, end);
          await box.putManyAsync(batch);
        }
      } else {
        await box.putAsync(object);
      }
    } on ObjectBoxException catch (_) {
      // print(e.message);
    }
  }

  // static Future<void> _storeIsolate(
  //   RootIsolateToken token,
  //   List<VerseDto> verses,
  //   String translation,
  // ) async {
  //   BackgroundIsolateBinaryMessenger.ensureInitialized(token);

  //   final store = Store(getObjectBoxModel());

  //   final verseBox = store.box<VerseDto>();
  //   final bibleBox = store.box<BibleDto>();

  //   try {
  //     const batchSize = 10000;
  //     final totalItems = verses.length;

  //     for (var i = 0; i < totalItems; i += batchSize) {
  //       final end = (i + batchSize < totalItems) ? i + batchSize : totalItems;
  //       final batch = verses.sublist(i, end);
  //       await verseBox.putManyAsync(batch);
  //     }

  //     final allVerses = ToMany<VerseDto>(items: verseBox.getAll());
  //     // bibleBox.put(BibleDto(translation: translation, verses: allVerses));
  //   } on ObjectBoxException catch (_) {
  //     // print(e.message);
  //   }
  // }
}
