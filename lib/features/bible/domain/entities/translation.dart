import 'package:equatable/equatable.dart';

final class Translation with EquatableMixin {
  const Translation({
    required this.name,
    required this.abbreviation,
    this.id,
    this.downloaded = false,
  });

  /// Resolves the display name from [abbreviation].
  /// Falls back gracefully if the abbreviation is unknown.
  factory Translation.fromAbb(String abbreviation, {bool downloaded = true}) {
    return Translation(
      abbreviation: abbreviation,
      name: _kTranslationNames[abbreviation] ?? abbreviation.toUpperCase(),
      downloaded: downloaded,
    );
  }

  final String name;
  final String abbreviation;
  final int? id;
  final bool downloaded;

  @override
  List<Object?> get props => [name, abbreviation, id, downloaded];
}

/// Single source of truth for translation display names.
/// When the backend starts returning names, delete this map and
/// drive [Translation.fromAbb] from the API response instead.
const _kTranslationNames = <String, String>{
  'kjv': 'King James Version',
  'nkjv': 'New King James Version',
  'niv': 'New International Version',
  'esv': 'English Standard Version',
  'amp': 'Amplified Bible',
  'asv': 'American Standard Version',
  'ylt': "Young's Literal Translation",
};
