import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/core/network/domain/i_network_facade.dart';
import 'package:meno_fe_v1/src/core/network/domain/network_status.dart';

@lazySingleton
class NetworkCubit extends Cubit<NetworkStatus> {
  NetworkCubit({
    required INetworkFacade facade,
  })  : _facade = facade,
        super(NetworkStatus.disconnected) {
    _subscription = _facade.onStatusChange.listen(emit);
  }
  final INetworkFacade _facade;
  late StreamSubscription<NetworkStatus> _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
