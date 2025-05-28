import 'package:equatable/equatable.dart';

final class Verse with EquatableMixin {
  const Verse({
    required this.book,
    required this.bookName,
    required this.chapter,
    required this.text,
    required this.verse,
    this.id,
    this.translation,
  });

  final String book;
  final String bookName;
  final int chapter;
  final String text;
  final int verse;
  final int? id;
  final String? translation;

  @override
  List<Object?> get props => [
        book,
        bookName,
        chapter,
        text,
        verse,
        id,
        translation,
      ];
}
