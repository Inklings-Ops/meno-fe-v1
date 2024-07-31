import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/bible/domain/entities/chapter.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/verse_dto.dart';

part 'chapter_dto.freezed.dart';

@freezed
class ChapterDto with _$ChapterDto {
  factory ChapterDto({
    required String book, required List<VerseDto> verses, int? id,
  }) = _ChapterDto;
}

extension ChapterDtoX on ChapterDto {
  Chapter get toDomain {
    return Chapter(
      id: id,
      book: book,
      verses: verses.map((verse) => verse.toDomain).toList(),
    );
  }
}
