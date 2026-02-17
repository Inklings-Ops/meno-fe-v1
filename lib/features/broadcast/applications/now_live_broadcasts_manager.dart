import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';

class NowLiveBroadcastsManager with MLogger implements Disposable {
  NowLiveBroadcastsManager(this._repository);

  final IBroadcastRepository _repository;

  final broadcasts = ValueNotifier<List<Broadcast>>([]);
  late final error = ValueNotifier<dynamic>(null);

  StreamSubscription<List<Broadcast>>? _subscription;

  late final initialize = Command.createAsyncNoParamNoResult(() async {
    // Cancel any existing subscription to avoid duplicate listeners
    await _subscription?.cancel();
    _subscription = null;

    _subscription = _repository.watchNowLiveBroadcasts.listen(
      (event) => broadcasts.value = event,
      onError: (dynamic e) {
        error.value = e.toString();
        log.e(e.toString());
      },
    );
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    _subscription?.cancel();
    broadcasts.dispose();
    error.dispose();
    initialize.dispose();
  }
}
