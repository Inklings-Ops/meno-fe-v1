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

  factory PagedList.fromJson(dynamic json, T Function(Object? json) fromJsonT) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid JSON');
    }
    final items = json['items'] as List<dynamic>;
    final currentPage = json['currentPage'] as int;
    final totalItems = json['totalItems'] as int;
    final totalPages = json['totalPages'] as int;

    return PagedList(
      items: items.isNotEmpty ? items.map(fromJsonT).toList() : const [],
      currentPage: currentPage,
      totalItems: totalItems,
      totalPages: totalPages,
    );
  }

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
