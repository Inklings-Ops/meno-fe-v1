import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:meno_fe_v1/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../features/bible/infrastructure/dtos/dtos.dart';

class ObjectBoxService {
  late final Store store;

  ObjectBoxService._create(this.store) {
    // Add any additional setup code, e.g. build queries.

    // store.box<VerseDto>().removeAll();

    // Future.delayed(const Duration(seconds: 1), () async {
    //   await storeBible(1, 'kjv');
    // });
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBoxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, 'meno'));
    return ObjectBoxService._create(store);
  }

  Future<void> storeBible(int id, List<VerseDto> verses) async {
    RootIsolateToken token = RootIsolateToken.instance!;
    final box = store.box<VerseDto>();
    await Isolate.run(() => _storeInObjectBoxIsolate(token, verses, box));
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
    List<T> list,
    Box<T> box,
  ) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    try {
      const batchSize = 10000;
      final totalItems = list.length;

      for (var i = 0; i < totalItems; i += batchSize) {
        final end = (i + batchSize < totalItems) ? i + batchSize : totalItems;
        final batch = list.sublist(i, end);
        await box.putManyAsync(batch);
      }
    } on ObjectBoxException catch (_) {
      // print(e.message);
    }
  }
}
