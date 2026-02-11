import 'package:equatable/equatable.dart';

/// Mixin providing pagination metadata
mixin Paged<T> {
  List<T?> get items;

  int get totalPages;

  int get totalItems;

  int get currentPage;

  /// Whether there are more pages to load
  bool get hasMore => currentPage < totalPages;

  /// Whether this is the first page
  bool get isFirstPage => currentPage == 1;

  /// Whether this is the last page
  bool get isLastPage => currentPage >= totalPages;

  /// Number of items in current page
  int get pageSize => items.length;
}

/// Immutable paged list with pagination metadata
final class PagedList<T> with EquatableMixin, Paged<T> {
  const PagedList({
    required this.items,
    this.currentPage = 1,
    this.totalItems = 1,
    this.totalPages = 1,
  });

  /// Creates an empty paged list
  const PagedList.empty()
    : items = const [],
      currentPage = 0,
      totalItems = 0,
      totalPages = 0;

  /// Creates a single page list (useful for testing)
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

  /// Merges this page with a new page (for infinite scroll)
  ///
  /// If [newPage] is the first page, replaces current data.
  /// Otherwise, appends new items to current items.
  PagedList<T> merge(PagedList<T> newPage) {
    // If new page is first page, replace entirely
    if (newPage.isFirstPage) return newPage;

    // If this is empty, just use new page
    if (items.isEmpty) return newPage;

    // Merge items, removing duplicates based on position
    final mergedItems = <T?>[...items];

    // Only add items that aren't already in the list
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

  /// Maps items to a different type
  PagedList<R> map<R>(R? Function(T? item) mapper) {
    return PagedList<R>(
      items: items.map(mapper).toList(),
      currentPage: currentPage,
      totalItems: totalItems,
      totalPages: totalPages,
    );
  }

  /// Filters items based on predicate
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

  /// Gets items without nulls
  List<T> get nonNullItems => items.whereType<T>().toList();

  @override
  List<Object?> get props => [items, currentPage, totalItems, totalPages];

  @override
  String toString() =>
      '''
PagedList(
  items: ${items.length} items,
  currentPage: $currentPage,
  totalItems: $totalItems,
  totalPages: $totalPages,
  hasMore: $hasMore
)''';
}

/// Extension methods for common paged list operations
extension PagedListExtensions<T> on PagedList<T> {
  /// Whether the list is empty
  bool get isEmpty => items.isEmpty;

  /// Whether the list is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Gets the first item (if any)
  T? get firstOrNull => items.isEmpty ? null : items.first;

  /// Gets the last item (if any)
  T? get lastOrNull => items.isEmpty ? null : items.last;

  /// Gets item at index (if valid)
  T? itemAt(int index) {
    if (index < 0 || index >= items.length) return null;
    return items[index];
  }

  /// Converts to a simple list
  List<T?> toList() => List.unmodifiable(items);

  /// Converts to list of non-null items
  List<T> toNonNullList() => List.unmodifiable(nonNullItems);
}

/// Helper for creating PagedList from API responses
class PagedListBuilder<T> {
  PagedListBuilder({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  final int currentPage;
  final int totalPages;
  final int totalItems;
  final List<T?> _items = [];

  /// Adds an item to the list
  void add(T? item) {
    _items.add(item);
  }

  /// Adds multiple items to the list
  void addAll(Iterable<T?> items) {
    _items.addAll(items);
  }

  /// Builds the PagedList
  PagedList<T> build() {
    return PagedList(
      items: List.unmodifiable(_items),
      currentPage: currentPage,
      totalItems: totalItems,
      totalPages: totalPages,
    );
  }
}
