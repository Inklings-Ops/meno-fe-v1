import 'package:equatable/equatable.dart';

mixin Paged<T> {
  List<T?> get items;
  int get totalPages;
  int get totalItems;
  int get currentPage;

  bool get hasMore => currentPage < totalPages;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage >= totalPages;
  int get pageSize => items.length;
}

final class PagedList<T> with EquatableMixin, Paged<T> {
  const PagedList({
    required this.items,
    this.currentPage = 1,
    this.totalItems = 1,
    this.totalPages = 1,
  });

  const PagedList.empty()
    : items = const [],
      currentPage = 0,
      totalItems = 0,
      totalPages = 0;

  factory PagedList.single(List<T?> items) {
    return PagedList(items: items, totalItems: items.length);
  }

  factory PagedList.fromJson(
    dynamic json,
    T Function(Object? json) fromJsonT, {
    String listKey = 'items',
  }) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Invalid JSON');
    }
    final items = json[listKey] as List<dynamic>;
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

  PagedList<T> merge(PagedList<T> newPage) {
    if (newPage.isFirstPage) return newPage;
    if (items.isEmpty) return newPage;

    final mergedItems = <T?>[...items];
    for (final item in newPage.items) {
      if (!mergedItems.contains(item)) mergedItems.add(item);
    }

    return PagedList(
      items: mergedItems,
      currentPage: newPage.currentPage,
      totalItems: newPage.totalItems,
      totalPages: newPage.totalPages,
    );
  }

  PagedList<R> map<R>(R? Function(T? item) mapper) {
    return PagedList<R>(
      items: items.map(mapper).toList(),
      currentPage: currentPage,
      totalItems: totalItems,
      totalPages: totalPages,
    );
  }

  PagedList<T> where(bool Function(T? item) predicate) {
    final filteredItems = items.where(predicate).toList();
    return PagedList(
      items: filteredItems,
      currentPage: currentPage,
      totalItems: filteredItems.length,
      totalPages: totalPages,
    );
  }

  PagedList<T> copyWith({
    List<T?>? items,
    int? currentPage,
    int? totalItems,
    int? totalPages,
  }) {
    return PagedList<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
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

  List<T> get nonNullItems => items.whereType<T>().toList();

  @override
  List<Object?> get props => [items, currentPage, totalItems, totalPages];
}

extension PagedListExtensions<T> on PagedList<T> {
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  T? get firstOrNull => items.isEmpty ? null : items.first;
  T? get lastOrNull => items.isEmpty ? null : items.last;
  T? itemAt(int index) {
    if (index < 0 || index >= items.length) return null;
    return items[index];
  }
}
