import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/bible/domain/domain.dart';

class BibleManager with MLogger implements Disposable {
  BibleManager(this._repository);

  final IBibleRepository _repository;

  // =========================================================================
  // CORE STATE
  // =========================================================================

  /// Index into [IBibleRepository.books] (0 = Genesis).
  final book = ValueNotifier<int>(0);

  /// 1-based chapter number.
  final chapter = ValueNotifier<int>(1);

  /// 1-based verse number — null means whole chapter is shown.
  final verse = ValueNotifier<int?>(null);

  /// Active translation abbreviation (e.g. 'kjv').
  final translation = ValueNotifier<String>('kjv');

  /// Current chapter's verses.
  final verses = ListNotifier<Verse>(data: []);

  // =========================================================================
  // MULTI-VERSE SELECTION
  // =========================================================================

  /// Verses the user has selected for copy / send-to-chat.
  /// Always kept sorted ascending by [Verse.verse].
  final selectedVerses = ListNotifier<Verse>(data: []);

  // =========================================================================
  // CACHED METADATA
  // =========================================================================

  List<String> get _bookNames => _repository.books.values.toList();

  /// All canonical book names in canonical order.
  List<String> get bookNames => _bookNames;

  /// Name for a given 0-based book index.
  String bookName(int id) => _bookNames[id];

  /// Currently active book name.
  String get currentBookName => _bookNames[book.value];

  /// Chapter count for the currently active book.
  int get chapterCount => _repository.chapterCount(book.value);

  /// Verse count for the currently active chapter.
  int get verseCount => _repository.verseCount(book.value, chapter.value);

  // =========================================================================
  // NAVIGATION GUARDS
  // =========================================================================

  bool get isFirstChapter => book.value == 0 && chapter.value <= 1;

  bool get isLastChapter {
    final lastBookIdx = _repository.books.length - 1;
    return book.value == lastBookIdx &&
        chapter.value >= _repository.chapterCount(lastBookIdx);
  }

  // =========================================================================
  // COMPUTED REFERENCE
  // =========================================================================

  /// Reactive combined reference string — e.g. "Romans 1".
  late final reference = book.combineLatest(
    chapter,
    (b, c) => '${_bookNames[b]} $c',
  );

  // =========================================================================
  // COMMANDS
  // =========================================================================

  /// Load verses for explicit [BibleParams]. Also resets selection.
  late final getVerses = Command.createSyncNoResult((BibleParams params) {
    book.value = params.book;
    chapter.value = params.chapter;
    verse.value = params.verse;

    // Prefer the params translation; fall back to the manager's active one.
    final trans = params.translation.isNotEmpty
        ? params.translation
        : translation.value;

    _loadVerses(
      bookName: _repository.books[params.book] ?? '',
      chapterNum: params.chapter,
      trans: trans,
    );
  });

  /// Reload the current chapter (used after translation change).
  late final refreshChapter = Command.createSyncNoParamNoResult(() {
    _loadVerses(
      bookName: _repository.books[book.value] ?? '',
      chapterNum: chapter.value,
      trans: translation.value,
    );
  });

  /// Navigate to the next chapter, crossing book boundaries.
  late final nextChapter = Command.createSyncNoParamNoResult(() {
    if (isLastChapter) return;

    final chapCount = _repository.chapterCount(book.value);
    if (chapter.value < chapCount) {
      chapter.value++;
    } else {
      final nextBookIdx = book.value + 1;
      if (nextBookIdx < _repository.books.length) {
        book.value = nextBookIdx;
        chapter.value = 1;
      }
    }
  })..pipeToCommand(refreshChapter);

  /// Navigate to the previous chapter, crossing book boundaries.
  late final prevChapter = Command.createSyncNoParamNoResult(() {
    if (isFirstChapter) return;

    if (chapter.value > 1) {
      chapter.value--;
    } else {
      final prevBookIdx = book.value - 1;
      if (prevBookIdx >= 0) {
        book.value = prevBookIdx;
        chapter.value = _repository.chapterCount(prevBookIdx);
      }
    }
  })..pipeToCommand(refreshChapter);

  // =========================================================================
  // SELECTION
  // =========================================================================

  /// Toggle [v] in/out of the selection set. Keeps list sorted.
  void toggleVerseSelection(Verse v) {
    final current = List<Verse>.from(selectedVerses.value);
    final existingIdx = current.indexWhere((s) => s.verse == v.verse);

    if (existingIdx != -1) {
      current.removeAt(existingIdx);
    } else {
      current
        ..add(v)
        ..sort((a, b) => a.verse.compareTo(b.verse));
    }

    selectedVerses.startTransAction();
    selectedVerses
      ..clear()
      ..addAll(current);
    selectedVerses.endTransAction();
  }

  void clearSelection() {
    selectedVerses.startTransAction();
    selectedVerses.clear();
    selectedVerses.endTransAction();
  }

  /// Formatted reference string for the current selection —
  /// e.g. "Romans 1:1-3,5" — or empty if nothing is selected.
  String get selectionReference {
    final sel = List<Verse>.from(selectedVerses.value);
    if (sel.isEmpty) return '';
    return VerseReferenceFormatter.format(sel);
  }

  /// Plain text of the current selection suitable for chat / clipboard.
  /// Format: "<Reference>\n[1] verse text [2] verse text …"
  String get selectionText {
    final sel = List<Verse>.from(selectedVerses.value);
    if (sel.isEmpty) return '';
    final ref = selectionReference;
    final body = sel.map((v) => '[${v.verse}] ${v.text}').join(' ');
    return '$ref\n$body';
  }

  // =========================================================================
  // PRIVATE HELPERS
  // =========================================================================

  void _loadVerses({
    required String bookName,
    required int chapterNum,
    required String trans,
  }) {
    final result = _repository.getVerses(
      book: bookName,
      chapter: chapterNum,
      translation: trans,
    );

    verses.startTransAction();
    verses.clear();
    verses.addAll(result);
    verses.endTransAction();

    // Clear selection whenever the chapter/book changes.
    clearSelection();
  }

  // =========================================================================
  // DISPOSE
  // =========================================================================

  @override
  FutureOr<dynamic> onDispose() {
    log.i('BibleManager: Disposing…');

    book.dispose();
    chapter.dispose();
    verse.dispose();
    translation.dispose();
    verses.dispose();
    selectedVerses.dispose();

    getVerses.dispose();
    refreshChapter.dispose();
    nextChapter.dispose();
    prevChapter.dispose();
  }
}
