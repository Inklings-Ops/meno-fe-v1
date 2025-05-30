import 'package:equatable/equatable.dart';

import 'package:meno_fe_v1/src/features/bible/domain/entities/book.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/chapter_dto.dart';

final class BookDto with EquatableMixin {
  const BookDto({
    required this.name,
    required this.chapters,
    this.id,
  });

  final int? id;
  final String name;
  final List<ChapterDto> chapters;

  BookDto copyWith({
    int? id,
    String? name,
    List<ChapterDto>? chapters,
  }) {
    return BookDto(
      id: id ?? this.id,
      name: name ?? this.name,
      chapters: chapters ?? this.chapters,
    );
  }

  @override
  List<Object?> get props => [id, name, chapters];
}

extension BookDtoX on BookDto {
  Book get toDomain {
    return Book(
      id: id,
      name: name,
      chapters: chapters.map((e) => e.toDomain).toList(),
    );
  }
}
