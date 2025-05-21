import 'package:equatable/equatable.dart';
mixin Paginated<T> {
  List<T?> get items;
  int get totalPages;
  int get totalItems;
  int get currentPage;
}

final class PaginatedList<T> with EquatableMixin, Paginated<T> {
  const PaginatedList({
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

  @override
  bool? get stringify => true;
}
