import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';

/// Base feed for finite data sets (non-paged)
abstract class FeedDataSource<TItem> implements Disposable {
  FeedDataSource({List<TItem>? initialItems}) : items = initialItems ?? [];

  final List<TItem> items;

  final _itemCount = ValueNotifier<int>(0);

  ValueListenable<int> get itemCount => _itemCount;

  bool updateWasCalled = false;

  late final updateDataCommand = Command.createAsyncNoParamNoResult(() async {
    await updateFeedData();
    updateWasCalled = true;
    refreshItemCount();
  }, errorFilterFn: menoExceptionFilter);

  ValueListenable<bool> get isFetching => updateDataCommand.isRunning;

  ValueListenable<CommandError?> get commandErrors => updateDataCommand.errors;

  /// Subclasses implement - fetch data and populate items list
  Future<void> updateFeedData();

  /// Subclasses implement - compare items for deduplication
  bool itemsAreEqual(TItem item1, TItem item2);

  TItem getItemAtIndex(int index) {
    assert(index >= 0 && index < items.length, 'Index $index out of range');
    return items[index];
  }

  void refreshItemCount() => _itemCount.value = items.length;

  void addItemAtStart(TItem item) {
    items.insert(0, item);
    refreshItemCount();
  }

  void removeObject(TItem itemToRemove) {
    items.removeWhere((item) => itemsAreEqual(item, itemToRemove));
    refreshItemCount();
  }

  void reset() {
    items.clear();
    updateWasCalled = false;
    refreshItemCount();
  }

  @override
  void onDispose() {
    _itemCount.dispose();
    updateDataCommand.dispose();
  }
}

/// Extends FeedDataSource with pagination support
abstract class PagedFeedDataSource<TItem> extends FeedDataSource<TItem> {
  PagedFeedDataSource({super.initialItems}) {
    // Merge both commands' isRunning into a single isFetching notifier.
    updateDataCommand.isRunning.addListener(_syncFetching);
    requestNextPageCommand.isRunning.addListener(_syncFetching);
  }

  int _currentPage = 1;
  int _totalPages = 1;

  bool get hasNextPage => _currentPage < _totalPages;

  late final requestNextPageCommand = Command.createAsyncNoParamNoResult(
    () async {
      await requestNextPage();
      refreshItemCount();
    },
    errorFilterFn: menoExceptionFilter,
    restriction: ValueNotifier(false),
  );

  /// Subclasses implement - fetch next page and append to items
  Future<void> requestNextPage();

  /// Update pagination state from response
  void updatePaginationState({
    required int currentPage,
    required int totalPages,
  }) {
    _currentPage = currentPage;
    _totalPages = totalPages;
  }

  int get nextPageIndex => _currentPage + 1;

  @override
  TItem getItemAtIndex(int index) {
    if (index >= items.length - 3 &&
        commandErrors.value == null &&
        hasNextPage &&
        !requestNextPageCommand.isRunning.value) {
      requestNextPageCommand.run();
    }
    return super.getItemAtIndex(index);
  }

  @override
  ValueListenable<bool> get isFetching => _isFetching;

  late final _isFetching = ValueNotifier<bool>(false);

  // Initializing logic to sync isFetching with both commands
  void initFetchingSync() {
    updateDataCommand.isRunning.addListener(_syncFetching);
    requestNextPageCommand.isRunning.addListener(_syncFetching);
  }

  void _syncFetching() {
    _isFetching.value =
        updateDataCommand.isRunning.value ||
        requestNextPageCommand.isRunning.value;
  }

  @override
  void reset() {
    _currentPage = 1;
    _totalPages = 1;
    super.reset();
  }

  @override
  void onDispose() {
    updateDataCommand.isRunning.removeListener(_syncFetching);
    requestNextPageCommand.isRunning.removeListener(_syncFetching);
    requestNextPageCommand.dispose();
    _isFetching.dispose();
    super.onDispose();
  }
}
