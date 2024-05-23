import 'package:freezed_annotation/freezed_annotation.dart';

import 'chapter.dart';

part 'book.freezed.dart';

@freezed
class Book with _$Book {
  factory Book({
    int? id,
    required String name,
    required List<Chapter> chapters,
  }) = _Book;
}
