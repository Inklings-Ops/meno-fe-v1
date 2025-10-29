import 'package:freezed_annotation/freezed_annotation.dart';

part 'verse.freezed.dart';

part 'verse.g.dart';

/// Represents a single verse of the Bible.
///
/// This class is an immutable data object that holds the content and
/// contextual information for a specific Bible verse, such as the book,
/// chapter, verse number, and the text itself.
///
/// It uses the `freezed` package to generate boilerplate code for
/// immutability, equality, and other common object methods.
@freezed
abstract final class Verse with _$Verse {
  /// Creates an instance of a [Verse].
  ///
  /// The constructor is marked as `const` to allow for compile-time
  /// constant creation where possible.
  const factory Verse({
    /// A unique identifier for the book this verse belongs to (e.g., "GEN").
    required String book,

    /// The human-readable name of the book (e.g., "Genesis").
    required String bookName,

    /// The chapter number within the book where this verse is located.
    required int chapter,

    /// The actual text content of the verse.
    required String text,

    /// The verse number within the chapter.
    required int verse,

    /// The Bible translation this verse is from (e.g., "NIV", "KJV").
    String? translation,
  }) = _Verse;

  /// A factory constructor to create a [Verse] instance from a JSON map.
  ///
  /// This is used for deserializing verse data, typically from a network
  /// response or local database.
  factory Verse.fromJson(Map<String, dynamic> json) => _$VerseFromJson(json);
}
