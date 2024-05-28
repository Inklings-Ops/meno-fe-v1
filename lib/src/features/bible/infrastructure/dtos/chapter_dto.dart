import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/chapter.dart';
import 'verse_dto.dart';

part 'chapter_dto.freezed.dart';

@freezed
class ChapterDto with _$ChapterDto {
  factory ChapterDto({
    int? id,
    required String book,
    required List<VerseDto> verses,
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
