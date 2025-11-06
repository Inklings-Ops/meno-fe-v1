import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_domain/src/models/bible/verse.dart';

part 'chapter.freezed.dart';

part 'chapter.g.dart';

/// Represents a single chapter of a book in the Bible.
///
/// This class is an immutable data object that aggregates a list of [Verse]
/// objects belonging to the same chapter and book.
///
/// It uses the `freezed` package to generate boilerplate code for immutability,
/// equality, and other common object methods.
@freezed
abstract class Chapter with _$Chapter {
  /// Creates an instance of a [Chapter].
  ///
  /// The constructor is marked as `const` to allow for compile-time
  /// constant creation where possible.
  const factory Chapter({
    /// A unique identifier for the book this chapter belongs to (e.g., "GEN").
    required String book,

    /// A list of [Verse] objects that make up the content of this chapter.
    required List<Verse> verses,
  }) = _Chapter;

  /// A factory constructor to create a [Chapter] instance from a JSON map.
  ///
  /// This is used for deserializing chapter data, which typically includes
  /// a nested list of verses, from a network response or local database.
  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}
