import 'package:equatable/equatable.dart';

mixin Paged<T> {
  List<T?> get items;

  int get totalPages;

  int get totalItems;

  int get currentPage;
}

final class PagedList<T> with EquatableMixin, Paged<T> {
  const PagedList({
    required this.items,
    required this.currentPage,
    required this.totalItems,
    required this.totalPages,
  });

  @override
  final List<T?> items;

  @override
  final int currentPage;

  @override
  final int totalItems;

  @override
  final int totalPages;

  @override
  List<Object?> get props => [items, currentPage, totalItems, totalPages];
}
