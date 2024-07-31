import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/bible/domain/entities/verse.dart';

part 'bible.freezed.dart';

@freezed
class Bible with _$Bible {
  factory Bible({
    required String translation, required List<Verse> verses, int? id,
  }) = _Bible;
}
