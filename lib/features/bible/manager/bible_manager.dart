import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/features/bible/model/_model.dart';
import 'package:meno/features/bible/services/_services.dart';

/// Manages the state of the Bible reader, including navigation and selection.
final class BibleManager with MLogger implements Disposable {
  BibleManager(this._local);

  final BibleLocalService _local;

  // =========================================================================
  // CORE STATE
  // =========================================================================

  /// Index into [BibleMetadata.books] (0 = Genesis).
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

  List<String> get _bookNames => BibleMetadata.bookNames;

  /// All canonical book names in canonical order.
  List<String> get bookNames => _bookNames;

  /// Name for a given 0-based book index.
  String bookName(int id) => BibleMetadata.bookName(id);

  /// Currently active book name.
  String get currentBookName => BibleMetadata.bookName(book.value);

  /// Chapter count for the currently active book.
  int get chapterCount => BibleMetadata.chapterCount(book.value);

  /// Verse count for the currently active chapter.
  int get verseCount => BibleMetadata.verseCount(book.value, chapter.value);

  // =========================================================================
  // NAVIGATION GUARDS
  // =========================================================================

  bool get isFirstChapter => book.value == 0 && chapter.value <= 1;

  bool get isLastChapter {
    final lastBookIdx = BibleMetadata.books.length - 1;
    return book.value == lastBookIdx &&
        chapter.value >= BibleMetadata.chapterCount(lastBookIdx);
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

  /// Load verses for explicit [BibleArgs]. Also resets selection.
  late final getVerses = Command.createSyncNoResult((BibleArgs args) {
    book.value = args.book;
    chapter.value = args.chapter;
    verse.value = args.verse;

    // Prefer the args translation; fall back to the manager's active one.
    final trans = args.translation.isNotEmpty
        ? args.translation
        : translation.value;

    _loadVerses(
      bookName: BibleMetadata.bookName(args.book),
      chapterNum: args.chapter,
      trans: trans,
    );
  });

  /// Reload the current chapter (used after translation change).
  late final refreshChapter = Command.createSyncNoParamNoResult(() {
    _loadVerses(
      bookName: BibleMetadata.bookName(book.value),
      chapterNum: chapter.value,
      trans: translation.value,
    );
  });

  /// Navigate to the next chapter, crossing book boundaries.
  late final nextChapter = Command.createSyncNoParamNoResult(() {
    if (isLastChapter) return;

    final chapCount = BibleMetadata.chapterCount(book.value);
    if (chapter.value < chapCount) {
      chapter.value++;
    } else {
      final nextBookIdx = book.value + 1;
      if (nextBookIdx < BibleMetadata.books.length) {
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
        chapter.value = BibleMetadata.chapterCount(prevBookIdx);
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
      current.add(v);
      current.sort((a, b) => a.verse.compareTo(b.verse));
    }

    selectedVerses.startTransAction();
    selectedVerses.clear();
    selectedVerses.addAll(current);
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
    final result = _local
        .getVerses(book: bookName, chapter: chapterNum, translation: trans)
        .map((dto) => dto.toDomain)
        .toList();

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

/// Value object representing a specific location in the Bible.
final class BibleArgs {
  const BibleArgs({
    this.book = 0,
    this.chapter = 1,
    this.verse,
    this.translation = 'kjv',
  });

  /// 0-based book index (0 = Genesis).
  final int book;

  /// 1-based chapter number.
  final int chapter;

  /// 1-based verse number. Null means the whole chapter.
  final int? verse;

  /// Optional translation abbreviation. If empty, manager's default is used.
  final String translation;

  BibleArgs copyWith({
    int? book,
    int? chapter,
    int? verse,
    String? translation,
  }) {
    return BibleArgs(
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      translation: translation ?? this.translation,
    );
  }
}
