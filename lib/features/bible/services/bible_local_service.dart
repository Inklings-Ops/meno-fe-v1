import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/services/database.dart';
import 'package:meno/features/bible/model/model.dart';
import 'package:meno/objectbox.g.dart';

class BibleLocalService with MLogger {
  const BibleLocalService(this._db);

  final Database _db;

  // ==========================================================================
  // STATE CHECKS
  // ==========================================================================
  bool get isBibleEmpty => _db.verseBox.isEmpty();

  bool get hasTranslations => !_db.translationBox.isEmpty();

  // ==========================================================================
  // SEED — first launch only
  // ==========================================================================

  /// Loads and parses the bundled KJV asset off the main thread,
  /// writes all verses in a single background transaction,
  /// then seeds the translations table.
  Future<void> seedFromAsset({
    required String assetPath,
    required String translation,
  }) async {
    log.d('BibleLocalService: seeding from asset=$assetPath');
    final jsonString = await rootBundle.loadString(assetPath);

    final verses = await compute(_parseDefaultBibleAsset, (
      jsonString: jsonString,
      translation: translation,
    ));

    log.d('BibleLocalService: parsed ${verses.length} verses — writing...');

    // runWriteTxAsync keeps the 31k insert off the main thread entirely.
    await _db.runWriteTxAsync<void, List<VerseDto>>(
      (store, verses) async => store.box<VerseDto>().putMany(verses),
      verses,
    );

    _seedTranslations();
    _markDownloaded(translation);

    log.d('BibleLocalService: seed complete');
  }

  // ==========================================================================
  // WRITE
  // ==========================================================================
  /// Stores a downloaded translation's verses.
  Future<void> storeVerses(List<VerseDto> verses) {
    return _db.runWriteTxAsync<void, List<VerseDto>>(
      (store, verses) async => store.box<VerseDto>().putMany(verses),
      verses,
    );
  }

  /// Marks a translation as downloaded after successful storage.
  void markTranslationDownloaded(String abbreviation) {
    return _markDownloaded(abbreviation);
  }

  void _seedTranslations() {
    if (hasTranslations) return;

    final dtos = _kTranslationNames.entries
        .map((e) => TranslationDto(abbreviation: e.key, name: e.value))
        .toList();

    _db.runWriteTx(() => _db.translationBox.putMany(dtos));
    log.d('BibleLocalService: seeded ${dtos.length} translations');
  }

  void _markDownloaded(String abbreviation) {
    final query = _db.translationBox
        .query(TranslationDto_.abbreviation.equals(abbreviation))
        .build();

    final dto = query.findFirst();
    query.close();

    if (dto == null) return;
    final updatedDto = dto.copyWith(downloaded: true);
    _db.runWriteTx(() => _db.translationBox.put(updatedDto));
  }

  // ==========================================================================
  // READ
  // ==========================================================================
  List<TranslationDto> getTranslations({required bool downloaded}) {
    final query = _db.translationBox
        .query(TranslationDto_.downloaded.equals(downloaded))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Returns all verses for a chapter ordered by verse number.
  /// Relies on the composite index on (translation, bookName, chapter)
  /// declared in [VerseDto] — add @Index to that entity class if not present.
  List<VerseDto> getVerses({
    required String book,
    required int chapter,
    required String translation,
  }) {
    final query = _db.verseBox
        .query(
          VerseDto_.translation.equals(translation) &
              VerseDto_.bookName.equals(book) &
              VerseDto_.chapter.equals(chapter),
        )
        .order<dynamic>(VerseDto_.verse)
        .build();

    final results = query.find();
    query.close();
    return results;
  }

  /// Returns a single verse by its exact coordinates.
  VerseDto? getVerse({
    required String book,
    required int chapter,
    required int verse,
    required String translation,
  }) {
    final query = _db.verseBox
        .query(
          VerseDto_.translation.equals(translation) &
              VerseDto_.bookName.equals(book) &
              VerseDto_.chapter.equals(chapter) &
              VerseDto_.verse.equals(verse),
        )
        .build();

    final result = query.findFirst();
    query.close();
    return result;
  }

  // ==========================================================================
  // STATIC DATA
  // ==========================================================================
  static const Map<String, int> booksToChaptersMap = {
    'Genesis': 50,
    'Exodus': 40,
    'Leviticus': 27,
    'Numbers': 36,
    'Deuteronomy': 34,
    'Joshua': 24,
    'Judges': 21,
    'Ruth': 4,
    '1 Samuel': 31,
    '2 Samuel': 24,
    '1 Kings': 22,
    '2 Kings': 25,
    '1 Chronicles': 29,
    '2 Chronicles': 36,
    'Ezra': 10,
    'Nehemiah': 13,
    'Esther': 10,
    'Job': 42,
    'Psalms': 150,
    'Proverbs': 31,
    'Ecclesiastes': 12,
    'Song of Solomon': 8,
    'Isaiah': 66,
    'Jeremiah': 52,
    'Lamentations': 5,
    'Ezekiel': 48,
    'Daniel': 12,
    'Hosea': 14,
    'Joel': 3,
    'Amos': 9,
    'Obadiah': 1,
    'Jonah': 4,
    'Micah': 7,
    'Nahum': 3,
    'Habakkuk': 3,
    'Zephaniah': 3,
    'Haggai': 2,
    'Zechariah': 14,
    'Malachi': 4,
    'Matthew': 28,
    'Mark': 16,
    'Luke': 24,
    'John': 21,
    'Acts of the Apostles': 28,
    'Romans': 16,
    '1 Corinthians': 16,
    '2 Corinthians': 13,
    'Galatians': 6,
    'Ephesians': 6,
    'Philippians': 4,
    'Colossians': 4,
    '1 Thessalonians': 5,
    '2 Thessalonians': 3,
    '1 Timothy': 6,
    '2 Timothy': 4,
    'Titus': 3,
    'Philemon': 1,
    'Hebrews': 13,
    'James': 5,
    '1 Peter': 5,
    '2 Peter': 3,
    '1 John': 5,
    '2 John': 1,
    '3 John': 1,
    'Jude': 1,
    'Revelation': 21,
  };
}

// ============================================================================
// ISOLATE PAYLOAD — top-level required by compute()
// ============================================================================

typedef _AssetParsePayload = ({String jsonString, String translation});

/// Parses the bundled KJV JSON string into [VerseDto] list.
/// Runs in a background isolate via [compute].
///
/// "index" is used as the assignable ObjectBox ID — stable, pre-assigned.
List<VerseDto> _parseDefaultBibleAsset(_AssetParsePayload payload) {
  final root = json.decode(payload.jsonString) as Map<String, dynamic>;
  final data = root['data'];
  if (data is! List) throw const FormatException('Unexpected Bible JSON shape');
  return data.map((v) {
    final map = v as Map<String, dynamic>;
    return VerseDto(
      id: (map['index'] as num).toInt(),
      book: map['book_id'] as String,
      bookName: map['book_name'] as String,
      chapter: (map['chapter'] as num).toInt(),
      text: map['text'] as String,
      verse: (map['verse'] as num).toInt(),
      translation: payload.translation,
    );
  }).toList();
}

const _kTranslationNames = <String, String>{
  'kjv': 'King James Version',
  'nkjv': 'New King James Version',
  'niv': 'New International Version',
  'esv': 'English Standard Version',
  'amp': 'Amplified Bible',
  'asv': 'American Standard Version',
  'ylt': "Young's Literal Translation",
};
