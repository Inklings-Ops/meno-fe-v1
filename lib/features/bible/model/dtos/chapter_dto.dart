import 'package:equatable/equatable.dart';
import 'package:meno/features/bible/model/dtos/verse_dto.dart';
import 'package:meno/features/bible/model/entities/chapter.dart';

final class ChapterDto with EquatableMixin {
  const ChapterDto({required this.book, required this.verses, this.id});

  final int? id;
  final String book;
  final List<VerseDto> verses;

  @override
  List<Object?> get props => [id, book, verses];

  ChapterDto copyWith({int? id, String? book, List<VerseDto>? verses}) {
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
      verses: verses.map((v) => v.toDomain).toList(),
    );
  }
}
