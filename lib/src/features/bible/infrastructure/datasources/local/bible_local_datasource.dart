// ignore_for_file: equal_elements_in_set

import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../objectbox.g.dart';
import '../../../../../services/objectbox_service.dart';
import '../../dtos/dtos.dart';

@injectable
class BibleLocalDatasource {
  final ObjectBoxService _objectBox;

  BibleLocalDatasource({
    required ObjectBoxService objectBox,
  }) : _objectBox = objectBox;

  Store get _store => _objectBox.store;

  List<BookDto> get bibleBooks => booksToChaptersMap.entries
        .map((e) => BookDto(name: e.key, numberOfChapters: e.value))
        .toList();

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
      'Revelation': 2,
    };

  // Map<String, String> get bibleBooksMap {
  //   return {
  //     'Gen': 'Genesis',
  //     'Exod': 'Exodus',
  //     'Lev': 'Leviticus',
  //     'Num': 'Numbers',
  //     'Deut': 'Deuteronomy',
  //     'Josh': 'Joshua',
  //     'Judg': 'Judges',
  //     'Ruth': 'Ruth',
  //     '1Sam': '1 Samuel',
  //     '2Sam': '2 Samuel',
  //     '1Kgs': '1 Kings',
  //     '2Kgs': '2 Kings',
  //     '1Chr': '1 Chronicles',
  //     '2Chr': '2 Chronicles',
  //     'Ezra': 'Ezra',
  //     'Neh': 'Nehemiah',
  //     'Esth': 'Esther',
  //     'Job': 'Job',
  //     'Ps': 'Psalms',
  //     'Prov': 'Proverbs',
  //     'Eccl': 'Ecclesiastes',
  //     'Song': 'Song of Solomon',
  //     'Isa': 'Isaiah',
  //     'Jer': 'Jeremiah',
  //     'Lam': 'Lamentations',
  //     'Ezek': 'Ezekiel',
  //     'Dan': 'Daniel',
  //     'Hos': 'Hosea',
  //     'Joel': 'Joel',
  //     'Amos': 'Amos',
  //     'Obad': 'Obadiah',
  //     'Jona': 'Jonah',
  //     'Mic': 'Micah',
  //     'Nah': 'Nahum',
  //     'Hab': 'Habakkuk',
  //     'Zeph': 'Zephaniah',
  //     'Hag': 'Haggai',
  //     'Zech': 'Zechariah',
  //     'Mal': 'Malachi',
  //     'Matt': 'Matthew',
  //     'Mark': 'Mark',
  //     'Luke': 'Luke',
  //     'John': 'John',
  //     'Acts': 'Acts of the Apostles',
  //     'Rom': 'Romans',
  //     '1Cor': '1 Corinthians',
  //     '2Cor': '2 Corinthians',
  //     'Gal': 'Galatians',
  //     'Eph': 'Ephesians',
  //     'Phil': 'Philippians',
  //     'Col': 'Colossians',
  //     '1Thess': '1 Thessalonians',
  //     '2Thess': '2 Thessalonians',
  //     '1Tim': '1 Timothy',
  //     '2Tim': '2 Timothy',
  //     'Titus': 'Titus',
  //     'Phlm': 'Philemon',
  //     'Heb': 'Hebrews',
  //     'Jas': 'James',
  //     '1Pet': '1 Peter',
  //     '2Pet': '2 Peter',
  //     '1John': '1 John',
  //     '2John': '2 John',
  //     '3John': '3 John',
  //     'Jude': 'Jude',
  //     'Rev': 'Revelation',
  //   };
  // }

  List<TranslationDto> getTranslations() {
    final translationBox = _store.box<TranslationDto>();
    final listFromDB = translationBox.getAll();

    if (listFromDB.isEmpty) {
      return [TranslationDto(abbreviation: 'kjv', name: 'King James Version')];
    } else {
      return listFromDB;
    }
  }

  List<VerseDto> getVerses({
    required String book,
    required int chapter,
    required String translation,
  }) {
    final verseBox = _store.box<VerseDto>();

    final builder = verseBox.query(
      VerseDto_.book.equals(book) &
          VerseDto_.chapter.equals(chapter) &
          VerseDto_.translation.equals(translation),
    );

    final verseDtos = builder.build().find();
    return verseDtos;
  }

  VerseDto? getVerse({
    required String book,
    required int chapter,
    required int verse,
    required String translation,
  }) {
    final bibleBox = _store.box<VerseDto>();

    final builder = bibleBox.query(
      VerseDto_.verse.equals(verse) &
          VerseDto_.chapter.equals(chapter) &
          VerseDto_.book.equals(book) &
          VerseDto_.translation.equals(translation),
    );

    Query<VerseDto> query = builder.build();
    final verseDto = query.findFirst();

    return verseDto;
  }

  ChapterDto? getChapter({
    required String book,
    required int chapter,
    required String translation,
  }) {
    final bibleBox = _store.box<VerseDto>();

    final reference = '$book + $chapter';

    final builder = bibleBox.query(
      VerseDto_.chapter.equals(chapter) &
          VerseDto_.book.equals(book) &
          VerseDto_.translation.equals(translation),
    );

    final verses = builder.build().find();

    final chapterDto = ChapterDto(
      id: chapter,
      reference: reference,
      verses: verses,
    );

    return chapterDto;
  }

  Future<void> storeBible(int id, List<VerseDto> verses) {
    return _objectBox.storeBible(id, verses);
  }

  Future<void> storeTranslations(int id, List<TranslationDto> translations) {
    return _objectBox.storeTranslations(id, translations);
  }

  Future<List<VerseDto>> loadFallbackBible() async {
    RootIsolateToken rIToken = RootIsolateToken.instance!;
    final verses = await Isolate.run(() => _loadJSONAsset(rIToken));
    return verses;
  }

  static Future<List<VerseDto>> _loadJSONAsset(RootIsolateToken token) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    final jsonStr = await rootBundle.loadString('assets/bibles/kjv.json');

    final data = jsonDecode(jsonStr)['data'] as List<dynamic>;
    final versesData = data.cast<Map<String, dynamic>>();

    final verses = versesData
        .map((v) =>
            VerseDto.fromJson(v).copyWith(id: v['index'], translation: 'kjv'))
        .toList();

    return verses;
  }
}
