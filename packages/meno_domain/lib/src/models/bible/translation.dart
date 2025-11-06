import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation.freezed.dart';

/// Represents a specific version or translation of the Bible.
///
/// This class is an immutable data object that holds details about a Bible
/// translation, such as its full name and abbreviation
/// (e.g., "King James Version" and "KJV").
///
/// It uses the `freezed` package to generate boilerplate code for immutability,
/// equality, and other common object methods.
@freezed
abstract class Translation with _$Translation {
  /// Creates an instance of a Bible [Translation].
  ///
  /// The constructor is marked as `const` to allow for compile-time
  /// constant creation where possible.
  const factory Translation({
    /// The full, human-readable name of the translation
    /// (e.g., "New International Version").
    required String name,

    /// The common abbreviation for the translation (e.g., "NIV").
    required String abbreviation,

    /// A flag indicating whether the content for this translation has been
    /// downloaded for offline use. Defaults to `false`.
    @Default(false) bool downloaded,
  }) = _Translation; // Corrected from _Transaction

  /// A factory constructor to create a known [Translation] object
  /// from its abbreviation.
  ///
  /// This method looks up a hardcoded list of common translations
  /// and returns a pre-configured [Translation] object. If the abbreviation
  /// is not recognized, it returns a default "Unknown Version" instance.
  ///
  /// {@macro from_abbreviation_example}
  factory Translation.fromAbbreviation(String abbreviation) {
    return _handleTranslationsFromString(abbreviation);
  }
}

/// A private helper function that maps a string abbreviation to a
/// [Translation] object.
///
/// This uses a switch expression to efficiently look up and create a
/// corresponding [Translation] instance for a given abbreviation string.
Translation _handleTranslationsFromString(String abb) => switch (abb) {
  'asv' => Translation(
    abbreviation: abb,
    name: 'American Standard Version',
    downloaded: true,
  ),
  'ylt' => Translation(
    abbreviation: abb,
    name: "Young's Literal Translation",
    downloaded: true,
  ),
  'esv' => Translation(
    abbreviation: abb,
    name: 'English Standard Version',
    downloaded: true,
  ),
  'nkjv' => Translation(
    abbreviation: abb,
    name: 'New King James Version',
    downloaded: true,
  ),
  'amp' => Translation(
    abbreviation: abb,
    name: 'Amplified Bible',
    downloaded: true,
  ),
  'niv' => Translation(
    abbreviation: abb,
    name: 'New International Version',
    downloaded: true,
  ),
  'kjv' => Translation(
    abbreviation: abb,
    name: 'King James Version',
    downloaded: true,
  ),
  // For any unrecognized abbreviation, return a default object.
  _ => Translation(
    abbreviation: abb,
    name: 'Unknown Version',
  ),
};
