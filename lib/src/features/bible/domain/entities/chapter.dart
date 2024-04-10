import 'package:freezed_annotation/freezed_annotation.dart';

import 'verse.dart';

part 'chapter.freezed.dart';

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required String reference,
    required List<Verse> verses,
  }) = _Chapter;

  factory Chapter.empty() => const Chapter(reference: 'Genesis 1', verses: []);
}
