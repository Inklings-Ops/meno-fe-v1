import 'package:equatable/equatable.dart';

import 'package:meno_fe_v1/src/features/bible/domain/entities/chapter.dart';

final class Book with EquatableMixin {
  const Book({required this.name, required this.chapters, this.id});

  final String name;
  final List<Chapter> chapters;
  final int? id;

  @override
  List<Object?> get props => [name, chapters, id];
}
