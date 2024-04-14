import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';

@freezed
class Book with _$Book {
  factory Book({
    required String name,
    required int numberOfChapters,
  }) = _Book;
}
