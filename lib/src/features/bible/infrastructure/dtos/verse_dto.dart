// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meno_fe_v1/src/features/bible/domain/entities/verse.dart';
import 'package:objectbox/objectbox.dart';

part 'verse_dto.g.dart';

@Entity()
@JsonSerializable()
final class VerseDto with EquatableMixin {
  VerseDto({
    required this.book,
    required this.bookName,
    required this.chapter,
    required this.text,
    required this.verse,
    this.id,
    this.translation,
  });

  factory VerseDto.fromJson(Map<String, dynamic> json) =>
      _$VerseDtoFromJson(json);

  factory VerseDto.fromJsonWithTrans(Map<String, dynamic> json, String trans) {
    final decodedVerseDto = _$VerseDtoFromJson(json);
    return decodedVerseDto.copyWith(translation: trans);
  }

  @Id(assignable: true)
  int? id;

  @JsonKey(name: 'book_id')
  final String book;

  @JsonKey(name: 'book_name')
  final String bookName;

  final int chapter;
  final String text;
  final int verse;
  final String? translation;

  VerseDto copyWith({
    int? id,
    String? book,
    String? bookName,
    int? chapter,
    String? text,
    int? verse,
    String? translation,
  }) {
    return VerseDto(
      id: id ?? this.id,
      book: book ?? this.book,
      bookName: bookName ?? this.bookName,
      chapter: chapter ?? this.chapter,
      text: text ?? this.text,
      verse: verse ?? this.verse,
      translation: translation ?? this.translation,
    );
  }

  Map<String, dynamic> toJson() => _$VerseDtoToJson(this);

  @override
  List<Object?> get props => [
        id,
        book,
        bookName,
        chapter,
        text,
        verse,
        translation,
      ];
}

extension VerseDtoX on VerseDto {
  Verse get toDomain {
    return Verse(
      id: id,
      book: book,
      bookName: bookName,
      chapter: chapter,
      text: text,
      verse: verse,
      translation: translation,
    );
  }
}
