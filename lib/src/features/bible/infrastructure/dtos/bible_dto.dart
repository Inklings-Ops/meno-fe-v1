import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

import '../../domain/entities/bible.dart';
import 'verse_dto.dart';

part 'bible_dto.freezed.dart';

@Freezed(addImplicitFinal: false)
class BibleDto with _$BibleDto {
  @Entity(realClass: BibleDto)
  factory BibleDto({
    @Id() int? id,
    @Unique() required String translation,
    required ToMany<VerseDto> verses,
  }) = _BibleDto;
}

extension BibleDtoX on BibleDto {
  Bible get toDomain {
    return Bible(
      id: id,
      translation: translation,
      verses: verses.map((verse) => verse.toDomain).toList(),
    );
  }
}
