import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meno_fe_v1/objectbox.g.dart';
import 'package:meno_fe_v1/src/features/features.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBoxService {
  ObjectBoxService._create(this.store) {
    _bibleBox = store.box<BibleDto>();
    _verseBox = store.box<VerseDto>();
    _translationBox = store.box<TranslationDto>();
    _noteBox = store.box<NoteDto>();
    _folderBox = store.box<FolderDto>();
    _noteCreatorBox = store.box<NoteCreatorDto>();
  }

  late final Store store;

  late Box<BibleDto> _bibleBox;

  Box<BibleDto> get bibleBox => _bibleBox;

  late Box<VerseDto> _verseBox;

  Box<VerseDto> get verseBox => _verseBox;

  late Box<TranslationDto> _translationBox;

  Box<TranslationDto> get translationBox => _translationBox;

  late Box<NoteDto> _noteBox;

  Box<NoteDto> get noteBox => _noteBox;

  late Box<FolderDto> _folderBox;

  Box<FolderDto> get folderBox => _folderBox;

  late Box<NoteCreatorDto> _noteCreatorBox;

  Box<NoteCreatorDto> get noteCreatorBox => _noteCreatorBox;

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

  bool get hasTranslations => _translationBox.isEmpty();

  Future<void> storeTranslations(List<TranslationDto> translations) async {
    try {
      _translationBox.putMany(translations);
      return;
    } on ObjectBoxException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> storeBible(List<VerseDto> verses, String translation) async {
    try {
      store.runInTransaction(TxMode.write, () {
        _verseBox.putMany(verses);

        final allVerses = _verseBox.getAll();

        bibleBox.put(
          BibleDto(
            translation: translation,
            verses: ToMany(items: allVerses),
          ),
        );
      });
    } on ObjectBoxException catch (e) {
      debugPrint(e.toString());
    }
  }
}
