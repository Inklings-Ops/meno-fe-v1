import 'dart:async';

import 'package:logger/logger.dart';
import 'package:meno_fe_v1/objectbox.g.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/dtos.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBoxService {

  ObjectBoxService._create(this.store) {
    _bibleBox = store.box<BibleDto>();
    _verseBox = store.box<VerseDto>();
  }
  late final Store store;

  late Box<BibleDto> _bibleBox;
  Box<BibleDto> get bibleBox => _bibleBox;

  late Box<VerseDto> _verseBox;
  Box<VerseDto> get verseBox => _verseBox;

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBoxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final directory = p.join(docsDir.path, 'meno');

    late Store newStore;

    if (Store.isOpen(directory)) {
      newStore = Store.attach(getObjectBoxModel(), directory);
    } else {
      newStore = await openStore(directory: directory);
    }

    return ObjectBoxService._create(newStore);
  }

  bool get isBibleEmpty => _bibleBox.isEmpty();

  Future<void> storeTranslations(List<TranslationDto> translations) async {
    final box = store.box<TranslationDto>();
    await box.putManyAsync(translations);
  }

  Future<void> storeBible(List<VerseDto> verses, String translation) async {
    try {
      Logger().w('TRYING OBJECTBOX SERVICE STORE BIBLE WITHOUT ISOLATE');
      // const batchSize = 10000;
      // final totalItems = verses.length;

      // for (var i = 0; i < totalItems; i += batchSize) {
      //   final end = (i + batchSize < totalItems) ? i + batchSize : totalItems;
      //   final batch = verses.sublist(i, end);
      //   await _verseBox.putManyAsync(batch);
      // }
      store.runInTransaction(TxMode.write, () {
        Logger().w('RUNNING TRANSACTION');
        _verseBox.putMany(verses);

        final allVerses = _verseBox.getAll();

        bibleBox.put(BibleDto(
          translation: translation,
          verses: ToMany(items: allVerses),
        ),);
      });
      Logger().w('DONE STORING BIBLE IN OBJECTBOX');
    } on ObjectBoxException catch (e) {
      Logger().w(e.toString());
    }
  }
}
