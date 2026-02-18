// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:meno/features/bible/domain/entities/verse.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class VerseDto with EquatableMixin {
  VerseDto({
    required this.book,
    required this.bookName,
    required this.chapter,
    required this.text,
    required this.verse,
    this.id,
    this.translation,
  });

  factory VerseDto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid verse JSON');
    }

    return VerseDto(
      id: (json[_kId] as num?)?.toInt(),
      book: json[_kBook] as String,
      bookName: json[_kBookName] as String,
      chapter: (json[_kChapter] as num).toInt(),
      text: json[_kText] as String,
      verse: (json[_kVerse] as num).toInt(),
      translation: json[_kTranslation] as String?,
    );
  }

  @Id(assignable: true)
  int? id;

  final String book;
  final String bookName;
  final int chapter;
  final String text;
  final int verse;
  final String? translation;

  static const String _kId = 'id';
  static const String _kBook = 'book_id';
  static const String _kBookName = 'book_name';
  static const String _kChapter = 'chapter';
  static const String _kText = 'text';
  static const String _kVerse = 'verse';
  static const String _kTranslation = 'translation';

  Map<String, dynamic> toJson() => {
    _kId: id,
    _kBook: book,
    _kBookName: bookName,
    _kChapter: chapter,
    _kText: text,
    _kVerse: verse,
    _kTranslation: translation,
  };

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
