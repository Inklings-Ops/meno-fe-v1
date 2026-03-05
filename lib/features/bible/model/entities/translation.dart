import 'package:equatable/equatable.dart';

final class Translation with EquatableMixin {
  const Translation({
    required this.name,
    required this.abbreviation,
    this.id,
    this.downloaded = false,
    this.available = false,
  });

  /// Resolves the display name from [abbreviation].
  /// Falls back gracefully if the abbreviation is unknown.
  factory Translation.fromAbbreviation(
    String abbreviation, {
    bool downloaded = true,
    bool available = true,
  }) {
    return Translation(
      abbreviation: abbreviation,
      name: translationNames[abbreviation] ?? abbreviation.toUpperCase(),
      downloaded: downloaded,
      available: available,
    );
  }

  final String name;
  final String abbreviation;
  final int? id;
  final bool downloaded;
  final bool available;

  @override
  List<Object?> get props => [name, abbreviation, id, downloaded, available];
}

const translationNames = <String, String>{
  'kjv': 'King James Version',
  'nkjv': 'New King James Version',
  'niv': 'New International Version',
  'esv': 'English Standard Version',
  'amp': 'Amplified Bible',
  'asv': 'American Standard Version',
  'ylt': "Young's Literal Translation",
};
