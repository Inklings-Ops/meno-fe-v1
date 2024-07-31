import 'package:freezed_annotation/freezed_annotation.dart';

part 'verse.freezed.dart';

@freezed
class Verse with _$Verse {
  const factory Verse({
    required String book, required String bookName, required int chapter, required String text, required int verse, int? id,
    String? translation,
  }) = _Verse;
}
