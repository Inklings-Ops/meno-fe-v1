import 'package:equatable/equatable.dart';

final class Translation with EquatableMixin {
  const Translation({
    required this.name,
    required this.abbreviation,
    this.id,
    this.downloaded = false,
  });

  factory Translation.fromAbbreviation(String abbreviation) {
    return _handleTranslationsFromString(abbreviation);
  }

  final String name;
  final String abbreviation;
  final int? id;
  final bool downloaded;

  @override
  List<Object?> get props => [name, abbreviation, id, downloaded];
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
