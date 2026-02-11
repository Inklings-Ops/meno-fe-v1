import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart' show menoExceptionFilter;
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

class RecentlyLiveBroadcastsManager implements Disposable {
  RecentlyLiveBroadcastsManager(this._repository);

  final IBroadcastRepository _repository;

  late final broadcasts = ListNotifier<Broadcast?>();

  StreamSubscription<EndedBroadcast>? _subscription;

  late final fetch = Command.createAsyncNoParamNoResult(() async {
    final queryParameters = BroadcastQuery.recentlyLive();
    final result = await _repository.getBroadcasts(queryParameters);
    result.fold((error) => throw error, (page) {
      broadcasts.startTransAction();
      broadcasts.addAll(page.items);
      broadcasts.endTransAction();
    });
  }, errorFilterFn: menoExceptionFilter);

  late final initialize = Command.createAsyncNoParamNoResult(() async {
    _subscription = _repository.onBroadcastEnded.listen((event) {
      final incomingBroadcast = event.details;
      final exists = broadcasts.any((e) => e?.id == incomingBroadcast.id);
      if (!exists) {
        broadcasts.insert(0, incomingBroadcast);
        if (broadcasts.length > 20) broadcasts.removeLast();
      }
    });
  }, errorFilterFn: menoExceptionFilter)..pipeToCommand(fetch);

  @override
  FutureOr<dynamic> onDispose() {
    broadcasts.dispose();
    fetch.dispose();
    initialize.dispose();
    _subscription?.cancel();
  }
}
