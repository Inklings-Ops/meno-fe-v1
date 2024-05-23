import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/book.dart';
import 'chapter_dto.dart';

part 'book_dto.freezed.dart';

@freezed
class BookDto with _$BookDto {
  factory BookDto({
    int? id,
    required String name,
    required List<ChapterDto> chapters,
  }) = _BookDto;
}

extension BookDtoX on BookDto {
  Book get toDomain => Book(
        id: id,
        name: name,
        chapters: chapters.map((e) => e.toDomain).toList(),
      );
}
