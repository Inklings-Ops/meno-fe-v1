import 'package:freezed_annotation/freezed_annotation.dart';

part 'verse.freezed.dart';

@freezed
class Verse with _$Verse {
  const factory Verse({
    int? id,
    required String bookName,
    required int book,
    required int chapter,
    required int verse,
    required String text,
    String? reference,
    String? translation,
    required bool isHighlighted,
    required int highlightColor,
  }) = _Verse;
}
