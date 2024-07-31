import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/bible/domain/entities/verse.dart';

part 'chapter.freezed.dart';

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required String book, required List<Verse> verses, int? id,
  }) = _Chapter;
}
