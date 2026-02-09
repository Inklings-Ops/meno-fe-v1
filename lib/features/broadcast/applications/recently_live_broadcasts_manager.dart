import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

class RecentlyLiveBroadcastsManager with Disposable {
  RecentlyLiveBroadcastsManager(this._repository) {
    getBroadcasts.run(true);
  }

  final IBroadcastRepository _repository;

  final broadcasts = ValueNotifier<PagedList<Broadcast?>>(PagedList.empty());

  late final getBroadcasts = Command.createAsyncNoResult((bool refresh) async {
    final page = refresh ? 1 : broadcasts.value.currentPage + 1;
    final pageParams = PaginationParams(page: page);
    final queryParameters = BroadcastQuery.recent(pagination: pageParams);
    final result = await _repository.getBroadcasts(queryParameters);
    result.fold((error) => throw error, (newPage) {
      broadcasts.value = broadcasts.value.merge(newPage, replace: refresh);
    });
  }, restriction: broadcasts.map((state) => !state.hasMore));

  // Helper for UI to know if we can load more (for showing spinner at bottom)
  bool get canLoadMore =>
      broadcasts.value.hasMore && !getBroadcasts.isRunning.value;

  @override
  FutureOr<dynamic> onDispose() {
    broadcasts.dispose();
    getBroadcasts.dispose();
  }
}
