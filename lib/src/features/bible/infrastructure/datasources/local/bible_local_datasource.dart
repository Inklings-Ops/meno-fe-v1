// ignore_for_file: equal_elements_in_set

import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/objectbox.g.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/datasources/data_helper.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/dtos.dart';
import 'package:meno_fe_v1/src/services/objectbox_service.dart';

@injectable
class BibleLocalDatasource {
  BibleLocalDatasource({
    required ObjectBoxService objectBox,
  }) : _objectBox = objectBox;
  final ObjectBoxService _objectBox;

  Store get _store => _objectBox.store;

  bool get isBibleEmpty => _objectBox.isBibleEmpty;

  Map<String, int> get booksToChaptersMap => {
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

  List<TranslationDto> getTranslations() {
    final bibleBox = _store.box<BibleDto>();
    final bibles = bibleBox.getAll();

    final translations = bibles.map((e) => e.translation).toList();
    return translations.map(handleFullTranslations).toList();
  }

  List<VerseDto> getVerses({
    required String book,
    required int chapter,
    required String translation,
  }) {
    // final verseBox = _objectBox.verseBox;
    // QueryBuilder<VerseDto> builder = verseBox.query(
    //   VerseDto_.bookName.equals(book) &
    //       VerseDto_.chapter.equals(chapter) &
    //       VerseDto_.translation.equals(translation),
    // );

    // builder.backlinkMany(
    //   BibleDto_.verses,
    //   BibleDto_.translation.equals(translation),
    // );

    // Query<VerseDto> query = builder.order(VerseDto_.verse).build();
    // List<VerseDto> verses = query.find();
    // query.close();
    // return verses;

    final verseBox = _objectBox.verseBox;
    final builder = verseBox.query(
      VerseDto_.translation.equals(translation) &
          VerseDto_.bookName.equals(book) &
          VerseDto_.chapter.equals(chapter),
    );
    final verseDtos = builder.order(VerseDto_.verse).build().find();
    return verseDtos;
  }

  VerseDto? getVerse({
    required String book,
    required int chapter,
    required int verse,
    required String translation,
  }) {
    final verseBox = _objectBox.verseBox;
    final builder = verseBox.query(
      VerseDto_.translation.equals(translation) &
          VerseDto_.bookName.equals(book) &
          VerseDto_.chapter.equals(chapter),
    );
    final verseDto = builder.build().find().first;
    return verseDto;
  }

  ChapterDto? getChapter({
    required String book,
    required int chapter,
    required String translation,
  }) {
    final bibleBox = _objectBox.bibleBox;

    final builder = bibleBox.query(BibleDto_.translation.equals(translation));
    builder.linkMany(
      BibleDto_.verses,
      VerseDto_.book.equals(book) & VerseDto_.chapter.equals(chapter),
    );
    final bibleDto = builder.build().findFirst()!;
    final verses = bibleDto.verses;

    final chapterDto = ChapterDto(id: chapter, book: book, verses: verses);
    return chapterDto;
  }

  Future<void> storeBible(List<VerseDto> verses, String translation) {
    return _objectBox.storeBible(verses, translation);
  }

  Future<void> storeTranslations(List<TranslationDto> translations) {
    return _objectBox.storeTranslations(translations);
  }

  Future<List<VerseDto>> loadFallbackBible() async {
    final rIToken = RootIsolateToken.instance!;
    final verses = await Isolate.run(() => _loadJSONAsset(rIToken));
    return verses;
  }

  static Future<List<VerseDto>> _loadJSONAsset(RootIsolateToken token) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    final jsonStr = await rootBundle.loadString('assets/bibles/kjv.json');

    final decodedJson = jsonDecode(jsonStr) as Map<String, dynamic>;
    final data = decodedJson['data'] as List<dynamic>;
    final versesData = data.cast<Map<String, dynamic>>();

    final verses = versesData
        .map((v) => VerseDto.fromJson(v).copyWith(id: v['index'] as int))
        .toList();

    return verses;
  }
}
