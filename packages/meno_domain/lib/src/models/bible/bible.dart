import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_domain/src/models/bible/verse.dart';

part 'bible.freezed.dart';

part 'bible.g.dart';

/// Represents a collection of Bible verses from a specific translation.
@freezed
abstract final class Bible with _$Bible {
  /// Creates a [Bible] object.
  const factory Bible({
    /// The translation of the Bible.
    required String translation,

    /// The list of verses.
    required List<Verse> verses,
  }) = _Bible;

  /// Creates a [Bible] object from a JSON object.
  factory Bible.fromJson(Map<String, dynamic> json) => _$BibleFromJson(json);
}
