import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart' show Id, menoExceptionFilter;
import 'package:meno/features/broadcast/broadcast.dart';

final class BroadcastDetailsManager implements Disposable {
  BroadcastDetailsManager(this._http, this._broadcastId);

  final BroadcastHttpService _http;
  final Id _broadcastId;

  final _broadcast = ValueNotifier<Broadcast?>(null);
  ValueListenable<Broadcast?> get broadcast => _broadcast;

  late final fetch = Command.createAsyncNoParamNoResult(() async {
    final result = await _http.getBroadcast(_broadcastId);
    _broadcast.value = result;
  }, errorFilterFn: menoExceptionFilter);

  @override
  FutureOr<dynamic> onDispose() {
    _broadcast.dispose();
    fetch.dispose();
  }
}
