import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required List<String> name,
    required int numberOfChapters,
  }) = _Book;

  factory Book.empty() =>
      const Book(name: ['Gen', 'Genesis'], numberOfChapters: 50);
}
