import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

import '../../domain/entities/verse.dart';

part 'verse_dto.freezed.dart';
part 'verse_dto.g.dart';

@Freezed(addImplicitFinal: false)
@JsonSerializable(createFactory: false)
class VerseDto with _$VerseDto {
  @Entity(realClass: VerseDto)
  factory VerseDto({
    @Id(assignable: true) int? id,
    @JsonKey(name: 'book_id') required String book,
    @JsonKey(name: 'book_name') required String bookName,
    required int chapter,
    required String text,
    required int verse,
  }) = _VerseDto;

  factory VerseDto.fromJson(Map<String, dynamic> json) =>
      _$VerseDtoFromJson(json);

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
    );
  }
}
