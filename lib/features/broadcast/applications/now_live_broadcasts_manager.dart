import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

class NowLiveBroadcastsManager with MLogger implements Disposable {
  NowLiveBroadcastsManager(this._repository);

  final IBroadcastRepository _repository;

  final broadcasts = ListNotifier<Broadcast?>(data: []);
  late final error = ValueNotifier<dynamic>(null);

  StreamSubscription<Broadcast>? _startedSubscription;
  StreamSubscription<EndedBroadcast>? _endedSubscription;

  late final initialize = Command.createAsyncNoParamNoResult(() async {
    // Cancel existing socket subscriptions before re-subscribing
    await _startedSubscription?.cancel();
    await _endedSubscription?.cancel();
    error.value = null;

    _startedSubscription = _repository.onBroadcastStarted.listen((incoming) {
      final exists = broadcasts.any((b) => b?.id == incoming.id);
      if (!exists) broadcasts.insert(0, incoming);
    });

    _endedSubscription = _repository.onBroadcastEnded.listen((ended) {
      broadcasts.removeWhere((b) => b?.id != ended.details.id);
    });

    final result = await _repository.getBroadcasts(BroadcastQuery.nowLive());

    result.fold(
      (failure) {
        error.value = failure;
        throw failure;
      },
      (page) {
        broadcasts.startTransAction();
        broadcasts.clear();
        broadcasts.addAll(page.items);
        broadcasts.endTransAction();
      },
    );
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() async {
    await _startedSubscription?.cancel();
    await _endedSubscription?.cancel();

    _startedSubscription = null;
    _endedSubscription = null;

    broadcasts.dispose();
    error.dispose();

    initialize.dispose();
  }
}
