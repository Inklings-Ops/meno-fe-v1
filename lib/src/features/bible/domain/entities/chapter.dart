import 'package:equatable/equatable.dart';

import 'package:meno_fe_v1/src/features/bible/domain/entities/verse.dart';

final class Chapter with EquatableMixin {
  const Chapter({
    required this.book,
    required this.verses,
    this.id,
  });

  final String book;
  final List<Verse> verses;
  final int? id;

  @override
  List<Object?> get props => [book, verses, id];
}
