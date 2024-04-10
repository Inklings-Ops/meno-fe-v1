import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../domain/i_network_facade.dart';
import '../domain/network_status.dart';

part 'network_cubit.freezed.dart';
part 'network_state.dart';

@lazySingleton
class NetworkCubit extends Cubit<NetworkState> {
  final INetworkFacade _facade;
  late StreamSubscription<NetworkStatus> _subscription;

  NetworkCubit({
    required INetworkFacade facade,
  })  : _facade = facade,
        super(NetworkState.initial()) {
    _subscription = _facade.onStatusChange.listen(_handleNetworkChange2);
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    super.close();
  }

  void _handleNetworkChange2(NetworkStatus status) {
    emit(state.copyWith(status: status));
  }
}
