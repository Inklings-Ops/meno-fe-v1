import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:meno_fe_v1/src/features/bible/domain/entities/chapter.dart';

part 'book.freezed.dart';

@freezed
class Book with _$Book {
  factory Book({
    required String name, required List<Chapter> chapters, int? id,
  }) = _Book;
}
