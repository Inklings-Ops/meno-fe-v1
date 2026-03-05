import 'package:equatable/equatable.dart';
import 'package:meno/features/bible/model/entities/verse.dart';

final class Chapter with EquatableMixin {
  const Chapter({required this.book, required this.verses, this.id});

  final String book;
  final List<Verse> verses;
  final int? id;

  @override
  List<Object?> get props => [book, verses, id];
}
