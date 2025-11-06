import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_domain/src/models/bible/chapter.dart';

part 'book.freezed.dart';

part 'book.g.dart';

/// Represents a single book of the Bible.
///
/// This class is an immutable data object that aggregates a list of [Chapter]
/// objects belonging to the same book (e.g., Genesis, Psalms, Matthew).
///
/// It uses the `freezed` package to generate boilerplate code for immutability,
/// equality, and other common object methods.
@freezed
abstract class Book with _$Book {
  /// Creates an instance of a [Book].
  ///
  /// The constructor is marked as `const` to allow for compile-time
  /// constant creation where possible.
  const factory Book({
    /// The full, human-readable name of the book (e.g., "Genesis").
    required String name,

    /// A list of [Chapter] objects that make up the content of this book.
    required List<Chapter> chapters,
  }) = _Book;

  /// A factory constructor to create a [Book] instance from a JSON map.
  ///
  /// This is used for deserializing book data, which typically includes
  /// a nested list of chapters, from a network response or local database.
  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
