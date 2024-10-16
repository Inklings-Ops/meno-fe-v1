import 'package:meno_fe_v1/src/core/network/domain/network_status.dart';

/// Abstract class representing a facade for interacting with network 
/// connectivity.
abstract class INetworkFacade {
  /// A stream that emits the current network status whenever it changes.
  ///
  /// Listeners should be added to this stream to react to network connectivity
  /// changes in a timely manner.
  Stream<NetworkStatus> get onStatusChange;

  /// The current network status.
  ///
  /// This can be used to check the network status at a specific point in time,
  /// but it's recommended to use the [onStatusChange] stream for more
  /// reactive handling of network changes.
  Future<NetworkStatus> get status;
}
