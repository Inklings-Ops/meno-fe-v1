import 'package:dartz/dartz.dart';

import 'entities/entities.dart';
import 'exceptions/exceptions.dart';

/// The [IBibleFacade] abstract class is a contract that defines methods and properties
/// for interacting with a Bible API. It contains methods to retrieve books of the Bible,
/// translations available, and individual chapters and verses.
abstract class IBibleFacade {
  /// A list of strings representing the names of all books in the Bible.
  List<String> get books;

  /// A list of [Translation] objects representing all available translations of the Bible
  List<Translation> get translations;

  /// A list of the chapter numbers for their corresponding Bible books.
  List<int> chapters(int book);

  /// Retrieves a [Chapter] object representing the specified chapter of a book in a given translation.
  ///
  /// [bookId] - An integer representing the ID of the book to retrieve the chapter from.
  /// [chapterId] - An integer representing the ID of the chapter to retrieve.
  /// [translation] - A string representing the name of the translation to use.
  // Future<Chapter> getChapter(int bookId, int chapterId, String translation);
  Future<Chapter?> getChapter({
    required int book,
    required int chapter,
    required String translation,
  });

  /// Retrieves a [Verse] object representing the specified verse of a chapter in a book in a given translation.
  ///
  /// [book] - An integer representing the ID of the book to retrieve the verse from.
  /// [chapter] - An integer representing the ID of the chapter to retrieve the verse from.
  /// [verse] - An integer representing the ID of the verse to retrieve.
  /// [translation] - A string representing the name of the translation to use.
  Verse? getVerse({
    required int book,
    required int chapter,
    required int verse,
    required String translation,
  });

  /// Retrieves a list of [Verse] objects from a specified chapter in a book in a given translation.
  ///
  /// [book] - An integer representing the ID of the book to retrieve the verse from.
  /// [chapter] - An integer representing the ID of the chapter to retrieve the verse from.
  /// [translation] - A string representing the name of the translation to use.
  Future<List<Verse?>> getVerses({
    required int book,
    required int chapter,
    required String translation,
  });

  /// Calls the remote data source to download the full Bible data if there is an update available,
  /// or if prompted by the user.
  Future<Either<BibleException, Unit>> sync();
}
