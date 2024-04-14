import 'package:freezed_annotation/freezed_annotation.dart';

import 'verse.dart';

part 'chapter.freezed.dart';

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required int id,
    required String reference,
    required List<Verse> verses,
  }) = _Chapter;
}
