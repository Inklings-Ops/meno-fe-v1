import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:meno_fe_v1/src/core/network/domain/i_network_facade.dart';
import 'package:meno_fe_v1/src/core/network/domain/network_status.dart';

/// Concrete implementation of the [INetworkFacade] that uses the
/// [InternetConnectionChecker] to monitor network connectivity.
@LazySingleton(as: INetworkFacade)
class NetworkFacade implements INetworkFacade {

  /// Creates a new instance of [NetworkFacade].
  ///
  /// [connectivity]: The [InternetConnectionChecker] instance to use.
  NetworkFacade({
    required InternetConnectionChecker connectivity,
  }) : _connectivity = connectivity;
  /// Manages platform-specific network connectivity checks.
  final InternetConnectionChecker _connectivity;

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
