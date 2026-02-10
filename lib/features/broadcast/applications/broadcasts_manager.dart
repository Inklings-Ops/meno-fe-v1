import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

class BroadcastsManager with Disposable {
  BroadcastsManager({
    required BroadcastQuery query,
    required IBroadcastRepository repository,
  }) : _query = query,
       _repository = repository;

  final BroadcastQuery _query;
  final IBroadcastRepository _repository;

  // The State: Contains the List AND the Pagination Metadata
  final broadcasts = ValueNotifier<PagedList<Broadcast?>>(PagedList.empty());

  late final loadBroadcasts = Command.createAsync<BroadcastQuery?, void>(
    (query) async {
      final result = await _repository.getBroadcasts(query ?? _query);
      result.fold((error) => throw error, (newPage) {
        broadcasts.value = broadcasts.value.merge(newPage);
      });
    },
    initialValue: null,
    errorFilterFn: menoExceptionFilter,
  );

  // Helper for UI to know if we can load more (for showing spinner at bottom)
  bool get canLoadMore =>
      broadcasts.value.hasMore && !loadBroadcasts.isRunning.value;

  @override
  FutureOr<dynamic> onDispose() {
    broadcasts.dispose();
    loadBroadcasts.dispose();
  }
}
