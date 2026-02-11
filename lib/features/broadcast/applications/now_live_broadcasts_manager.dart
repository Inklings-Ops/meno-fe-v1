import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

class NowLiveBroadcastsManager implements Disposable {
  NowLiveBroadcastsManager(this._repository);

  final IBroadcastRepository _repository;

  late final broadcasts = ListNotifier<Broadcast?>();

  late final fetch = Command.createAsyncNoParamNoResult(() async {
    final queryParameters = BroadcastQuery.nowLive();
    final result = await _repository.getBroadcasts(queryParameters);
    result.fold((error) => throw error, (page) {
      broadcasts.startTransAction();
      broadcasts.addAll(page.items);
      broadcasts.endTransAction();
    });
  });

  @override
  FutureOr<dynamic> onDispose() {
    broadcasts.dispose();
    fetch.dispose();
  }
}
