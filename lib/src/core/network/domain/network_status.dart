/// Enum representing the possible network connectivity states.
enum NetworkStatus {
  /// The app is checking the initial state of the network.
  initializing,

  /// The device is connected to the internet.
  connected,

  /// The device is not connected to the internet.
  disconnected,

  /// The device is connected but the connection is slow
  slow,
}
