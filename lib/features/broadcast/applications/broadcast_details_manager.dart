import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/broadcast/domain/domain.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class BroadcastDetailsManager with Disposable {
  BroadcastDetailsManager({
    required IBroadcastRepository repository,
    required Id broadcastId,
  }) : _repository = repository,
       _broadcastId = broadcastId;

  final IBroadcastRepository _repository;
  final Id _broadcastId;

  final broadcast = ValueNotifier<Broadcast>(.empty);

  late final fetch = Command.createAsyncNoParamNoResult(() async {
    final result = await _repository.getBroadcast(_broadcastId);
    result.fold(
      (failure) => throw failure,
      (success) => broadcast.value = success,
    );
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    broadcast.dispose();
    fetch.dispose();
  }
}
