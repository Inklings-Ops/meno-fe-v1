import 'package:freezed_annotation/freezed_annotation.dart';

part 'verse.freezed.dart';

@freezed
class Verse with _$Verse {
  const factory Verse({
    int? id,
    required String book,
    required String bookName,
    required int chapter,
    required String text,
    required String translation,
    required int verse,
  }) = _Verse;
}
