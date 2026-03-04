import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Infrastructure layer Socket.IO client
///
/// This client manages the WebSocket connection lifecycle and provides
/// a type-safe interface for socket operations. It should be used within
/// RemoteDataSource implementations, NOT in the application layer.
///
class SocketClient with MLogger implements Disposable {
  SocketClient({required String url, required String token})
    : _url = url,
      _token = token;

  final String _url;
  final String _token;

  io.Socket? _socket;

  final _connectionContr = StreamController<SocketConnectionState>.broadcast();

  final Map<String, List<void Function(dynamic)>> _eventHandlers = {};

  /// Stream of connection state changes
  Stream<SocketConnectionState> get connectionState => _connectionContr.stream;

  /// Current connection status
  bool get isConnected => _socket?.connected ?? false;

  /// Initialize and connect to the socket server
  FutureOr<void> connect() async {
    if (_socket?.connected ?? false) {
      log.f('Already connected');
      return;
    }

    // Dispose old socket if exists
    await _disposeSocket();

    log.i('SocketClient: Connecting to $_url');
    _connectionContr.add(.connecting);

    _socket = io.io(
      _url,
      io.OptionBuilder().setTransports(['websocket']).setQuery({
        'token': _token,
      }).build(),
    );

    _setupConnectionListeners();
    _reattachEventHandlers();
  }

  /// Setup connection lifecycle listeners
  void _setupConnectionListeners() {
    _socket?.onConnect((_) {
      log.i('SocketClient: Connected');
      _connectionContr.add(.connected);
    });

    _socket?.onDisconnect((_) {
      log.d('SocketClient: Disconnected');
      _connectionContr.add(.disconnected);
    });

    _socket?.onReconnect((_) {
      log.i('SocketClient: Reconnected');
      _connectionContr.add(.connected);
    });

    _socket?.onReconnectAttempt((attempt) {
      log.f('SocketClient: Reconnecting... (attempt: $attempt)');
      _connectionContr.add(.reconnecting);
    });

    _socket?.onConnectError((error) {
      log.w('SocketClient: Connection error: $error');
      _connectionContr.add(.error);
    });

    _socket?.onError((error) {
      log.e('SocketClient: Socket error: $error');
      _connectionContr.add(.error);
    });
  }

  /// Reattach all registered event handlers after reconnection
  void _reattachEventHandlers() {
    _eventHandlers.forEach((event, handlers) {
      for (final handler in handlers) {
        _socket?.on(event, handler);
      }
    });
  }

  /// Subscribe to a socket event
  ///
  /// Returns a [SocketSubscription] that can be cancelled
  SocketSubscription on(
    SocketEvent event,
    void Function(dynamic data) handler,
  ) {
    if (_socket == null) {
      log.w('SocketClient: Socket not initialized, queuing for $event');
    }

    // Store handler for reconnection scenarios
    _eventHandlers.putIfAbsent(event.value, () => []).add(handler);

    // Attach to socket if available
    _socket?.on(event.value, handler);

    return SocketSubscription._(event: event, handler: handler, client: this);
  }

  /// Unsubscribe from a socket event
  void _off(SocketEvent event, void Function(dynamic) handler) {
    _eventHandlers[event.value]?.remove(handler);
    if (_eventHandlers[event.value]?.isEmpty ?? false) {
      _eventHandlers.remove(event.value);
    }
    _socket?.off(event.value, handler);
  }

  /// Emit an event to the server
  ///
  /// Throws [SocketNotConnectedException] if socket is not connected
  void emit(String event, dynamic data) {
    if (!isConnected) {
      throw SocketNotConnectedException(
        'Cannot emit "$event": Socket not connected',
      );
    }

    log.e('SocketClient: Emitting event: $event');
    _socket!.emit(event, data);
  }

  /// Emit an event and wait for acknowledgment
  ///
  /// Returns the acknowledgment data from the server
  /// Throws [SocketNotConnectedException] if socket is not connected
  /// Throws [SocketTimeoutException] if acknowledgment times out
  Future<dynamic> emitWithAck(
    SocketEvent event,
    dynamic data, {
    Duration timeout = const Duration(seconds: 20),
  }) async {
    if (!isConnected) {
      throw SocketNotConnectedException(
        'Cannot emit "$event": Socket not connected',
      );
    }

    log.i('SocketClient: Emitting event with ack: $event');

    final completer = Completer<dynamic>();
    Timer? timeoutTimer;

    void ackHandler(dynamic response) {
      timeoutTimer?.cancel();
      if (!completer.isCompleted) {
        log.i('SocketClient: Received ack for event $event');
        completer.complete(response);
      }
    }

    // Set up timeout
    timeoutTimer = Timer(timeout, () {
      if (!completer.isCompleted) {
        log.d('SocketClient: Timeout waiting for ack on event $event');
        completer.completeError(
          SocketTimeoutException(
            'Timeout waiting for acknowledgment on event "$event"',
          ),
        );
      }
    });

    try {
      _socket?.emitWithAck(event.value, data, ack: ackHandler);
      return await completer.future;
    } catch (e) {
      timeoutTimer.cancel();
      rethrow;
    }
  }

  /// Disconnect from the socket server
  Future<void> disconnect() async {
    log.i('SocketClient: Disconnecting...');
    _connectionContr.add(SocketConnectionState.disconnected);
    await _disposeSocket();
  }

  FutureOr<void> _disposeSocket() {
    log.d('Disposing socket internally');
    _socket?.clearListeners();
    _socket?.dispose();
    _socket = null;
  }

  @override
  FutureOr<dynamic> onDispose() async {
    log.d('SocketClient: Disposing');
    await _disposeSocket();
    _eventHandlers.clear();
    await _connectionContr.close();
  }
}

/// Represents a subscription to a socket event
///
/// Call [cancel] to unsubscribe
@immutable
final class SocketSubscription {
  const SocketSubscription._({
    required this.event,
    required this.handler,
    required this.client,
  });

  final SocketEvent event;
  final void Function(dynamic) handler;
  final SocketClient client;

  /// Cancel this subscription
  void cancel() => client._off(event, handler);
}

/// Socket connection states
enum SocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

enum SocketEvent {
  newBroadcast('newBroadcast'),
  endedBroadcast('endedBroadcast'),
  leaveBroadcast('leaveBroadcast'),
  startedBroadcast('startedBroadcast'),
  joinedBroadcast('joinedBroadcast'),
  endBroadcast('endBroadcast'),
  newBroadcastListener('newBroadcastListener'),
  broadcastListenerLeft('broadcastListenerLeft'),
  newMessage('newMessage'),
  editedMessage('editedMessage'),
  deletedMessage('deletedMessage'),
  sendChatMessage('sendChatMessage'),
  editChatMessage('editChatMessage'),
  deleteChatMessage('deleteChatMessage'),
  hostDisconnected('hostDisconnected'),
  hostReconnected('hostReconnected'),
  notification('notification');

  const SocketEvent(this.value);

  final String value;
}
