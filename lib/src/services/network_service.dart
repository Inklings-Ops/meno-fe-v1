import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meno_fe_v1/src/core/network/domain/network_status.dart';

@injectable
class NetworkService {

  NetworkService(this._connectivity) {
    _controller = StreamController<NetworkStatus>();

    _connectivity.onStatusChange.listen((status) {
      final networkStatus = switch (status) {
        InternetConnectionStatus.connected => NetworkStatus.connected,
        InternetConnectionStatus.disconnected => NetworkStatus.disconnected,
      };
      _controller.add(networkStatus);
    });
  }
  final InternetConnectionChecker _connectivity;
  late StreamController<NetworkStatus> _controller;

  Stream<NetworkStatus> get stream => _controller.stream;

  Future<bool> get isConnected => _connectivity.hasConnection;

  void dispose() {
    _controller.close();
  }
}
