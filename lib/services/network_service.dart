import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meno_fe_v1/injector/injector.dart';

final networkProvider = StreamProvider<NetworkStatus>(
  (r) => di<NetworkService>().stream,
);

enum NetworkStatus { connected, disconnected }

@injectable
class NetworkService {
  final InternetConnectionChecker _connectivity;
  late StreamController<NetworkStatus> _controller;

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

  Stream<NetworkStatus> get stream => _controller.stream;

  Future<bool> get isConnected => _connectivity.hasConnection;

  void dispose() {
    _controller.close();
  }
}
