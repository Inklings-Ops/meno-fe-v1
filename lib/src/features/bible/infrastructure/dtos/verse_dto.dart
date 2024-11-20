// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/bible/domain/entities/verse.dart';
import 'package:objectbox/objectbox.dart';

part 'verse_dto.freezed.dart';
part 'verse_dto.g.dart';

@Freezed(addImplicitFinal: false)
@JsonSerializable(createFactory: false)
class VerseDto with _$VerseDto {
  @Entity(realClass: VerseDto)
  factory VerseDto({
    @JsonKey(name: 'book_id') required String book,
    @JsonKey(name: 'book_name') required String bookName,
    required int chapter,
    required String text,
    required int verse,
    @Id(assignable: true) int? id,
    String? translation,
  }) = _VerseDto;

  factory VerseDto.fromJson(Map<String, dynamic> json) =>
      _$VerseDtoFromJson(json);

  factory VerseDto.fromJsonWithTrans(Map<String, dynamic> json, String trans) {
    final decodedVerseDto = _$VerseDtoFromJson(json);
    return decodedVerseDto.copyWith(translation: trans);
  }

  @override
  Map<String, dynamic> toJson() => _$VerseDtoToJson(this);
}

extension VerseDtoX on VerseDto {
  Verse get toDomain {
    return Verse(
      id: id,
      book: book,
      bookName: bookName,
      chapter: chapter,
      text: text,
      verse: verse,
      translation: translation,
    );
  }
}
