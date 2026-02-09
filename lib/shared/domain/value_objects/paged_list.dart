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
    this.currentPage = 1,
    this.totalItems = 1,
    this.totalPages = 1,
  });

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

  static PagedList<T> empty<T>() => PagedList<T>(items: []);

  /// Merges a new page into the current list.
  ///
  /// [other] is the new page coming from the API.
  /// If [replace] is true (pull-to-refresh), we discard current items.
  PagedList<T> merge(PagedList<T> other, {bool replace = false}) {
    if (replace) return other;
    return PagedList<T>(
      items: [...items, ...other.items],
      currentPage: other.currentPage,
      totalItems: other.totalItems,
      totalPages: other.totalPages,
    );
  }

  /// Helper to check if we have reached the end
  bool get hasMore => currentPage < totalPages;

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

  @override
  List<Object?> get props => [items, currentPage, totalItems, totalPages];
}
