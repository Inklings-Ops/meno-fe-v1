import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meno_fe_v1/src/features/bible/domain/entities/bible.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/verse_dto.dart';
import 'package:objectbox/objectbox.dart';

part 'bible_dto.freezed.dart';

@Freezed(addImplicitFinal: false)
class BibleDto with _$BibleDto {
  @Entity(realClass: BibleDto)
  factory BibleDto({
    @Unique() required String translation,
    required ToMany<VerseDto> verses,
    @Id() int? id,
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
