import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/book.dart';

part 'book_dto.freezed.dart';

@freezed
class BookDto with _$BookDto {
  factory BookDto({
    required String name,
    required int numberOfChapters,
  }) = _BookDto;
}

extension BookDtoX on BookDto {
  Book get toDomain => Book(name: name, numberOfChapters: numberOfChapters);
}
