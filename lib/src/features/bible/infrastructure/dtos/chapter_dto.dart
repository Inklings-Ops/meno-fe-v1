import 'package:equatable/equatable.dart';
import 'package:meno_fe_v1/src/features/bible/domain/entities/chapter.dart';
import 'package:meno_fe_v1/src/features/bible/infrastructure/dtos/verse_dto.dart';

final class ChapterDto with EquatableMixin {
  const ChapterDto({required this.book, required this.verses, this.id});

  final int? id;
  final String book;
  final List<VerseDto> verses;

  @override
  List<Object?> get props => [id, book, verses];

  ChapterDto copyWith({
    int? id,
    String? book,
    List<VerseDto>? verses,
  }) {
    return ChapterDto(
      id: id ?? this.id,
      book: book ?? this.book,
      verses: verses ?? this.verses,
    );
  }
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
