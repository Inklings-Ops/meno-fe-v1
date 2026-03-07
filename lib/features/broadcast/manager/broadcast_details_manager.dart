import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart' show Id, menoExceptionFilter;
import 'package:meno/features/broadcast/broadcast.dart';

final class BroadcastDetailsManager implements Disposable {
  BroadcastDetailsManager({
    required BroadcastHttpService http,
    required Id currentUserId,
    required Id broadcastId,
  }) : _http = http,
       _currentUserId = currentUserId,
       _broadcastId = broadcastId;

  final BroadcastHttpService _http;
  final Id _currentUserId;
  final Id _broadcastId;

  final _proxy = ValueNotifier<BroadcastProxy?>(null);

  ValueListenable<BroadcastProxy?> get proxy => _proxy;

  late final fetch = Command.createAsyncNoParamNoResult(() async {
    final result = await _http.getBroadcast(_broadcastId);
    if (_proxy.value == null) {
      _proxy.value = BroadcastProxy(result, _currentUserId);
    } else {
      _proxy.value?.broadcast = result;
    }
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    _proxy.value?.dispose();
    _proxy.dispose();
    fetch.dispose();
  }
}
