import 'package:freezed_annotation/freezed_annotation.dart';

import 'verse.dart';

part 'chapter.freezed.dart';

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    int? id,
    required String book,
    required List<Verse> verses,
  }) = _Chapter;
}
