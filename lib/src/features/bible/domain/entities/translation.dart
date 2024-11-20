import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation.freezed.dart';

@freezed
class Translation with _$Translation {
  const factory Translation({
    required String name,
    required String abbreviation,
    int? id,
    @Default(false) bool downloaded,
  }) = _Translation;

  factory Translation.fromAbbreviation(String abbreviation) {
    return _handleTranslationsFromString(abbreviation);
  }
}

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
      _ => Translation(
          abbreviation: abb,
          name: 'Unknown Version',
          downloaded: true,
        ),
    };
