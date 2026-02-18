import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/bible/domain/domain.dart';

class BibleManager with MLogger implements Disposable {
  BibleManager(this._repository);

  final IBibleRepository _repository;

  final book = ValueNotifier<int>(0);
  final chapter = ValueNotifier<int>(1);
  final verse = ValueNotifier<int?>(null);
  final translation = ValueNotifier<String>('kjv');
  final verses = ListNotifier<Verse>(data: []);

  List<String> get _cachedBookNames => _repository.books.values.toList();

  List<String> get bookNames => _cachedBookNames;

  late final getVerses = Command.createSyncNoResult((BibleParams params) {
    book.value = params.book;
    chapter.value = params.chapter;
    verse.value = params.verse;

    final result = _repository.getVerses(
      book: _repository.books[params.book] ?? '',
      chapter: params.chapter,
      translation: params.translation,
    );

    verses.startTransAction();
    verses.clear();
    verses.addAll(result);
    verses.endTransAction();
  });

  late final refreshChapter = Command.createSyncNoParamNoResult(() {
    final result = _repository.getVerses(
      book: _repository.books[book.value] ?? '',
      chapter: chapter.value,
      translation: translation.value,
    );

    verses.startTransAction();
    verses.clear();
    verses.addAll(result);
    verses.endTransAction();
  });

  late final nextChapter = Command.createSyncNoParamNoResult(() {
    if (isLastChapter) return;
    chapter.value++;
  })..pipeToCommand(refreshChapter);

  late final prevChapter = Command.createSyncNoParamNoResult(() {
    if (isFirstChapter) return;
    chapter.value--;
  })..pipeToCommand(refreshChapter);

  late final reference = book.combineLatest(
    chapter,
    (bookValue, chapterValue) => '${_cachedBookNames[bookValue]} $chapterValue',
  );

  // Helper to reverse map ID to Name
  String get currentBookName => _cachedBookNames[book.value];

  /// Convenience method to get the book name
  String bookName(int id) => _cachedBookNames[id];

  /// Get chapter count for current book
  int get chapterCount => _repository.chapterCount(book.value);

  /// Get verse count for current chapter
  int get verseCount => _repository.verseCount(book.value, chapter.value);

  // Checks if the current chapter is the first chapter
  bool get isFirstChapter => chapter.value <= 1;

  // Checks if current chapter is the last chapter
  bool get isLastChapter => chapter.value >= chapterCount;

  @override
  FutureOr<dynamic> onDispose() {
    log.i('BibleManager: Disposing...');

    book.dispose();
    chapter.dispose();
    verse.dispose();
    translation.dispose();
    verses.dispose();

    getVerses.dispose();
    refreshChapter.dispose();
    nextChapter.dispose();
    prevChapter.dispose();
  }
}
