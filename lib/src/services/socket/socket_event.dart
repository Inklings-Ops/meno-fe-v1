class SocketEvent {
  SocketEvent._();
  static const String connect = 'connect';
  static const String connectError = 'connect_error';
  static const String connectTimeout = 'connect_timeout';
  static const String connecting = 'connecting';
  static const String disconnect = 'disconnect';
  static const String error = 'error';
  static const String reconnect = 'reconnect';
  static const String reconnectAttempt = 'reconnect_attempt';
  static const String reconnectFailed = 'reconnect_failed';
  static const String reconnectError = 'reconnect_error';
  static const String reconnecting = 'reconnecting';
  static const String ping = 'ping';
  static const String pong = 'pong';

  static const String startedBroadcast = 'startedBroadcast';
  static const String endBroadcast = 'endBroadcast';
  static const String endedBroadcast = 'endedBroadcast';
  static const String joinBroadcast = 'joinBroadcast';
  static const String leaveBroadcast = 'leaveBroadcast';
  static const String getLiveBroadcast = 'getLiveBroadcast';
  static const String getBroadcastListeners = 'getBroadcastListeners';
  static const String newBroadcast = 'newBroadcast';
  static const String getLiveBroadcasts = 'getLiveBroadcasts';

  static const String notification = 'notification';

  // deprecated
  static const String newBroadcastListener = 'newBroadcastListener';
  static const String numberOfLiveListeners = 'numberOfLiveListeners';
}
