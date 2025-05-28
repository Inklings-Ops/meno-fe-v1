import 'package:dartz/dartz.dart';
import 'package:meno_fe_v1/src/core/core.dart' show BibleException;
import 'package:meno_fe_v1/src/features/bible/domain/entities/entities.dart';

/// The [IBibleFacade] abstract class is a contract that defines methods and
/// properties
/// for interacting with a Bible API. It contains methods to retrieve books
/// of the Bible, translations available, and individual chapters and verses.
abstract class IBibleFacade {
  bool get isBibleEmpty;

  /// A Map of the Bible books to each of their individual chapters.
  Map<String, int> get books;

  /// A list of [Translation] objects representing all available translations
  /// of the Bible
  List<Translation> get storedTranslations;

  List<Translation> get otherTranslations;

  /// Retrieves a [Chapter] object representing the specified chapter of a book
  /// in a given translation.
  ///
  /// [book] - An String representing the ID of the book to retrieve the
  /// chapter from.
  /// [chapter] - An integer representing the ID of the chapter to retrieve.
  /// [translation] - A string representing the name of the translation to use.
  // Future<Chapter> getChapter(int bookId, int chapterId, String translation);
  Chapter getChapter({
    required String book,
    required int chapter,
    required String translation,
  });

  /// Retrieves a [Verse] object representing the specified verse of a chapter
  /// in a book in a given translation.
  ///
  /// [book] - An String representing the ID of the book to retrieve the verse
  /// from.
  /// [chapter] - An integer representing the ID of the chapter to retrieve the
  /// verse from.
  /// [verse] - An integer representing the ID of the verse to retrieve.
  /// [translation] - A string representing the name of the translation to use.
  Verse? getVerse({
    required String book,
    required int chapter,
    required int verse,
    required String translation,
  });

  /// Retrieves a list of [Verse] objects from a specified chapter in a book in
  /// a given translation.
  ///
  /// [book] - A String representing the ID of the book to retrieve the verse
  /// from.
  /// [chapter] - An integer representing the ID of the chapter to retrieve the
  /// verse from.
  /// [translation] - A string representing the name of the translation to use.
  List<Verse> getVerses({
    required String book,
    required int chapter,
    required String translation,
  });

  /// Calls the remote data source to download the full Bible data if there is
  /// an update available,
  /// or if prompted by the user.
  Future<Either<BibleException, Translation>> downloadBible(String translation);

  void cancelDownload();

  /// A Stream that exposes the download progress of the Bible
  Stream<int> get downloadBibleProgress;

  Future<void> initialize();
}
