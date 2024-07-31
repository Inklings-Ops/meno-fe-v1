import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/bible/domain/entities/book.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/chapter_dto.dart';

part 'book_dto.freezed.dart';

@freezed
class BookDto with _$BookDto {
  factory BookDto({
    required String name, required List<ChapterDto> chapters, int? id,
  }) = _BookDto;
}

extension BookDtoX on BookDto {
  Book get toDomain => Book(
        id: id,
        name: name,
        chapters: chapters.map((e) => e.toDomain).toList(),
      );
}
