import 'package:freezed_annotation/freezed_annotation.dart';

import 'verse.dart';

part 'bible.freezed.dart';

@freezed
class Bible with _$Bible {
  factory Bible({
    int? id,
    required String translation,
    required List<Verse> verses,
  }) = _Bible;
}
