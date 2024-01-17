import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../domain/i_network_facade.dart';
import '../domain/network_status.dart';

/// Concrete implementation of the [INetworkFacade] that uses the
/// [InternetConnectionChecker] to monitor network connectivity.
@LazySingleton(as: INetworkFacade)
class NetworkFacade implements INetworkFacade {
  /// Manages platform-specific network connectivity checks.
  final InternetConnectionChecker _connectivity;

  /// Creates a new instance of [NetworkFacade].
  ///
  /// [connectivity]: The [InternetConnectionChecker] instance to use.
  NetworkFacade({
    required InternetConnectionChecker connectivity,
  }) : _connectivity = connectivity;

  /// A stream that emits the current network status whenever it changes.
  ///
  /// Wraps the [InternetConnectionChecker.onStatusChange] stream and maps its
  /// events to [NetworkStatus] values for consistency with the facade.
  @override
  Stream<NetworkStatus> get onStatusChange {
    return _connectivity.onStatusChange.map(
      (event) {
        return switch (event) {
          InternetConnectionStatus.connected => NetworkStatus.connected,
          InternetConnectionStatus.disconnected => NetworkStatus.disconnected,
        };
      },
    );
  }

  /// The current network status.
  ///
  /// Fetches the current status using [InternetConnectionChecker.hasConnection]
  /// asynchronously.
  @override
  Future<NetworkStatus> get status async {
    final isConnected = await _connectivity.hasConnection;
    return isConnected ? NetworkStatus.connected : NetworkStatus.disconnected;
  }
}
