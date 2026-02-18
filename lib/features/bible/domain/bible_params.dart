import 'package:equatable/equatable.dart';

final class BibleParams with EquatableMixin {
  const BibleParams({
    this.book = 0,
    this.chapter = 1,
    this.verse,
    this.translation = 'kjv',
  });

  final int book;
  final int chapter;
  final String translation;
  final int? verse;

  @override
  List<Object?> get props => [book, chapter, verse, translation];
}
